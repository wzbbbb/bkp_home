#! /bin/ksh


print_install_usage()
{
   [ ${UXDEBUG:-off} = on ] && set -x
   
  echo ""
  echo " _______________________________________________________ "
  echo ""
  echo " unirun.sh - (c) ORSYP 2008 "
  echo " Purpose :"
  echo " Install UNIJOB "
  echo " Usage is:   unirun.sh <-i|-u> [options]"
  echo "   -i : installation from scratch."
  echo "   -u : upgrade."
  echo "   -h : print this message."  
  echo ""
  echo ""
  echo " Installation options:"
  echo " ---------------------"
  echo "   Full interactive mode: no options"
  echo ""
  echo "   All other switches are optional:"
  echo "   -s: silent mode--> your input is read from a file."   
  echo "   -r: record mode--> your input is recorded in a file for reuse."
  echo "                      this switch is ignored if the -s switch is specified."
  echo "                      the default file is \"${OPTIONS_FILE}\"."   
  echo "   -f <file name>: input or output file for silent or record mode respectively."
  echo ""
  echo "   Example:"
  echo "      Record mode --> an output file will be created"
  echo "             unirun.sh -i -r f my_output_file_path"
  echo ""
  echo "      Silent mode --> an input file will be used to install"
  echo "             unirun.sh -i -s -f my_input_file_path"
  echo ""
  echo ""
  echo ""
  echo " Upgrade options:"
  echo " ----------------"
  echo "   Full interactive mode: no options"
  echo ""
  echo "   All other switches are optional:"   
  echo "   -s: silent mode--> your input is read from a file."   
  echo "   -r: record mode--> your input is recorded in a file for reuse."
  echo "                      this switch is ignored if the -s switch is specified."
  echo "                      the default file is \"${1}/install.file\"."   
  echo "   -f <file name>: input or output file for silent or record mode respectively."
  echo "   -b <backup directory>: A backup is made during upgrade, you can specify a directory "
  echo "                           where your backup will saved, the default is in the root installation directory"
  echo "                           at the node level."   
  echo "                           You must specify the full directory path."      
  echo ""
  echo "   Example:"
  echo "      Record mode --> an output file will be created"
  echo "             unirun.sh -u -r -f my_output_file_path"
  echo ""
  echo "      Silent mode --> an input file will be used to install with a specific backup directory"
  echo "             unirun.sh -u -s -f my_input_file_path -b my_backup_directory"
  echo ""
  echo ""
  echo ""
  echo " _______________________________________________________ "
  echo " "
  echo " "
}

get_kitdir()
{
   [ ${UXDEBUG:-off} = on ] && set -x

   CURRENTDIR=`pwd`
   cd `dirname ${1}`
   TOOLSKITDIR=`pwd`
   cd ..
   KITDIR=`pwd`
   if [ $? -ne 0 ]
   then
      logexit "Cannot access to the Tools kit directory.\ncd on ${KITDIR} failed."
   fi
   cd ${CURRENTDIR}
}

#-------------------------------------------------
# Log functions
# -------------------------------------------------
logecho()
{
   [ ${UXDEBUG:-off} = on ] && set -x
   
   if [ "${LOG_FILE}" != "" ]
   then
     echo $OPTECHO "$@" >> ${LOG_FILE}
   fi
  echo $OPTECHO "$@"
}

logexit()
{
   [ ${UXDEBUG:-off} = on ] && set -x

	logecho ""
	logecho "#--------------------------------------------------"
	logecho "# ---> ERROR:"
	logecho "# -------------------------------------------------"
	logecho ""
   logecho "-----> $@"
	logecho ""
	logecho "#--------------------------------------------------"
	logecho "# Procedure aborted."
	logecho "# -------------------------------------------------"
	logecho ""
   
   [ "${LOG_FILE}" != "" ] &&echo $OPTECHO "Error during procedure, check log file"
   cleaning onerror
   RET=1
   exit 1
}

check_root()
{
   [ ${UXDEBUG:-off} = on ] && set -x

   ID_RESULT=`id | grep "uid=0(root)"`
   if [ $? -ne 0 ]
   then
      logexit "You have to be root user to use this procedure.\nCannot continue."
   fi
}

get_generic_func_value()
{
   [ ${UXDEBUG:-off} = on ] && set -x
      
   get_kitdir ${1}

   DEFAULT_NODE=`uname -n`
   if [ $? -ne 0 ]
   then
      logexit "Uname -r command failed.\nCheck command."
   fi

   # generic variables
   VERSION="1.1.0"   
   NODE_NAME=""
   NODE_NAME_VAR="S_NODENAME"
   DIR_ROOT=""
   DIR_ROOT_VAR="UNI_DIR_ROOT"      
   PRODUCT_NAME="Unijob Agent"   
   UJLOCALHOSTNAME=${DEFAULT_NODE}
   VERSION_VAR="UNI_VERSION"
   
   INTERACTIVE="I"
   SILENT="S"   
   MODE=${INTERACTIVE}
   
   DIR_TMP=/tmp
   DIR_DATA=data
   DIR_APP=app
   DIR_DOC=doc   
   DIR_DLOG=${DIR_DATA}/log  
   DIR_DINST=${DIR_DATA}/install    
   DIR_DUPR=${DIR_DATA}/upr  
   DIR_DTMP=${DIR_DATA}/temp 
   DIR_DDAT=${DIR_DATA}/data  
   DIR_BIN=${DIR_APP}/bin
   DIR_LIB=${DIR_APP}/lib
   DIR_FILES=${DIR_APP}/files

   DIR_BCK=""
   DIR_DINSTDEF=/var/opt

   OPTIONS_FILE=${TOOLSKITDIR}/install.file
   TEMPOSFILE=${DIR_TMP}/os_of_installation.dat
   TEMPLATECONF=unijob.var
   
   EXE_UJB=${DIR_BIN}/unijob
   HIST_INST_FILE=history_installation.txt   
   LOG_FILE=""      
   
   DEFAULT_PORT_IO=""
   DEFAULT_PORT_CAL=""
   DEFAULT_PORT_CDJ=""
   DEFAULT_CENTRALPORT="4184"
   DEFAULT_CENTRALHOST=""
   DEFAULT_CENTRALLOGIN="admin"
   DEFAULT_CENTRALPASSWD=""
   DEFAULT_INSTALLDIR=${DIR_DINSTDEF}/ORSYP/unijob
   
   LIBEL_INSTALLDIR="UniJob root directory           "
         LIBEL_NODE="UniJob node name                "
      LIBEL_PORT_IO="UniJob Port number: IO  Server  "
     LIBEL_PORT_CDJ="UniJob Port number: CDJ Server  "
     LIBEL_PORT_CAL="UniJob Port number: CAL Server  "
     LIBEL_CENTRALHOST="UniViewer Management Server hostname                "
     LIBEL_CENTRALPORT="UniViewer Management Server Port number             "
    LIBEL_CENTRALLOGIN="UniViewer Management Server Administrator Login ID  "
   LIBEL_CENTRALPASSWD="UniViewer Management Server Administrator Password  "   
   
# data for backup restore   
   LEVEL=""
   LEVEL_FULL="full"
   LEVEL_DATA="data"
   LEVEL_CONF="conf"
   
   typeset -i TOTRET=0
}

# -----------------------------------------------------------
# ask for a value in interactive mode
# -----------------------------------------------------------
uniask()
{
   [ ${UXDEBUG:-off} = on ] && set -x
   
   V_ASK_LIBEL=LIBEL_${1}
   V_ASK_DEFAULT=DEFAULT_${1}
   eval "ASK_LIBEL=\$${V_ASK_LIBEL}"
   eval "ASK_DEFAULT=\"\$${V_ASK_DEFAULT}\""

   ANSWER_OK=n
   ANSWER_DEFAULT=n
   while [ "${ANSWER_OK}" = "n" ]
   do
        echo $OPTECHO "${ASK_LIBEL} [${ASK_DEFAULT}] : \c"
         read  ENTER_VALUE
         if [ "${ENTER_VALUE}" = "" ]
         then
            ENTER_VALUE="${ASK_DEFAULT}"
            ANSWER_DEFAULT=y
         fi
         ANSWER_OK=y
         ujcontrol "${1}" "${ENTER_VALUE}"
         if [ $? -ne 0 ]
         then
            ANSWER_OK=n
         fi
   done
   eval "${1}_VALUE=${ENTER_VALUE}"
  echo ""
}

# -----------------------------------------------------------
# write a value in record file
# -----------------------------------------------------------
uniput()
{
   [ ${UXDEBUG:-off} = on ] && set -x
   
   eval "COMMENT_LINE=\"${1} : \$LIBEL_${1}\""
   eval "VALUE_LINE=\" ${1} \$${1}_VALUE\""
   echo "#${COMMENT_LINE}"  >> ${OPTIONS_FILE}
   echo "${VALUE_LINE}"     >> ${OPTIONS_FILE}
   echo " "                 >> ${OPTIONS_FILE}
}

# -----------------------------------------------------------
# read install file in silent mode
# -----------------------------------------------------------
uniget()
{
   [ ${UXDEBUG:-off} = on ] && set -x
   
   COMMENT=`echo ${1} | awk '{ print substr ($1,1,1)}' `
   if [ "${COMMENT}" =  '#' ]
   then
       return 1
   fi
   if [ "${1}" != "${2}" ]
   then
      return 1
   fi
   if [ "${3}" = "" ]
   then
       eval "${1}_VALUE=\"\""
   else
        eval "${1}_VALUE=${3}"
        eval "ASK_LIBEL=\$LIBEL_${1}"
   fi

   if [ "${1}" = "node" ] && [ "${3}" = "default_value" ]
   then
      echo "${ASK_LIBEL} => ${DEFAULT_NODE} [${3}]"
       ujcontrol ${1} ${DEFAULT_NODE}
   else
      echo "${ASK_LIBEL} => ${3}"
       ujcontrol ${1} ${3}
   fi
   if [ $? -ne 0 ]
   then
       logexit "Invalid answer found in the response file for parameter ${1} [${3}] \nResponse file = ${OPTIONS_FILE}"
   fi
   return 0
}

# -----------------------------------------------------------
# read install file in silent mode
# -----------------------------------------------------------
uniread()
{
   [ ${UXDEBUG:-off} = on ] && set -x
   
   while read UJLINE
   do
      uniget "${1}" ${UJLINE}
      if [ "$?" -eq 0 ]
      then
         return 0
      fi
   done < ${OPTIONS_FILE}
   logexit "No Answer found in response file for parameter \"${1}\"\nResponse file = ${OPTIONS_FILE}"
}

# -----------------------------------------------------------
# get a response and check its validity
# -----------------------------------------------------------
checkresponse()
{
   [ ${UXDEBUG:-off} = on ] && set -x

   unset response
   TEXT="${1}"
   shift
   while [ 1 ]
   do
     echo $OPTECHO ${TEXT}   
      read response
      for value in $@
      do
         if [ "${response}" = "${value}" ]
         then
            return 0
         fi
      done
   done
}

# -----------------------------------------------------------
# log and execute a command
# -----------------------------------------------------------
uniexecute()
{
   [ ${UXDEBUG:-off} = on ] && set -x

   CMD="${1}"
   logecho "--> executing : ${CMD}"
   
   if [ "${2}" = "errignore" ]
   then
      SERR="2>/dev/null"
   else
      SERR="2>&1"
   fi
   
   if [ "${LOG_FILE}" != "" ]
   then
      SOUT=">${LOG_FILE}.temp"
   else
      SOUT=""
   fi
   
   eval "${CMD} ${SOUT} ${SERR}"
   RET=$?            
   
   if [ "${LOG_FILE}" != "" ]
   then
      cat ${LOG_FILE}.temp
      cat ${LOG_FILE}.temp >> ${LOG_FILE}
   fi
   
   return ${RET}
}
      
startunijob()
{
   [ ${UXDEBUG:-off} = on ] && set -x

   typeset -i i=0
   typeset -i NBOUTENGINE
   
	logecho ""
	logecho "#--------------------------------------------------"
	logecho "# Starting Unijob."
	logecho "# -------------------------------------------------"
	logecho ""
   uniexecute "${DIR_ROOT}/${DIR_DATA}/unistartuj"
   
   while [ $i -lt 20 ]
   do
      sleep 1
      NBOUTENGINE=`ps -edf | sed -e 's/$/ /' | grep " ${NODE_NAME:-NoVaLue} " | egrep "uniio|unicdj|unilan|unical" | wc -l`
      if [ ${NBOUTENGINE} -eq 4 ]
      then 
         logecho "# -------------------------------------------------"   
         logecho "# Unijob started."
         logecho "# -------------------------------------------------"
         RET=0 
         return ${RET}
      fi
      i=$i+1
   done

   logecho "# -------------------------------------------------"   
   logecho "# Problem during Unijob start."
   logecho "# -------------------------------------------------"   
   RET=1   
   return ${RET}
}

stopunijob()
{
   [ ${UXDEBUG:-off} = on ] && set -x
   
   typeset -i i=0   
   typeset -i NBOUTENGINE

   NBOUTENGINE=`ps -edf | sed -e 's/$/ /' | grep " ${NODE_NAME:-NoVaLue} " | egrep "uniio|unicdj|unilan|unical" | wc -l`
   if [ ${NBOUTENGINE} -eq 0 ]
   then
      logecho "#--------------------------------------------------"
      logecho "# Unijob already stopped."
      logecho "# -------------------------------------------------"
      return 0
   fi

	logecho ""
	logecho "#--------------------------------------------------"
	logecho "# Stopping Unijob."
	logecho "# -------------------------------------------------"
	logecho ""

   uniexecute "${DIR_ROOT}/${DIR_DATA}/unistopuj"
   if [ $? -ne 0 ]
   then
      logexit "Error during stop of Unijob."
   fi
   
   check_stop
   if [ $? -ne 0 ]
   then
      logexit "Cannot stop Unijob--> stop process"
   fi
}

# -----------------------------------------------------------
# Check if unijob is stopped
# -----------------------------------------------------------
check_stop()
{
   [ ${UXDEBUG:-off} = on ] && set -x

   typeset -i i=0   
   typeset -i NBOUTENGINE

   while [ $i -lt 20 ]
   do
      logecho ".\c"   
      sleep 1
      NBOUTENGINE=`ps -edf | sed -e 's/$/ /' | grep " ${NODE_NAME:-NoVaLue} " | egrep "uniio|unicdj|unilan|unical" | wc -l`
      if [ ${NBOUTENGINE} -eq 0 ]
      then 
         logecho "# -------------------------------------------------"   
         logecho "# Unijob stopped."
         logecho "# -------------------------------------------------"
         RET=0 
         return ${RET}
      fi
      i=$i+1
   done
   RET=1
   return ${RET}
}

#------------------------
# get environment
#------------------------
getenv()
{
   [ ${UXDEBUG:-off} = on ] && set -x

   # script is in app/files/
   . ${1}/data/unienv.ksh
   if [ $? -ne 0 ]
   then
      logexit "Cannot access environnement."
   fi
   NODE_NAME=`${1}/app/bin/getvar ${NODE_NAME_VAR}`
   DIR_ROOT=`${1}/app/bin/getvar ${DIR_ROOT_VAR}`
   UNI_VERSION=`${1}/app/bin/getvar ${VERSION_VAR}`
}

# -----------------------------------------------------------
# Check system requirement
# -----------------------------------------------------------
check_system_requirement()
{
   [ ${UXDEBUG:-off} = on ] && set -x
   
   chmod a+rx  ${TOOLSKITDIR}/get_sys_config.ksh
   chmod a+rx  ${TOOLSKITDIR}/u_check_system.ksh
   chmod a+rx  ${TOOLSKITDIR}/u_install_getuadm
   ${TOOLSKITDIR}/get_sys_config.ksh ${TEMPOSFILE}
   if [ $? -ne 0 ]
   then
      logexit "Cannot write os_customer.dat in temporary folder (${TEMPOSFILE}).\nCheck accessibility to folder."
   fi

   # Checking system prerequisites (by comparing the 2 files describing OS) :
   ${TOOLSKITDIR}/u_check_system.ksh ${TOOLSKITDIR}/os_release.dat ${TEMPOSFILE}
   if [ $? -ne 0 ]
   then
      logexit "Cancelling the install procedure!"
   fi
}

# -----------------------------------------------------------
# Put ad-hoc rights
# -----------------------------------------------------------
unichgrp()
{
   [ ${UXDEBUG:-off} = on ] && set -x
   
   if [ ${#} -le 2 ]
   then
       return 1
   fi
   NBREP=${#}
   i=2
   ADMINGROUP=${1}

   while [ ${i} -le ${NBREP} ]
   do
      shift
      cd ${1}
      if [ $? -ne 0 ]
      then
          logexit "Cannot access to the directory ${1}.\ncd on ${1} failed."
      fi
      REP=`pwd`
      if [ "${REP}" = "/" ]
      then
          logexit "bad directory://\nshould not occur."
      fi

      if [ "`ls >/dev/null 2>&1`" ]
      then
          chown root *
          chgrp ${ADMINGROUP} *
      fi
      cd ..

      chown root        ${OLDPWD}
      chgrp $ADMINGROUP ${OLDPWD}
      let i=i+1
   done
   return 0
}

unichmod()
{
   [ ${UXDEBUG:-off} = on ] && set -x
   
   # set the rigths group
   ADMINGRP=`${TOOLSKITDIR}/u_install_getuadm root`
   REPERT_LIST="${DIR_ROOT}/${DIR_DATA}"
   REPERT_LIST="${REPERT_LIST} ${DIR_ROOT}/${DIR_DDAT}"
   REPERT_LIST="${REPERT_LIST} ${DIR_ROOT}/${DIR_DLOG}"
   REPERT_LIST="${REPERT_LIST} ${DIR_ROOT}/${DIR_DUPR}"
   REPERT_LIST="${REPERT_LIST} ${DIR_ROOT}/${DIR_DTMP}"
   REPERT_LIST="${REPERT_LIST} ${DIR_ROOT}/${DIR_APP}"
   REPERT_LIST="${REPERT_LIST} ${DIR_ROOT}/${DIR_FILES}"
   REPERT_LIST="${REPERT_LIST} ${DIR_ROOT}/${DIR_BIN}"
   REPERT_LIST="${REPERT_LIST} ${DIR_ROOT}/${DIR_LIB}"
   unichgrp ${ADMINGRP} ${REPERT_LIST}

   chmod 0755 ${DIR_ROOT}/${DIR_DATA}
   TOTRET=${TOTRET}+$?
   chmod 0755 ${DIR_ROOT}/${DIR_DATA}/*
   TOTRET=${TOTRET}+$?
   
   chmod 0755 ${DIR_ROOT}/${DIR_DDAT}
   TOTRET=${TOTRET}+$?
   chmod 0777 ${DIR_ROOT}/${DIR_DLOG}
   TOTRET=${TOTRET}+$?
   chmod 0777 ${DIR_ROOT}/${DIR_DUPR}
   TOTRET=${TOTRET}+$?
   chmod 0777 ${DIR_ROOT}/${DIR_DTMP}
   TOTRET=${TOTRET}+$?
   
   chmod 0755 ${DIR_ROOT}/${DIR_APP}
   TOTRET=${TOTRET}+$?
   
   chmod 0755 ${DIR_ROOT}/${DIR_FILES}
   TOTRET=${TOTRET}+$?
   chmod 0555 ${DIR_ROOT}/${DIR_FILES}/*
   TOTRET=${TOTRET}+$?
   
   chmod 0755 ${DIR_ROOT}/${DIR_BIN}
   TOTRET=${TOTRET}+$?
   chmod 0500 ${DIR_ROOT}/${DIR_BIN}/*
   TOTRET=${TOTRET}+$?
   
   chmod 0755 ${DIR_ROOT}/${DIR_LIB}
   TOTRET=${TOTRET}+$?
   chmod 0555 ${DIR_ROOT}/${DIR_LIB}/*
   TOTRET=${TOTRET}+$?

#   chmod 0555 ${DIR_ROOT}/${DIR_DOC}
#   TOTRET=${TOTRET}+$?   
#   chmod 0544 ${DIR_ROOT}/${DIR_DOC}/*
#   TOTRET=${TOTRET}+$?
   chmod 0544 ${DIR_ROOT}/*.txt
   TOTRET=${TOTRET}+$?
   
   # update of the rights given to the main binaries
   # batch binaries --> r-xr-xr-x
   # other binaries --> r-x------
   chmod 0555 ${DIR_ROOT}/${DIR_BIN}/getvar
   TOTRET=${TOTRET}+$?
   chmod 0555 ${DIR_ROOT}/${DIR_BIN}/uxjobinit
   TOTRET=${TOTRET}+$?
   chmod 0555 ${DIR_ROOT}/${DIR_BIN}/uxjobend
   TOTRET=${TOTRET}+$?
   chmod 0555 ${DIR_ROOT}/${DIR_BIN}/uxjobstatus
   TOTRET=${TOTRET}+$?
   chmod 0555 ${DIR_ROOT}/${DIR_BIN}/uxstrcmd
   TOTRET=${TOTRET}+$?
   chmod u+s  ${DIR_ROOT}/${DIR_BIN}/unilan
   TOTRET=${TOTRET}+$?

   chmod 0644 ${DIR_ROOT}/${DIR_FILES}/variables.xml
   TOTRET=${TOTRET}+$?

   chmod 0700 ${DIR_ROOT}/${DIR_DATA}/uni*uj
   TOTRET=${TOTRET}+$?

   if [ -f ${DIR_ROOT}/${DIR_DATA}/phrase.key ]
   then
      chmod 0700 ${DIR_ROOT}/${DIR_DATA}/phrase.key
      TOTRET=${TOTRET}+$?
   fi
   chmod 0755 ${DIR_ROOT}/${DIR_DATA}/unienv.*
   TOTRET=${TOTRET}+$?
   chmod 0755 ${DIR_ROOT}/${DIR_FILES}/u_batch*
   TOTRET=${TOTRET}+$?
   chmod 0755 ${DIR_ROOT}/${DIR_FILES}/uniupdate*
   TOTRET=${TOTRET}+$?
   chmod 0755 ${DIR_ROOT}/${DIR_DATA}/values.xml
   TOTRET=${TOTRET}+$?

   if [ -f ${DIR_ROOT}/${DIR_DATA}/shell.dat  ]
   then
      chmod 0755 ${DIR_ROOT}/${DIR_DATA}/shell.dat
      TOTRET=${TOTRET}+$?
   fi

   if [ -f ${DIR_ROOT}/${DIR_DATA}/local.key ]
   then
      chmod 0755 ${DIR_ROOT}/${DIR_DATA}/local.key
      TOTRET=${TOTRET}+$?
   fi
   chmod 0644  ${DIR_ROOT}/${DIR_DATA}/*.dta
   TOTRET=${TOTRET}+$?

   chmod 0644 ${DIR_ROOT}/${DIR_DDAT}/*.dta*
   TOTRET=${TOTRET}+$?
   chmod 0644 ${DIR_ROOT}/${DIR_DDAT}/*.idx*
   TOTRET=${TOTRET}+$?
   chmod 0444 ${DIR_ROOT}/${DIR_APP}/uxtrace/*   
   TOTRET=${TOTRET}+$?
   chmod 0700 ${DIR_ROOT}/${DIR_APP}/uxtrace/uxtrace
   TOTRET=${TOTRET}+$?
}

# -----------------------------------------------------------
# Configuration tools
# -----------------------------------------------------------
create_template()
{
   # Create configuration file  from template
   echo "install_root_value      ${DIR_ROOT}"            > ${DIR_TMP}/${TEMPLATECONF}_$$
   echo "s_nodename_value        ${NODE_VALUE}"         >> ${DIR_TMP}/${TEMPLATECONF}_$$
   echo "u_localhostname_value   ${UJLOCALHOSTNAME}"    >> ${DIR_TMP}/${TEMPLATECONF}_$$
   echo "u_os_value              ${UXOS}"               >> ${DIR_TMP}/${TEMPLATECONF}_$$
   echo "aut_central_port_value  ${CENTRALPORT_VALUE}"  >> ${DIR_TMP}/${TEMPLATECONF}_$$
   echo "aut_central_host_value  ${CENTRALHOST_VALUE}"  >> ${DIR_TMP}/${TEMPLATECONF}_$$
}

file_config()
{
   [ ${UXDEBUG:-off} = on ] && set -x
   
   ${TOOLSKITDIR}/uxinsmod ${DIR_TMP}/${TEMPLATECONF}_$$  ${1}   ${1}_new
   if [ $? -ne 0 ]
   then
      logexit "Unable to create configuration file ${1}_new"
   fi
   mv ${1}_new ${1}
   if [ $? -ne 0 ]
   then
      logexit "Unable to create configuration file ${1}"
   fi
}

installation_get_os()
{
   [ ${UXDEBUG:-off} = on ] && set -x
   
   UXOS=`uname -s`
   if [ "${UXOS}" = "SunOS" ]
   then
           UXOS=SOLARIS
   elif [ "${UXOS}" = "AIX" ]
   then
           UXOS=AIX
   elif [ "${UXOS}" = "HP-UX" ]
   then
           UXOS=HPUX
   elif [ "${UXOS}" = "Linux" ]
   then
     if [ -f /etc/mandrake-release ]
     then
             UXOS=LINUX_MANDRAKE
     elif [ -f /etc/SuSE-release ]
     then
             UXOS=LINUX_SUSE
     elif [ -f /etc/debian_version ]
     then
             UXOS=LINUX_DEBIAN
     elif [ -f /etc/redhat-release ]
     then
             UXOS=LINUX_REDHAT
     elif [ -f /etc/UnitedLinux-release ]
     then
             UXOS=LINUX_UNITED
     fi
   fi
}

#----------------------------------------------
# command for managing package
#----------------------------------------------
package()
{
   [ ${UXDEBUG:-off} = on ] && set -x

   TARZ=on
   CMD=${1}
   
   tar zcf - `which tar` >/dev/null 2>&1
   if [ $? -ne 0 ]
   then
      TARZ=off
      CPRSCMD=`which compress 2>&1|cut -d" " -f1`
      if [ ! -f ${CPRSCMD} ]
      then 
         logexit "Cannot find compress and tar -z is not available --> cannot continue"
      fi
   fi
   
   if [ "${CMD}" = "compress" ]
   then
      INPUT=${2}
      OUTPUT=${3}
      ERROR=${4}
      TAROPT=${5}   
      
      touch ${ERROR}
      if [ "${TARZ}" = "on" ]
      then
         tar zcvf - ${TAROPT} ${INPUT} 2>${ERROR} > ${OUTPUT}  
         NRET=$?
      else
         tar cvf - ${TAROPT} ${INPUT} 2> ${LOG_FILE} | compress > ${OUTPUT} 
         NRET=$?
      fi
   elif [ "${CMD}" = "uncompress" ]
   then
      INPUT=${2}
      OUTPUT=${3}
      ERROR=${4}
      
      if [ "${TARZ}" = "on" ]
      then
         tar zxvf - <${INPUT} >${OUTPUT} 
         NRET=$?         
      else
         uncompress -c <${INPUT} | tar xvf - >${OUTPUT}
         NRET=$?
      fi
   elif [ "${CMD}" = "check" ]
   then
      INPUT=${2}
      OUTPUT=${3}
      ERROR=${4}
      
      if [ "${TARZ}" = "on" ]
      then
         tar ztvf - <${INPUT} >${OUTPUT}   
         NRET=$?
      else
         uncompress -c <${INPUT} | tar tvf - >${OUTPUT} 
         NRET=$?
      fi
   fi
   
   return ${NRET}
}

# -----------------------------------------------------------
# Disclaimer
# -----------------------------------------------------------
disclaimer()
{
   echo "# ----------------------------------------------------------------------"
   echo "# Orsyp licence agreement:"
   echo "# Please, read Orsyp licence agreement, press <space bar> to read next page"
   echo
   echo "# Press return to continue"
   read
   more ${KITDIR}/license.txt   
   echo 
   echo "Do you accept the agreement ?"
   checkresponse "--> (\"y\" to accept, \"n\" to decline and abort procedure)? \c" y n
   [ "${response}" != "y" ] && logexit "Procedure aborted by user."
   

   logecho "# --------------------------------------------------------------------"   
}













#! /bin/ksh


print_install_usage()
{
   [ ${UXDEBUG:-off} = on ] && set -x
   
  echo ""
  echo " _______________________________________________________ "
  echo ""
  echo " unirun.sh - (c) ORSYP 2008 "
  echo " Purpose:"
  echo " Install UniViewer Management Server "
  echo " Usage is:   unirun.sh <-i|-u> [options]"
  echo "   -i: installation from scratch."
  echo "   -u: upgrade."
  echo "   -h: print this message."  
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

   UVLOCALHOSTNAME=`uname -n`
   DEFAULT_NODE=${UVLOCALHOSTNAME}_MgtServer
   if [ $? -ne 0 ]
   then
      logexit "Uname -n command failed.\nCheck command."
   fi

   # generic variables
   VERSION="1.1.0"   
   NODE_NAME=""
   NODE_NAME_VAR="S_NODENAME"
   DIR_ROOT=""
   DIR_ROOT_VAR="UNI_DIR_ROOT"      
   PRODUCT_NAME="UniViewer Management Server" 
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
   DIR_DJTP=${DIR_DATA}/jobtemplates
   DIR_DTMP=${DIR_DATA}/temp 
   DIR_DDAT=${DIR_DATA}/data  
   DIR_JAR=${DIR_APP}/jars
   DIR_FILES=${DIR_APP}/files

   DIR_BCK=""
   DIR_DINSTDEF=/var/opt

   OPTIONS_FILE=${KITDIR}/install.file
   TEMPLATECONF=uvcentral.var
   
   HIST_INST_FILE=history_installation.txt   
   LOG_FILE=""      
   
   DEFAULT_PORT_AGTIO="52001"
   DEFAULT_PORT_AGTCAL="52003" 
   DEFAULT_PORT_AGTCDJ="52002" 
   DEFAULT_CENTRALPORT="4184"
   DEFAULT_CENTRALLOGIN="admin"
   DEFAULT_CENTRALPASSWD=""
   DEFAULT_INSTALLDIR=${DIR_DINSTDEF}/ORSYP/univiewer_server
   
      LIBEL_INSTALLDIR="UniViewer Management Server root directory           "
            LIBEL_NODE="UniViewer Management Server node name                "
      LIBEL_PORT_AGTIO="UniJob Server Port number: I/O  Server  "
     LIBEL_PORT_AGTCDJ="UniJob Server Port number: CDJ Server  "
     LIBEL_PORT_AGTCAL="UniJob Server Port number: CAL Server  "
     LIBEL_CENTRALPORT="UniViewer Management Server main port number             "
    LIBEL_CENTRALLOGIN="UniViewer Management Server Administrator Login ID  "
   LIBEL_CENTRALPASSWD="UniViewer Management Server Administrator Password  "    
   
# min java version   
   JAVA_REQ_VERSION=150
   
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
   
   while read UVLINE
   do
      uniget "${1}" ${UVLINE}
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
   NODE_NAME=`${JAVA_EXE} -jar ${1}/app/jars/getvar.jar ${NODE_NAME_VAR}`
   DIR_ROOT=`${JAVA_EXE} -jar ${1}/app/jars/getvar.jar ${DIR_ROOT_VAR}`
   UNI_VERSION=`${JAVA_EXE} -jar ${1}/app/jars/getvar.jar ${VERSION_VAR}`
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
   typeset -i TOTRET=0
   
   # set the rigths group
   ADMINGRP=`${TOOLSKITDIR}/unigetuadm.ksh root`
   REPERT_LIST="${DIR_ROOT}/${DIR_DATA}"
   REPERT_LIST="${REPERT_LIST} ${DIR_ROOT}/${DIR_DDAT}"
   REPERT_LIST="${REPERT_LIST} ${DIR_ROOT}/${DIR_DLOG}"
   REPERT_LIST="${REPERT_LIST} ${DIR_ROOT}/${DIR_DJTP}"
   REPERT_LIST="${REPERT_LIST} ${DIR_ROOT}/${DIR_DTMP}"
   REPERT_LIST="${REPERT_LIST} ${DIR_ROOT}/${DIR_APP}"
   REPERT_LIST="${REPERT_LIST} ${DIR_ROOT}/${DIR_FILES}"
   REPERT_LIST="${REPERT_LIST} ${DIR_ROOT}/${DIR_JAR}"
   unichgrp ${ADMINGRP} ${REPERT_LIST}
   

   chmod 0755 ${DIR_ROOT}/${DIR_DATA}
   TOTRET=${TOTRET}+$?
   chmod 0755 ${DIR_ROOT}/${DIR_DATA}/*
   TOTRET=${TOTRET}+$?   
   chmod 0755 ${DIR_ROOT}/${DIR_DDAT}
   TOTRET=${TOTRET}+$?
   chmod 0777 ${DIR_ROOT}/${DIR_DLOG}
   TOTRET=${TOTRET}+$?
   chmod 0777 ${DIR_ROOT}/${DIR_DJTP}
   TOTRET=${TOTRET}+$?
   chmod 0777 ${DIR_ROOT}/${DIR_DTMP}
   TOTRET=${TOTRET}+$?
   
   chmod 0755 ${DIR_ROOT}/${DIR_APP}
   TOTRET=${TOTRET}+$?
   
   chmod 0755 ${DIR_ROOT}/${DIR_FILES}
   TOTRET=${TOTRET}+$?
   chmod 0555 ${DIR_ROOT}/${DIR_FILES}/*
   TOTRET=${TOTRET}+$?
   
   chmod 0755 ${DIR_ROOT}/${DIR_JAR}
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
   chmod 0644 ${DIR_ROOT}/${DIR_FILES}/variables.xml
   TOTRET=${TOTRET}+$?

   chmod 0755 ${DIR_ROOT}/${DIR_DATA}/unienv.*
   TOTRET=${TOTRET}+$?
   chmod 0755 ${DIR_ROOT}/${DIR_DATA}/uni*ms
   TOTRET=${TOTRET}+$?
   chmod 0755 ${DIR_ROOT}/${DIR_DATA}/values.xml
   TOTRET=${TOTRET}+$?

   chmod 0444 ${DIR_ROOT}/${DIR_APP}/uxtrace/*   
   TOTRET=${TOTRET}+$?
   chmod 0700 ${DIR_ROOT}/${DIR_APP}/uxtrace/uxtrace
   TOTRET=${TOTRET}+$?
   
   return ${TOTRET}
}

# -----------------------------------------------------------
# Configuration tools
# -----------------------------------------------------------
create_template()
{
   # Create configuration file  from template
   echo "install_root_value=${DIR_ROOT}"                 >  ${DIR_TMP}/${TEMPLATECONF}_$$
   echo "s_nodename_value=${NODE_VALUE}"                 >> ${DIR_TMP}/${TEMPLATECONF}_$$
   echo "u_localhostname_value=`hostname`"               >> ${DIR_TMP}/${TEMPLATECONF}_$$   
   echo "u_os_value=${UVOS}"                             >> ${DIR_TMP}/${TEMPLATECONF}_$$
   echo "aut_central_port_value=${CENTRALPORT_VALUE}"    >> ${DIR_TMP}/${TEMPLATECONF}_$$
   echo "username_value=${CENTRALLOGIN_VALUE}"           >> ${DIR_TMP}/${TEMPLATECONF}_$$
   echo "cdj_default_port_value=${PORT_AGTCDJ_VALUE}"    >> ${DIR_TMP}/${TEMPLATECONF}_$$
   echo "io_default_port_value=${PORT_AGTIO_VALUE}"      >> ${DIR_TMP}/${TEMPLATECONF}_$$
   echo "cal_default_port_value=${PORT_AGTCAL_VALUE}"    >> ${DIR_TMP}/${TEMPLATECONF}_$$
   echo "java_exe_path_value=${JAVA_EXE}"                >> ${DIR_TMP}/${TEMPLATECONF}_$$
}

file_config()
{
   [ ${UXDEBUG:-off} = on ] && set -x
   
   ${JAVA_EXE} -jar ${DIR_ROOT}/${DIR_JAR}/uxinsmod.jar ${DIR_TMP}/${TEMPLATECONF}_$$  ${1}   ${1}_new
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
   
   UVOS=`uname -s`
   if [ "${UVOS}" = "SunOS" ]
   then
           UVOS=SOLARIS
   elif [ "${UVOS}" = "AIX" ]
   then
           UVOS=AIX
   elif [ "${UVOS}" = "HP-UX" ]
   then
           UVOS=HPUX
   elif [ "${UVOS}" = "Linux" ]
   then
     if [ -f /etc/mandrake-release ]
     then
             UVOS=LINUX_MANDRAKE
     elif [ -f /etc/SuSE-release ]
     then
             UVOS=LINUX_SUSE
     elif [ -f /etc/debian_version ]
     then
             UVOS=LINUX_DEBIAN
     elif [ -f /etc/redhat-release ]
     then
             UVOS=LINUX_REDHAT
     elif [ -f /etc/UnitedLinux-release ]
     then
             UVOS=LINUX_UNITED
     fi
   fi
}

#! /bin/ksh
#
# ===============================================================
# ORSYP SA
# Checking the Java version
# ===============================================================
#
# This script attempts to find an existing installation of Java that meets a minimum version
# requirement on a Linux machine.  If it is unsuccessful, it will ask for a valid version 
#
check_java()
{
   [ ${UXDEBUG:-off} = on ] && set -x
   
   TMPFILE=/tmp/uv_$$.ver

   check_javaversion()
   {
      [ ${UXDEBUG:-off} = on ] && set -x

      ${JAVA_EXE} -version 2>${TMPFILE}
      JAVA_VERSION=`grep "java version" ${TMPFILE} | cut -d"\"" -f2 | cut -d"." -f1`
      JAVA_VERSION=${JAVA_VERSION}`grep "java version" ${TMPFILE} | cut -d"\"" -f2 | cut -d"." -f2`
      JAVA_VERSION=${JAVA_VERSION}`grep "java version" ${TMPFILE} | cut -d"\"" -f2 | cut -d"." -f3 | cut -d"_" -f1`
      
      rm ${TMPFILE}

      if [ "${JAVA_VERSION}" = "" ]
      then
         return 1
      fi
      let NVERS="${JAVA_VERSION}" >/dev/null 2>&1
      if [ $? -ne 0 ]
      then
         logecho "Cannot retrieve correct java version from ${JAVA_EXE}."
         return 1
      fi

      if [ ${NVERS} -ge ${JAVA_REQ_VERSION} ]
      then
         return 0
      fi

      # not found available jvm
      return 1
   }

	touch ${TMPFILE}
   if [ $? -ne 0 ]
   then
      logexit "Cannot create temporary file (${TMPFILE}) please check accessibility"
   fi

	#try to find java in a list
	for JAVA_EXE in \
         java \
         ${JAVA_HOME}/bin/java
   do
      check_javaversion
      if [ $? -eq 0 ]
      then
         logecho "Java found at ${JAVA_EXE} with version ${JAVA_VERSION}."
         export JAVA_EXE
         return 0
      fi
   done
   
   while [ 1 ]
   do
      echo
      echo $OPTECHO "Please give full path for a java command matching ${JAVA_REQ_VERSION} version or higher ? -->\c"
      read JAVA_EXE
      if [ $"{JAVA_EXE}" = "" ]
      then
         break;
      fi
      
      check_javaversion
      if [ $? -eq 0 ]
      then
         logecho "Java found at ${JAVA_EXE} with version ${JAVA_VERSION}."
         export JAVA_EXE
         return 0
      fi
   done
      

   logexit "No available java (version >= ${JAVA_REQ_VERSION}) found!"
}

# -----------------------------------------------------------
# Check if UniViewer MS is stopped
# -----------------------------------------------------------
check_stop()
{
   [ ${UXDEBUG:-off} = on ] && set -x

   typeset -i i=0   
   typeset -i NBOUTENGINE

   while [ $i -lt 120 ]
   do
      logecho ".\c"
      sleep 1
      NBOUTENGINE=`ps -edf | grep "\/${NODE_NAME:-NoVaLue}\/" | egrep "centralserver-start" | wc -l`
      if [ ${NBOUTENGINE} -eq 0 ]
      then 
         logecho "# -------------------------------------------------"   
         logecho "# UniViewer Management Server stopped."
         logecho "# -------------------------------------------------"
         RET=0 
         return ${RET}
      fi
      i=$i+1
   done
   RET=1
   return ${RET}
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

#! /bin/ksh
# ============================================================================
# ORSYP SA                                                          2008/11/28
#
# UniJob Backup Procedure                                                (ERO)
# ============================================================================

# No comment the 4 following lines to start trace mode
#   UXDEBUG=on
# Trace mode activation
[ ${UXDEBUG:-off} = on ] && set -x

# ============================================================================
# Definition
# ============================================================================

initdata()
{
   [ ${UXDEBUG:-off} = on ] && set -x

   get_generic_func_value ${1}
   LOG_NAME="orsyp_backup.log"
}

cleaning()
{
   [ ${UXDEBUG:-off} = on ] && set -x

   if [ "${1}" = "onerror" ]
   then
      [ -d "${DIR_BCK}" ] && /bin/rm -rf ${DIR_BCK}
   else
      if [ "${LOG_FILE}" != "" ]
      then
         /bin/rm -f ${LOG_FILE}.temp_tar
         /bin/rm -f ${LOG_FILE}.temp_compress   
         /bin/rm -f ${LOG_FILE}.temp         
      fi
   fi
   if [ "${LOG_FILE}" != "" ]
   then
      chmod -w ${LOG_FILE}
     echo "Log file is ${LOG_FILE}"
   fi
   
   [ -d "${DIR_BCK}" ] && chmod -R -w ${DIR_BCK}
}

#-------------------------------------------------
# Usage display 
# -------------------------------------------------
usage()
{
   [ ${UXDEBUG:-off} = on ] && set -x
 
   echo ""
   echo "    UniJob backup tool."
   echo "    This tool make a full or partial backup of a UniJob node."
   echo "    Note that before using that tool, the user must have checked that there is enough disk space."
   echo ""
   echo "    Usage   : unibackup.ksh [-s -b <Backup Directory> -l <${LEVEL_FULL}|${LEVEL_DATA}>|${LEVEL_CONF}]"
   echo ""
   echo "              without argument unibackup.ksh starts in an intercative mode: all values will be asked."
   echo "              with silent mode option (-s) all arguments must be passed in the command."    
   echo ""
   echo "              -b <Backup Directory>        : the full path of the backup directory, it must not exist"
   echo "                                             the tool creates it."
   echo ""
   echo "              -l backup level:"
   echo "                 The Backup for UniJob Agent offers 2 levels of backout security requiring"
   echo "                 different amounts of disk space." 
   echo "                 - ${LEVEL_CONF}   : Not implemented."     
   echo "                 - ${LEVEL_DATA}   : only data files are saved."
   echo "                    This solution will need less space but job monitoring and all."
   echo "                    historical data will be lost during backout." 
   echo "                 - ${LEVEL_FULL}      : Executables, parameter data files and operations data files"
   echo "                    are all saved. Backout will restore the exact situation."
   echo ""
   echo "              -h option prints that message."    
   echo ""              
   echo "" 
   echo "    Example : unibackup.ksh -s -b /backup/ORSYP/MY_NODE"
   echo ""
   echo ""
}

ask_value()
{
   [ ${UXDEBUG:-off} = on ] && set -x

  echo
  echo "Please confirm node name = ${NODE_NAME}"
   checkresponse "--> (\"y\" to continue, \"n\" to abort procedure)\c" y n
   [ "${response}" != "y" ] && logexit "Backup aborted by user."

  echo
  echo "Please confirm Root Directory = ${DIR_ROOT}"
   checkresponse "--> (\"y\" to continue, \"n\" to abort procedure)?\c" y n
   [ "${response}" != "y" ] && logexit "Backup aborted by user."
   
  echo
  echo "Please give full path for Backup Directory ?"
   read DIR_BCK

  echo
  echo "Please backup level (\"${LEVEL_FULL}\", \"${LEVEL_DATA}\" or \"${LEVEL_CONF}\", see usage for details)"
   checkresponse "--> level ?\c" ${LEVEL_FULL} ${LEVEL_DATA} ${LEVEL_CONF}
   LEVEL=${response}
}

#-------------------------------------------------
# Get and check validity of the arguments
# ------------------------------------------------
acquireopt()
{
   [ ${UXDEBUG:-off} = on ] && set -x

   while getopts "shb:l:" opt
   do
      case $opt in

      b)  DIR_BCK=$OPTARG ;;
      l)  LEVEL=$OPTARG ;;
      s)  MODE=${SILENT} ;;
      h)  usage
           exit 0;;
      *)   usage
           exit 1;;      
      \?)  usage
           exit 1;;            
      esac
   done

   if [ "${MODE}" = "${INTERACTIVE}" ]
   then
      if [ $# -gt 1 ]
      then
        echo "Interactive Mode."
        echo "Note that arguments passed are ignored."
      fi
      ask_value
   fi
}

#-------------------------------------------------
# Check validity of options
# ------------------------------------------------
checkopt()
{
   [ ${UXDEBUG:-off} = on ] && set -x

   if [ "${LEVEL}" = "" ]  || [ "${DIR_ROOT}" = "" ] || [ "${NODE_NAME}" = "" ] || [ "${DIR_BCK}" = "" ]
   then
      logexit "You must defined all values.\nSee usage with -h option."
   fi
   
   if [ ${LEVEL} != "${LEVEL_FULL}" ]  && [ ${LEVEL} != "${LEVEL_DATA}" ] && [ ${LEVEL} != "${LEVEL_CONF}" ]
   then
      logexit "Bad level value : allowed values are \"${LEVEL_FULL}\" or \"${LEVEL_CONF}\" or \"${LEVEL_DATA}\"."
   fi

   BEGIN=`echo "${DIR_ROOT}" | awk '{print substr($1,1,1)}'`
   if [ "$BEGIN" != "/" ]
   then
      logexit "The installation directory is not a full path."
   fi
   
   if [ ! -d ${DIR_ROOT} ]
   then
      logexit "Installation directory   ${DIR_ROOT} does not exist!"
   fi      
   
   # log file
   LOG_FILE=${DIR_ROOT}/${DIR_DLOG}/${LOG_NAME}   
   touch ${LOG_FILE} 2>/dev/null
   if [ $? -ne 0 ]
   then
      unset LOG_FILE
      logexit "Cannot create log file ${LOG_FILE}:  Please check access!"           
   fi
   chmod u+w ${LOG_FILE}   
  echo > ${LOG_FILE}
   startmessage
   logecho "Starting ${LEVEL} backup of directory ${DIR_ROOT} in ${DIR_BCK}"   
   logecho "Node name is : ${NODE_NAME}"
   logecho "Root directory is : ${DIR_ROOT}"   
   
   # backup directory
   BEGIN=`echo "${DIR_BCK}" | awk '{print substr($1,1,1)}'`
   if [ "$BEGIN" != "/" ]
   then
      logexit "You must give the full path of the backup directory."
   fi
   
   if [ -d ${DIR_BCK} ]
   then
      logexit "Backup directory ${DIR_BCK} already exist!"      
   fi
   
   mkdir -p ${DIR_BCK}
   if [ $? -ne 0 ]
   then
      logexit "Cannot create directory ${DIR_BCK}"            
   fi
}

#-------------------------------------------------
#Backup dirs and files
# ------------------------------------------------
backup()
{
   [ ${UXDEBUG:-off} = on ] && set -x
   
   EXCL=""
   if [ ${LEVEL} = "${LEVEL_DATA}" ]
   then
      EXCL="${EXCL} --exclude ${DIR_DLOG}" 
      EXCL="${EXCL} --exclude ${DIR_DTMP}"   
      EXCL="${EXCL} --exclude ${DIR_APP}"
      EXCL="${EXCL} --exclude ${DIR_DOC}"            
   elif [ ${LEVEL} = "${LEVEL_CONF}" ]
   then
      logexit "Option not implemented"            
   fi
   
   BCK_FILE_NAME=${DIR_BCK}/backup_${NODE_NAME}_`date +%Y%m%d_%H%M%S`.taz
   
   cd ${DIR_ROOT}/..
   package compress ${NODE_NAME} ${BCK_FILE_NAME} ${LOG_FILE}.temp_tar ${EXCL}
   if [ $? -ne 0 ]
   then
      logexit "An error occured during backup creation."            
   fi

   # check of the backup
   package check ${BCK_FILE_NAME} ${LOG_FILE}.temp_compress
   if [ $? -ne 0 ]
   then
      logexit "Impossible to read/check backup."            
   fi
   nbbefore=`wc -l ${LOG_FILE}.temp_tar|awk '{print $1}'`
   nbafter=`wc -l ${LOG_FILE}.temp_compress|awk '{print $1}'`
   if [ ${nbbefore} -gt ${nbafter}+1 ] # add one in case of garbage line in debug
   then
      logexit "Backup is not available : please check log and retry."            
   fi
   
   
   logecho "List of backuped files:\n-----------------------"   
   cat ${LOG_FILE}.temp_compress
   cat ${LOG_FILE}.temp_compress >>${LOG_FILE}
   
  echo "${PRODUCT_NAME}#${DIR_ROOT}#${NODE_NAME}#${LEVEL}#${DIR_BCK}#`date +%Y%m%d_%H%M%S`" > ${DIR_BCK}/backup_infos.txt
   chmod -w ${DIR_BCK}/backup_infos.txt
   cd - >/dev/null
}

endmessage()
{
	logecho ""
	logecho "#--------------------------------------------------"
	logecho "# End of UniJob backup "
	logecho "# -------------------------------------------------"
	logecho ""
}


startmessage()
{
	logecho ""
	logecho "#--------------------------------------------------"
	logecho "# Starting UniJob backup "
	logecho "# -------------------------------------------------"
	logecho ""
}


get_generic_func()
{ 
   [ ${UXDEBUG:-off} = on ] && set -x

   cd `dirname ${1}`
   . ./unigeneric.ksh
   cd - >/dev/null
}

#--------------------------------------------------
# MAIN part
# -------------------------------------------------

get_generic_func ${0}
check_root
initdata ${0}
getenv `dirname ${0}`/../..
acquireopt $@
checkopt
backup
endmessage 
cleaning
exit 0



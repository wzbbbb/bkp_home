#! /bin/ksh
# ============================================================================
# ORSYP SA                                                          2008/02/12
#
# UniJob Restore Procedure                                                (ERO)
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
   LOG_NAME="orsyp_restore.log"
}

cleaning()
{
   [ ${UXDEBUG:-off} = on ] && set -x

   if [ "${LOG_FILE}" != "" ] && [ -d ${DIR_ROOT}/${DIR_DLOG} ]
   then
      # move temp file to final folder
      mv ${LOG_FILE} ${DIR_ROOT}/${DIR_DLOG}
      chmod -w ${DIR_ROOT}/${DIR_DLOG}/${LOG_NAME}
      echo "Log file is ${DIR_ROOT}/${DIR_DLOG}/${LOG_NAME}"
      
      /bin/rm -f ${LOG_FILE}.temp_tar
   fi
}

#-------------------------------------------------
# Usage display 
# -------------------------------------------------
usage()
{
   [ ${UXDEBUG:-off} = on ] && set -x
 
   echo ""
   echo "    UniJob restore tool."
   echo "    This tool make a previously backuped UniJob node."
   echo "    Note that in silent mode, no confirmation of restoration is done"
   echo ""
   echo "    Usage   : unirestore.ksh [-s -b <Backup Directory>]"
   echo ""
   echo "              without argument unirestore.ksh starts in an intercative mode: all values will be asked."
   echo "              with silent mode option (-s) all arguments must be passed in the command."    
   echo ""
   echo "              -b <Backup Directory>        : the full path of the directory used to backup the node"
   echo ""
   echo "              -h option prints that message."    
   echo ""              
   echo "" 
   echo "    Example : unirestore.ksh -s -b /restore/ORSYP/MY_BACKUP_DIRECTORY"
   echo ""
   echo ""
}

ask_value()
{
   [ ${UXDEBUG:-off} = on ] && set -x

  echo
  echo $OPTECHO "Please give full path for Backup Directory ? -->\c"
   read DIR_BCK
}

#-------------------------------------------------
# Get and check validity of the arguments
# ------------------------------------------------
acquireopt()
{
   [ ${UXDEBUG:-off} = on ] && set -x

   while getopts "shb:" opt
   do
      case $opt in

      b)  DIR_BCK=$OPTARG ;;
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
# Check validity of file and dir
# ------------------------------------------------
checkopt()
{
   [ ${UXDEBUG:-off} = on ] && set -x
   
   if [ "${DIR_ROOT}" = "" ] || [ "${NODE_NAME}" = "" ] || [ "${DIR_BCK}" = "" ]
   then
      logexit "You must defined all values.\nSee usage with -h option."
   fi
   
   BEGIN=`echo "${DIR_ROOT}" | awk '{print substr($1,1,1)}'`
   if [ "$BEGIN" != "/" ]
   then
      logexit "The installation directory is not a full path."
   fi
   
   if [ ! -d ${DIR_ROOT} ]
   then
      logexit "Installation directory ${DIR_ROOT} does not exist!"
   fi      
   
   # log file
   LOG_FILE=${DIR_TMP}/${LOG_NAME}   
   touch ${LOG_FILE} 2>/dev/null
   if [ $? -ne 0 ]
   then
      unset LOG_FILE
      logexit "Cannot create log file ${LOG_FILE}:  Please check access!"           
   fi
   chmod u+w ${LOG_FILE}   
  echo > ${LOG_FILE}
   startmessage
   logecho "Starting restore of directory ${DIR_ROOT} in ${DIR_BCK}"   
   logecho "Node name is : ${NODE_NAME}"
   logecho "Root directory is : ${DIR_ROOT}"   
   
   # backup directory
   BEGIN=`echo "${DIR_BCK}" | awk '{print substr($1,1,1)}'`
   if [ "$BEGIN" != "/" ]
   then
      logexit "You must give the full path of the restore directory."
   fi
   
   if [ ! -d ${DIR_BCK} ]
   then
      logexit "Restore directory ${DIR_BCK} does not exist!"      
   fi
   
   typeset -i nbfile=`ls ${DIR_BCK}/*taz|wc -l|awk '{print $1}'`
   if [ ${nbfile} -ne 1 ]
   then
      logexit "No backup file (*.taz) in ${DIR_BCK}"            
   fi
   
   if [ ! -f ${DIR_BCK}/backup_infos.txt ]
   then
      logexit "No data file backup_infos.txt in ${DIR_BCK}"            
   fi
   
   BCK_PRODUCT_NAME=`cut -d"#" -f1 ${DIR_BCK}/backup_infos.txt`
   BCK_DIR_ROOT=`cut -d"#" -f2 ${DIR_BCK}/backup_infos.txt`
   BCK_NODE_NAME=`cut -d"#" -f3 ${DIR_BCK}/backup_infos.txt`
   BCK_LEVEL=`cut -d"#" -f4 ${DIR_BCK}/backup_infos.txt`
   BCK_DIR_BCK=`cut -d"#" -f5 ${DIR_BCK}/backup_infos.txt`
   BCK_DATE=`cut -d"#" -f6 ${DIR_BCK}/backup_infos.txt`
   
   if [ "${BCK_PRODUCT_NAME}" != "${PRODUCT_NAME}" ]
   then
      logexit "Inconsistency between Backup product name and current product name  ${BCK_PRODUCT_NAME} for ${PRODUCT_NAME}"            
   fi
   
   if [ "${BCK_DIR_ROOT}" != "${DIR_ROOT}" ]
   then
      logexit "Inconsistency between Backup root directory and current root directory ${BCK_DIR_ROOT} for ${DIR_BCK}"            
   fi
   
   if [ "${BCK_NODE_NAME}" != "${NODE_NAME}" ]
   then
      logexit "Inconsistency between Backup node name and current node name ${BCK_NODE_NAME} for ${NODE_NAME}"            
   fi
   
}

#-------------------------------------------------
#Restore dirs and files
# ------------------------------------------------
restore()
{
   [ ${UXDEBUG:-off} = on ] && set -x
   
   BCK_FILE_NAME=`ls ${DIR_BCK}/*taz`
   
   logecho "Restore is just about to start with a ${BCK_LEVEL} mode on the base of ${BCK_FILE_NAME} file."
   if [ "${BCK_LEVEL}" = "${LEVEL_FULL}" ]
   then
      logecho "Your current node directory will be completely replaced by the backup content"   
   elif [ "${BCK_LEVEL}" = "${LEVEL_DATA}" ]
   then
      logecho "The current data files of your node will be replaced by the backup content."      
   elif [ "${BCK_LEVEL}" = "${LEVEL_CONF}" ]
   then
      logecho "The current configuration files of your node will be replaced by the backup content."    
   else
      logexit "unknown level : ${BCK_LEVEL}"
   fi
   
   if [ "${MODE}" = "${INTERACTIVE}" ]
   then
      logecho "Please confirm that you have done a backup of your current state and you are ok to continue."
      checkresponse "--> (\"y\" to continue, \"n\" to abort procedure)\c" y n
      [ "${response}" != "y" ] && logexit "Restore aborted by user."   
   fi
   
   # Check the backup
   package check ${BCK_FILE_NAME} /dev/null
   if [ $? -ne 0 ]
   then
      logexit "Backup is corrupted.\noperation is aborted".
   fi

   # Do the restore   
   cd ${DIR_ROOT}/..   
   if [ "${BCK_LEVEL}" = "${LEVEL_FULL}" ]
   then 
      logecho "Removing full node directory."      
      /bin/rm -rf ${NODE_NAME}
   fi   
   
   package uncompress ${BCK_FILE_NAME} ${LOG_FILE}.temp_tar
   if [ $? -ne 0 ]
   then
      logexit "An error occured during restore creation.\noperation is aborted and must be redone manually, state is undetermined".
   fi
   
   logecho "\nList of restored files:\n-----------------------"            
   cat ${LOG_FILE}.temp_tar
   cat ${LOG_FILE}.temp_tar >>${LOG_FILE}
   
   cd - >/dev/null
}

endmessage()
{
	logecho ""
	logecho "#--------------------------------------------------"
	logecho "# End of UniJob restore "
	logecho "# -------------------------------------------------"
	logecho ""
}


startmessage()
{
	logecho ""
	logecho "#--------------------------------------------------"
	logecho "# Starting UniJob restore "
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
restore
endmessage 
cleaning
exit 0



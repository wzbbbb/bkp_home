#! /bin/ksh

# ========================================================
# ORSYP.Sa                          created : 23/09/1994
#                                   updated : 13/01/2000 
#                           
# Nut shell to start supervisor engine
# ========================================================

while true
do

   echo "Starting START_SUR.COM_KSH"

#----------------------------------------------------
# Company name control
#----------------------------------------------------

   if [ "${S_SIGSOC:=""}" = "" ] 
   then
      echo "Missing company name"
      break 1
   else 
      echo "Starting on company : $S_SIGSOC"
   fi 

#----------------------------------------------------
# Area code control
#----------------------------------------------------

   if [ "${S_CODESP:=""}" = "" ]
   then
      echo "Missing area code"
      break 1
   else
      echo "Starting on area : $S_CODESP"
   fi 

#----------------------------------------------------
# Setting UNIEVERSE bacth mode environment 
#----------------------------------------------------

   PROCESS_MODE=BATCH
   export PROCESS_MODE

#----------------------------------------------------
# Setting environment variables to internal control gactlenv
#----------------------------------------------------

   S_SOCIETE=$S_SIGSOC 
   export S_SOCIETE
   S_ESPEXE=$S_CODESP 
   export S_ESPEXE

#----------------------------------------------------
# Setting node name as third parameter (avoid trace mode)
#----------------------------------------------------
   if [ "${S_NOEUD:=""}" = "" ]
   then
      echo "Missing node name, please load your environment"
      break 1
      if [ "${S_NOEUD}" = "TRACE" ]
      then
          S_NOEUD=TRACE_
      fi
   fi 

#----------------------------------------------------
# Starting supervisor engine
#----------------------------------------------------
#----------------------------------------------------
# FXIU0019 part :
#          Adaptation the limits of the ps command
#----------------------------------------------------
UXOPERATINGSYSTEM=`uname`
#----------------------------------------------------
# "UXMAXPSLENGTH + 30" is the maximal lengh of the args field
# of the ps command on some OS like HP and some linux distributions
#----------------------------------------------------
UXMAXPSLENGTH=30
case ${UXOPERATINGSYSTEM} in
	SunOS | OSF1 )
                $UXEXE/uxsur "$S_SOCIETE" "$S_CODESP" "$S_NOEUD" &
		;;
	* )
		ux_exe_path_length=`echo ${UXEXE} | wc -c`
		if [ ${ux_exe_path_length} -gt ${UXMAXPSLENGTH} ]
		then
			cd ${UXEXE}
                        ./uxsur "$S_SOCIETE" "$S_CODESP" "$S_NOEUD" &
		else
                        $UXEXE/uxsur "$S_SOCIETE" "$S_CODESP" "$S_NOEUD" &
		fi
		;;
esac

   break 1

done


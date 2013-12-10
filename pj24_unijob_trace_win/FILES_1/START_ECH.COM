#! /bin/ksh

# ========================================================
# ORSYP.Sa                                  Le 23/09/94
# 
# Nut shell to start Exchanger engine 
# ========================================================

while true
do

   echo "Starting START_ECH.COM_KSH"

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
      echo "Missing area code  "
      break 1
   else
      echo "Starting on area : $S_CODESP"
   fi 

#----------------------------------------------------
# Setting UNIVERSE batch mode environment
#----------------------------------------------------

   PROCESS_MODE=BATCH
   export PROCESS_MODE

#----------------------------------------------------
# Setting environment values to internal controls by gactlenv
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
# Starting exchanges engine
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
                $UXEXE/uxech "$S_SOCIETE" "$S_CODESP" "$S_NOEUD" &
		;;
	* )
		ux_exe_path_length=`echo ${UXEXE} | wc -c`
		if [ ${ux_exe_path_length} -gt ${UXMAXPSLENGTH} ]
		then
			cd ${UXEXE}
                        ./uxech "$S_SOCIETE" "$S_CODESP" "$S_NOEUD" &
		else
                        $UXEXE/uxech "$S_SOCIETE" "$S_CODESP" "$S_NOEUD" &
		fi
		;;
esac

   break 1

done



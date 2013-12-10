#!/bin/sh 
#Thu Mar 25 17:28:59 EST 2004
#Orsyp Software Inc
#Zhibing Wang
#Version 1.1.1  Aug. 31st, 2004
#################################
#Purpose: 
#1. To reuse the PS "IU_CLRLOG.000" script for $U log in testing/development environment
#2. TO enhance the "IU_CLRLOG.000" script to give the option of Non-backup 
#################################

######################
# Variables filled by installation
######################
#ScDir=SSSSS
#ConfDir=CCCCC
#LogDir=LLLLL
#Admin=AAAAA
######################
# Read Parameters from DuMaint.conf and  set
######################
GetPar () {
eval $1=\"`grep $1 ${ScDir}/DuMaint.conf|grep -v ^#|cut -d"="  -f2`\"
}
######################
# Variables
######################
GetPar Admin
#Conf="DuMaint.conf"
List=${ConfDir}/Du.list
ClearLog=
ClrLogFunction="IU_CLRLOG.000"
log=DuMaint.log
#C=${ConfDir}/${Conf} #just to save some typing
CLF=${ScDir}/${ClrLogFunction}
L=${LogDir}/${log}
NbStep=8; export NbStep
#IsUproc=n; export IsUproc
export uxKEEP_JOB_LOG
export uxKEEP_NB_LINE
export uxARCH_DIR
export uxKEEP_ARC
#LocalDir=`pwd`
#uxKEEP_JOB_LOG=10
#uxKEEP_NB_LINE=4000
#uxKEEP_ARC=15
S_DATRAIT=`date '+%Y%m%d'`; export S_DATRAIT
#################################
#Prerequirements
#################################
Pre () {  # test if the DuMaint.conf exist, and if you are root.
        [ ! -f "$L" ] && touch "$L"
        if [ ! -f $List ] ; then
                echo "`date '+%F_%H:%M'` The $List does not exist! Please run the DuDetect.sh to create one." >> "$L"
                exit 1
        fi
        #id |  grep root 1> /dev/null  2> /dev/null
        if [  `id -u` -ne 0 ]; then
                echo "`date '+%F_%H:%M'` You have to be root to run this program!"  >> "$L"
                exit 1
        fi
        echo "`date '+%F_%H:%M'` Pass root test"  >> "$L"
}
#################################
#Main
#################################
Pre
MaxLines=`sed -n '$=' $List` #How many $U are there?
i=1
while [ $i -le $MaxLines ] ; do
        Dir=`sed -n "${i}p" $List |cut -d":" -f1` #The dir of the $U 
	if [ -f "${Dir}/ClearLog.conf" ]; then
		ClearLog="${Dir}/ClearLog.conf"
		Env="${Dir}/uxsetenv"
		eval . $Env
		uxKEEP_JOB_LOG=`sed -n "1p" $ClearLog |cut -d":" -f3` #days to keep logs 
		uxKEEP_NB_LINE=`sed -n "1p" $ClearLog |cut -d":" -f5` #lines to keep
		uxKEEP_ARC=`sed -n "1p" $ClearLog |cut -d":" -f7` #lines to keep
		uxARCH_DIR="${UXDIR_ROOT}/archive" #days to keep archive
	else 		# ClearLog.conf missing, send out alerts and use Du.list.
		Env="${Dir}/uxsetenv"
		eval . $Env
		uxKEEP_JOB_LOG=`sed -n "${i}p" $List |cut -d":" -f3` #days to keep logs 
		uxKEEP_NB_LINE=`sed -n "${i}p" $List |cut -d":" -f5` #lines to keep
		uxKEEP_ARC=`sed -n "${i}p" $List |cut -d":" -f7` #lines to keep
		uxARCH_DIR="${UXDIR_ROOT}/archive" #days to keep archive
		echo "`date '+%F_%H:%M'` The ClearLog.conf for ${Dir} is missing! Please run the DuDetect.sh again!"
		echo "`date '+%F_%H:%M'` The ClearLog.conf for ${Dir} is missing! Please run the DuDetect.sh again!" >>"$L"
		echo "`date '+%F_%H:%M'` The ClearLog.conf for ${Dir} is missing! Please run the DuDetect.sh again!" | mail -s "Missing ClearLog.conf" $Admin
	fi
	for  S_ESPEXE  in A I S X #launch clear log for each area
	do
		$CLF
	done
        i=`expr $i + 1`
done

exit 0

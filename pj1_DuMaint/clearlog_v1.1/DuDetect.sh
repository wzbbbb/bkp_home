#!/bin/sh 
# Mar. 18th, 2004
# ORSYP Software Inc.
# Zhibing Wang
# Version 1.1 Mar 25th, 2004
############################################
#Purpose: this program search for all installed $U Company,
#then create a new Du.list file and list their uxsetenv files in it. 
############################################

######################
# Read Parameters from DuMaint.conf and  set  
######################
GetPar () {
eval $1=\"`grep $1 DuMaint.conf|grep -v ^#|cut -d"="  -f2`\"
}
######################
# Variables
######################
#Public Variable:
######################
GetPar uxKEEP_JOB_LOG
#echo $uxKEEP_JOB_LOG
#uxKEEP_JOB_LOG=1	#Modify them for the initial configuration file.
GetPar uxKEEP_NB_LINE
#echo $uxKEEP_NB_LINE
#uxKEEP_NB_LINE=100	#After the first run, just modify the Du.list directly.
GetPar uxKEEP_ARC
#echo $uxKEEP_ARC
#uxKEEP_ARC=5
GetPar Admin
#echo $Admin
#ScDir=SSSSS		#To be specified for scripts location, default is ./
#ConfDir=CCCCC	#To be specified for configuration files location, default is ./
#LogDir=LLLLL		#To be specified for log location, default is ./
#Admin=AAAAA
############################################
#==========================================#
############################################
##Interval Variable
##Never modify anything below this line
############################################
#==========================================# 
############################################
#for dir in "$ScDir" "$ConfDir" "$LogDir" ; do
#	[ -z "$dir" ] && dir=`pwd`	#if not defined, use ./
#	if [ ! -d "$dir" ] ; then	#if not properly defined.
#		echo "$dir" does not exist! Want to create one (y/n)?
#		read i
#		if [ $i = "y" || $i = "Y" ] ; then
#			mkdir "$dir"
#		else 
#			echo Redefine the directory for "$dir", then the script again!
#			exit 1
#		fi
#	fi
#done
Conf="${ConfDir}/Du.list"
FoundList="${LogDir}/DuFound.log"
DiffResult="${LogDir}/DiffResult.log"
log="${LogDir}/DuMaint.log"
temp=/tmp/tmp$$
Conf_tmp=/tmp/Conf_tmp$$
FList_tmp=/tmp/FList_tmp$$
MgrLocation=
NumberLines=
Mgrdir=
FileLocation=
ComNom=
NewInstall=""
######################
# Prerequest: root id test
######################
Pre() {
rm -f "$log" 2> /dev/null
touch "$log"
#id |  grep root 1> /dev/null  2> /dev/null
if [  `id -u` -ne 0 ]; then
	echo "`date '+%F_%H:%M'` You have to be root to run this program!"  >> "$log" 
	echo "You have to be root to run this program!"   
	exit 1
fi
echo "`date '+%F_%H:%M'` Pass root test"  >> "$log"

}
######################
# Detecting/Creating Configuration files: DuFound.log & Du.list
######################
STEP0 () {
rm -f "$FoundList" 2> /dev/null	#create a new DuFound.log every time
touch "$FoundList"
if [ -f "$Conf" ] ; then
	NewInstall="no" 	#If it is  the first time, create a Du.list
else
	NewInstall="yes"
fi

[ $NewInstall = "yes" ] &&  touch "$Conf"
}
######################
# Search $U Company and populate the DuFound.log
######################
STEP1 () {
find / -name $1 -type f -follow 2>/dev/null > "$temp"
NumberLines=`sed -n '$=' "$temp"` 	#How many copies of uxsetenv?
i=1
while [ $i -le $NumberLines ] ; do  
	FileLocation=`sed -n "${i}p" "$temp"`	#name+dir
	MgrLocation=`grep 'UXMGR=' "$FileLocation" | cut -c7-` #dir
	Mgrdir=`dirname "$FileLocation"`
	if [ "$Mgrdir" = "$MgrLocation" ] ; then
		echo "$Mgrdir:JobLogDays=:$uxKEEP_JOB_LOG:NBLines=:$uxKEEP_NB_LINE:ArchiveDays=:$uxKEEP_ARC" >> "$FoundList" #Found a $U	
	fi
	i=`expr "$i" + 1`
done
}

######################
# Comparing the DuFound.log and Du.list and send out the results
######################
STEP2 () {
if [ $NewInstall = "yes" ] ; then
	cp "$FoundList" "$Conf"
	mail -s "`date '+%F_%H:%M'` Notice: First run completed" $Admin < "$Conf"
	echo "`date '+%F_%H:%M'` Notice: First run completed" >> "$log"
else
	cut -d":" -f1 $Conf >$Conf_tmp
	cut -d":" -f1 $FoundList >$FList_tmp
	diff "$Conf_tmp" "$FList_tmp" > "$DiffResult"
	#NumberLines=`cat "$DiffResult" |wc -l |sed 's/^ *//g' |cut -d' ' -f1`
	#echo $NumberLines
	#if [ "$NumberLines" -ne 0 ] ; then
	if [ -s $DiffResult ] ; then 	#nozero length
		echo "`date '+%F_%H:%M'` Notice: New \$U found" >> "$log"
		mail -s "`date '+%F_%H:%M'` Notice: New \$U found" $Admin < "$DiffResult"
	else
		echo "No New \$U found on `date`" >> "$log"
	fi
fi
}

######################
# Creating ClearLog.conf, if not exist 
######################
STEP3 () {
NumberLines=`sed -n '$=' "$Conf"` 
i=1
while [ $i -le $NumberLines ] ; do	#browse the Du.list file
	Mgrdir=`sed -n "${i}p" $Conf | cut -d":" -f1`
	if [ ! -f "${Mgrdir}/ClearLog.conf" ] ; then   #if no ClearLog.conf, create one
		touch  "${Mgrdir}/ClearLog.conf"
		sed -n "${i}p" $Conf > "${Mgrdir}/ClearLog.conf"
	fi
	i=`expr "$i" + 1`
done
}

######################
# Cleaning up 
######################
STEP4 () {
rm -f "$temp" "$Conf_tmp" "$FList_tmp"
}
######################
# Main 
######################
Pre
STEP0
STEP1 uxsetenv
STEP2
STEP3
STEP4

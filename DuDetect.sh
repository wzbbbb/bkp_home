#!/bin/sh 
# Mar. 18th, 2004
# ORSYP Software Inc.
# Zhibing Wang
# Version 0.9 Mar 19th, 2004
############################################
#Purpose: this program search for all installed $U Company,
#then list their uxsetenv files in the DuMaint.conf file.
############################################


######################
# Variables
######################
Conf=DuMaint.conf
FoundList=DuFound.log
temp=tmp$$
NewInstall=""
DiffResult=DiffResult.log
Admin=zwa@orsyp.com
ComNom=
log=DuMaintLog
FileLocation=
MgrLocation=
NumberLines=
Mgrdir=

######################
# Prerequest
######################
Pre() {
rm -f "$log" 2> /dev/null
touch "$log"
id |  grep root 1> /dev/null  2> /dev/null
if [  $? -ne 0 ]; then
	echo 'You have to be root to run this program!' |tee >> "$log" 
	exit 1
fi
echo "Pass root test" |tee >> "$log"

}
######################
# Detecting/Creating Configuration files
######################
STEP0 () {
rm -f "$FoundList" 2> /dev/null	#create a new one every time
touch "$FoundList"
if [ -f "$Conf" ] ; then
	NewInstall="no" 	#If it is  the first time, create a configuration file
else
	NewInstall="yes"
fi

if [ NewInstall="yes" ] ; then
	touch "$Conf"
fi
}
######################
# Search $U Company and populate the file 
######################
STEP1 () {
find / -name uxsetenv > "$temp"
NumberLines=`wc -l "$temp" |sed 's/^ *//g' |cut -d' ' -f1` 	#How many copies of uxsetenv?
i=1
while [ $i -le $NumberLines ] ; do  
	FileLocation=`sed -n "${i}p" "$temp"`	#name+dir
	MgrLocation=`grep 'UXMGR=' "$FileLocation" | cut -c7-` #dir
	Mgrdir=`dirname "$FileLocation"`
	if [ "$Mgrdir" = "$MgrLocation" ] ; then
		echo "$Mgrdir" >> "$FoundList" #Found a $U	
	fi
	i=`expr "$i" + 1`
done
}

######################
# Comparing the two files and send out the results
######################
STEP2 () {
if [ $NewInstall = "yes" ] ; then
	cp "$FoundList" "$Conf"
	mail -s "Notice: First run on `date`" $Admin < "$Conf"
else
	diff "$Conf" "$FoundList" > "$DiffResult"
	#NumberLines=`cat "$DiffResult" |wc -l |sed 's/^ *//g' |cut -d' ' -f1`
	#echo $NumberLines
	#if [ "$NumberLines" -ne 0 ] ; then
	if [ -s $DiffResult ] ; then 	#nozero length
		mail -s "Notice: New \$U found on `date`" $Admin < "$DiffResult"
	fi
fi
}
######################
# Cleaning up 
######################
STEP3 () {
rm -f "$temp"
}
######################
# Main 
######################
Pre
STEP0
STEP1
STEP2
STEP3

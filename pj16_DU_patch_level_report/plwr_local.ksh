#!/bin/ksh 
# Oct. 27th, 2005
# ORSYP Software Inc.
# Zhibing Wang
# Version 0.0.1 Aug. 31st, 2004
############################################
#Purpose: 
#1. search for all installed $U Company,
#2. create a list of the installed Companies
#3. load the ENV one by one and run the $UXEXE/uxversion command
############################################
set -x
STEP0 () {
	temp=/tmp/tmp$$
	temp_list=/tmp/tmp$$_list
	date_time=`date`
	node_name=`hostname`
	rm -f /tmp/${node_name}.txt 
	if [ $? -ne 0 ] ; then
		echo "Failed to remove old /tmp/${node_name}.txt file! Abort process!"
		exit 1
	fi
	echo "<date=>${date_time}" >/tmp/${node_name}.txt
	echo "<node=>${node_name}" >>/tmp/${node_name}.txt
}
######################
# Search $U Company 
######################
STEP1 () {
	/usr/bin/find /apps/du/ -name uxsetenv -type f > "$temp" 
	NumberLines=`sed -n '$=' "$temp"` 	#How many copies of uxsetenv?
	i=1
	while [ $i -le $NumberLines ] ; do  
		FileLocation=`sed -n "${i}p" "$temp"`	#name+dir
		MgrLocation=`grep 'UXMGR=' "$FileLocation" | cut -c7-` #dir
		Mgrdir=`dirname "$FileLocation"`
		if [ "$Mgrdir" = "$MgrLocation" ] ; then
			echo "$Mgrdir" >> "$temp_list" #Found a $U	
		fi
		i=`expr "$i" + 1`
	done
}
######################
# sort the file and get the output
######################
STEP2 () {
	cat  $temp_list | sort -o $temp_list
	NumberLines=`sed -n '$=' "$temp_list"` 	#How many copies of uxsetenv?
	i=1
	while [ $i -le $NumberLines ] ; do  
		#. ${Mgrdir}/uxsetenv
		FileLocation=`sed -n "${i}p" "$temp_list"`	#name+dir
		. $FileLocation/uxsetenv
		company_name=`env|grep SOC|cut -d= -f2`
		echo "<company=>${company_name}" >>/tmp/${node_name}.txt
		echo "<uxversion_beg=>${company_name}" >>/tmp/${node_name}.txt
		$UXEXE/uxversion >>/tmp/${node_name}.txt
		echo "<uxversion_end=>${company_name}" >>/tmp/${node_name}.txt
		i=`expr "$i" + 1`
	done
}
######################
# placing the result
######################
STEP3 () { scp /tmp/${node_name}.txt demeter:~/Company_report
} 
######################
# Cleaning up 
######################
STEP4 () {
	rm -f "$temp" "$temp_list"  "/tmp/${node_name}.txt" 
}
######################
# Main 
######################
STEP0
STEP1
STEP2 
#STEP3 
#STEP4 

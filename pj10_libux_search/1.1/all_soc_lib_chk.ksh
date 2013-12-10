#!/bin/ksh 
# Mar. 1st, 2006
# ZWA
# To check library links in all of the binaries in each $U installed on a node.
# Send an email report if there are some binaries have not been relinked.
admin1="zwa@orsyp.com"
return_code=0
temp=/tmp/tmp$$
temp_list=/tmp/tmp$$_list
date_time=`date`
output=/tmp/lib_chk_$$.txt
export FULL_LIB_CHECK=Y
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
		echo "CompanyName=${company_name}" >> $output

		#./lib_lnk_chk >>/tmp/lib_chk_$$.txt
		/etc/daenv/du/lib_lnk_chk >>$output
		rc=$?
		[ $rc -ne 0 ] && return_code=$rc
		echo "=======================================================" >> $output
		echo "=======================================================" >> $output
		i=`expr "$i" + 1`
	done
}

STEP1
STEP2
if [ $return_code -ne 0 ] ; then

	cat $output| mail $admin1 -s "Some binaries failed the lib link check!"  
fi
rm -f "$temp" "$temp_list"   $output


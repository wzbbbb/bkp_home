#!/bin/ksh -x

HostName=`grep DA_US_U_02 /tmp/sck.sck|grep -v '^#'|tr -s ' ' ' '|grep -v '^ #'|sed 's/$/:/g'`
host_list=`echo $HostName |cut -f1 -d':'|sed 's/^ //g'`

ind=1
for host_ in $host_list ; do

	if [ $ind -gt 1 ] ; then
		echo "=================================" >> ./ping_output.txt  2>&1
		echo "ping $host_ -c4" >> ./ping_output.txt  2>&1
		ping $host_ -c4  >> ./ping_output.txt  2>&1
	fi
	ind=`expr $ind + 1`
done

#!/bin/ksh
#set -x
sdklf
temp=/tmp/tmp$$
company_list=`ps -ef | grep [u]xioserv | grep X | cut -d'/' -f2| cut -d' ' -f2`

if [ -z $company_list ] ; then
	echo "No Dollar Universe Company is running."
	exit 0
else
	find /apps/du/ -name uxsetenv > $temp
	for company in $company_list ;  do
		env_file=`grep  $company $temp`
		. $env_file
		echo "Shutting down Dollar Universe Company ${company}"
		$UXMGR/uxshutdown
	done
fi
rm -f $temp 


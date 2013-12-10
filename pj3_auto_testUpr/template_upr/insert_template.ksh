#!/bin/ksh 
#set -x
#base_dir="/apps/du"
#echo $base_dir
#echo $1
#company_name=`echo $1 |tr '[a-z]' '[A-Z]'`
#echo $company_name
#du_root=`find $base_dir -name $company_name`
#env_file=${du_root}/mgr/uxsetenv
if [ $1 ] ; then
	if [ $1 = "-h" ] || [ $1 = "--help" ] ; then
		echo "   Insert the template uprocs into the specified $U Company "
		echo "   Usage:"
		echo "   Please load the target Dollar Universe Company Environment first,"
		echo "   then launch the script, e.g. "
		echo "   ./insert_template.ksh"
		exit 1
	fi
fi
#env_file=${1}/mgr/uxsetenv
#. $env_file
[ ! $UXEXE ] && echo "Please load the Dollar Universe Environment first!" && exit 1

$UXEXE/uxins upr app upr=* input=./template_upr.ext

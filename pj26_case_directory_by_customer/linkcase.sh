#!/bin/bash 
# To create link from old case directory to the new case directory
# So, to access cases for with customer name
if [ "${1:-NONE}" = "NONE" ] ; then
	echo "Please specify the customer directory  "
	echo "For example: /traces_views/Customer_All/CISCO"
	exit 1
fi
#cust_id=$1
#check if it is launched from a customer directory
current_dir=`pwd`
current_base_dir=`dirname ${current_dir}`

if [ $current_base_dir != "/dsk1/cases" ] ; then
	echo "Please run this script from a customer directory."
	echo "For example: /dsk1/cases/Cisco"
	exit 1
fi
view_dir=$1
case_69_5=`find ${view_dir} -name 69\[0-9\]\[0-9\]\[0-9\] -maxdepth 1`
case_7_5=`find  ${view_dir} -name 7\[0-9\]\[0-9\]\[0-9\]\[0-9\] -maxdepth 1`
case_8_5=`find  ${view_dir} -name 8\[0-9\]\[0-9\]\[0-9\]\[0-9\] -maxdepth 1`
case_9_5=`find  ${view_dir} -name 9\[0-9\]\[0-9\]\[0-9\]\[0-9\] -maxdepth 1`
case_1_6=`find  ${view_dir} -name 1\[0-9\]\[0-9\]\[0-9\]\[0-9\]\[0-9\] -maxdepth 1`

list_="$case_69_5 $case_7_5 $case_8_5 $case_9_5 $case_1_6"
for l in $list_ ; do
	for case_dir in $l  ; do
		case_no=`basename $case_dir`
		c2=`echo $case_no |cut -c1,2`
		c3=`echo $case_no |cut -c1-3`
		case_location=`find /cases/${c2}xxx/${c3}xx/ -name $case_no  -maxdepth 1`
		[ ${case_location:-NONE} = "NONE" ] && break
		if [ ! -d ${case_no} ] ; then
			echo "===========================will link from  $case_location to ./${case_no}"
			ln -s $case_location ./${case_no}
			#ln -s /cases/69xxx/697xx/69761 /dsk1/cases/Cisco/69761
		fi
	done
done

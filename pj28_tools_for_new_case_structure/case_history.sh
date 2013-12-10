#!/bin/bash 
cd ~
case_list=`grep -n ^\[0-9\].*$ case_work_history.txt`
tmp_file1=/dev/shm/case_work_history1.txt
tmp_file2=/dev/shm/case_work_history2.txt
rm -f $tmp_file1  $tmp_file2 
cat case_work_history.txt >$tmp_file1  

for line_case in $case_list ; do 
        case_no=`echo $line_case|cut -f2 -d":"` 
	line_no=`echo $line_case|cut -f1 -d":"` 
	case_dir=`find /traces_views/Customer_All/ -name $case_no`
	customer_dir=`dirname $case_dir`
	customer_name=`basename $customer_dir`
	#echo $customer_name
	rc=$?
	if [ $rc -eq 0 ] ; then
		sed "s/$case_no/$customer_name $case_no/" $tmp_file1 > $tmp_file2
		cat $tmp_file2 > $tmp_file1
		#echo "$customer_name $case_no" >> ~/case_work_history.txt
	else
		echo "The case number does not exist locally yet."
		echo "Maybe try again later."
	fi
done

cat $tmp_file1 > case_work_history.txt
rm -f $tmp_file1  $tmp_file2 

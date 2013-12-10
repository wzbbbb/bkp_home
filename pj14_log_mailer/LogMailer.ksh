#!/bin/ksh
#
#
#
set -x
ConfDir=/dadata/daenv/log_mailer
conf=LogMailer.conf
conf_full=${ConfDir}/${conf}
chk_cycle=0 # 0 *24, within 24 hours
#get the list of the logs that need to be checked
log_dir_list=`grep / $conf_full|cut -f2 -d=`
echo "log_dir_list is $log_dir_list"
for log_dir in $log_dir_list ; do
	echo "log_dir is $log_dir"
	# find the log newer than 1 day
	new_log=`find $log_dir -mtime ${chk_cycle} -type f` 
	echo "new_log is $new_log"
	if [ -z "$new_log" ]  ; then 
		echo "No new log." 
	else
		app_name=`grep $log_dir $conf_full|cut -f1 -d:`
		recipient_list=`grep recipient $conf_full|grep $app_name|cut -f2 -d=`
		title=`grep $log_dir $conf_full|cut -f1 -d=`
		tail -n 100 $new_log |mail -s "${title}" $recipient_list 
	fi
done




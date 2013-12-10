#!/bin/ksh
############################################
# to kill the launcher and restart it 
# with cron without the loop
# run in a uproc script with the loop
############################################
#!/bin/ksh
. /gpsorp77/dollaru/GEPRD1/mgr/uxsetenv

i=1
while [[ $i -gt 0 ]]; do

	current_time=`date  '+%Y%m%d%H%M%S'`
	uxord_pid=`$UXEXE/uxlst atm lan |grep Pid|cut -d":" -f3 |cut -d" " -f2`
	wp_date_i=`$UXEXE/uxlst atm lan |grep Wakeup|cut -d":" -f2|cut -d" " -f2|sed  's/\///g'`
	wp_year=`echo $wp_date_i |cut -c5-`
	wp_month=`echo $wp_date_i |cut -c1,2`
	wp_day=`echo $wp_date_i |cut -c3,4`
	wp_time=`$UXEXE/uxlst atm lan |grep Wakeup|cut -d":" -f3|cut -d" " -f2`
	wp_date=${wp_year}${wp_month}${wp_day}${wp_time}

	# if wake up in the past, restart launcher
	if [ ${current_time} -gt ${wp_date} ] ; then
		if [ ${uxord_pid} -ne 0 ] ; then
			kill -9 ${uxord_pid}
			sleep 10
		fi
		$UXEXE/uxstr atm exp lan
	fi
	sleep 300
done

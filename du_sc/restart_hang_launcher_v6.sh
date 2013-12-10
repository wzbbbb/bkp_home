#!/bin/ksh
############################################
# Once the launcher hanges, restart $U
# To run in a uproc script 
############################################

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
	echo current time is : ${current_time}
	echo wakeup time is : $wp_date
	# if wake up in the past, restart $U 
	# if $U is already stopped, the "if" test will fail.
	if [ ${current_time} -gt ${wp_date} ] ; then
		$UXEXE/unistop	
		if [ $? -ne 0 ] ; then 
			echo '###$U failed to stop'
			exit 1
		fi
		$UXEXE/unistart
		if [ $? -ne 0 ] ; then 
			echo '###$U failed to start'
			exit 1
		fi
	fi
	sleep 300
done

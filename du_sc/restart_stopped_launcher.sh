#!/bin/ksh 
############################################
# Check the launcher and calculator status 
# If they are stopped, restart it 
# Run in a uproc script 
############################################
#!/bin/ksh
i=1
while [[ $i -gt 0 ]]; do
	uxord_pid=`$UXEXE/uxlst atm lan |grep Pid|cut -d":" -f3 |cut -d" " -f2`
	uxcal_pid=`$UXEXE/uxlst atm cal |grep Pid|cut -d":" -f3 |cut -d" " -f2`
	if [ ${uxord_pid} -eq 0 ] ; then
		$UXEXE/uxstr atm exp lan
	fi
	if [ ${uxcal_pid} -eq 0 ] ; then
		$UXEXE/uxstr atm exp cal
	fi
	sleep 180
done

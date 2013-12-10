#!/bin/ksh 

fun1() {
$UXDQM/uxshwque que=*
i=0
finished="no"
#while [ $i -le 10 -a "$finished"="no" ]; do
while [ $i -le 10 ]; do
i=`expr $i + 1`
echo "Shutting down the engines ..."
$UXEXE/uxend atm exp
echo "Waiting for 30 seconds and check ..."
sleep 30
ps -ef|grep uxcal|grep  X
cal_=$?
ps -ef|grep uxord|grep  X
ord_=$?
ps -ef|grep uxech|grep  X
ech_=$?
ps -ef|grep uxsur|grep  X
sur_=$?
if [ cal_ -eq 0 -o ord_ -eq 0 -o ech_ -eq 0 -o sur_ -eq 0 ]; then
	echo "At least one of the Engines could not be stopped!" 
	echo "Trying again ... "
else
	finished="yes"
	echo "finished is : $finished" 
	break
fi
done # while
if [ $finished = "no" ]; then
	echo "Could not stop some Engines." 
	echo "Please try to stop them manually, then launch this script. "
	exit 1
fi

cp $UXDEX/u_fmsb50.dta  $UXDEX/u_fmsb50.dta_init
[ $? -ne 0 ] && echo "Backup u_fmsb50.dta failed." && exit 1
$UXEXE/uxpurfmsb
echo 'Please press "Enter" to continue ...'
read
$UXEXE/uxpurfmsb -p

echo "#############################################################################"
echo "#############################################################################"
echo "The following are the diff result of the fmsb."
diff $UXDEX/u_fmsb50.dta  $UXDEX/u_fmsb50.dta_init
echo 'Please press "Enter" to continue ...'
read
echo "Restarting the Engines ..."
$UXEXE/uxstr atm exp
}


##########
## Main ##
##########
fun1 2>&1 |tee ./uxpurfmsb_output.txt 

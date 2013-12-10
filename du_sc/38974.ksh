#!/bin/ksh 
set -x -v

fun1() {
$UXEXE/uxadd fla exp upr=38974-1 mu=DA_US_U_02 user=univa vupr=000 pdate=02/03/2005 
echo "#######################################################"
echo "#TS# " `date` 
$UXEXE/uxadd fla exp upr=38974-1 mu=DA_US_U_02 user=univa vupr=000 pdate=02/03/2005 
echo "#######################################################"
echo "#TS# " `date` 
sleep 10
echo "#######################################################"
echo "#TS# " `date` 

$UXEXE/uxlst fla exp upr=38974-1 vupr=000 mu=DA_US_U_02 full 
echo "#######################################################"
echo
echo "#TS# " `date` 

$UXEXE/uxlst ctl exp upr=38974-1 vupr=000 mu=DA_US_U_02 full 
echo "#######################################################"
echo
echo "#TS# " `date` 

$UXEXE/uxend ctl exp upr=38974-1 vupr=000 mu=DA_US_U_02 
echo "#######################################################"
echo
echo "#TS# " `date` 
sleep 10
echo "#TS# " `date` 

$UXEXE/uxlst ctl exp upr=38974-1 vupr=000 mu=DA_US_U_02 full 
echo "#######################################################"
echo "#TS# " `date` 

$UXEXE/uxlst ctl exp upr=38974-1 vupr=000 mu=DA_US_U_02 hst 
echo "#######################################################"
echo
echo "#TS# " `date` 
}

######################
#### Main
######################
fun1  > 38974_output.txt

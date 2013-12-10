#!/bin/ksh 
set -x -v

fun1() {
$UXEXE/uxadd fla app upr=38974-1 mu=DA_US_U_02 user=univa vupr=001 pdate=02/03/2005 
echo "#######################################################"
echo "#TS# " `date` 
$UXEXE/uxadd fla app upr=38974-1 mu=DA_US_U_02 user=univa vupr=001 pdate=02/03/2005 
echo "#######################################################"
echo "#TS# " `date` 
sleep 10
echo "#######################################################"
echo "#TS# " `date` 

$UXEXE/uxlst fla app upr=38974-1 vupr=001 mu=DA_US_U_02 full 
echo "#######################################################"
echo
echo "#TS# " `date` 

$UXEXE/uxlst ctl app upr=38974-1 vupr=001 mu=DA_US_U_02 full 
echo "#######################################################"
echo
echo "#TS# " `date` 

$UXEXE/uxend ctl app upr=38974-1 vupr=001 mu=DA_US_U_02 
echo "#######################################################"
echo
echo "#TS# " `date` 
sleep 10
echo "#TS# " `date` 

$UXEXE/uxlst ctl app upr=38974-1 vupr=001 mu=DA_US_U_02 full 
echo "#######################################################"
echo "#TS# " `date` 

$UXEXE/uxlst ctl app upr=38974-1 vupr=001 mu=DA_US_U_02 hst 
echo "#######################################################"
echo
echo "#TS# " `date` 
}

######################
#### Main
######################
fun1  > 38974_app_output.txt

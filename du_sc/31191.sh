#!/bin/sh -x
. /apps/du/SUP500/mgr/uxsetenv
#sec=`date |cut -d: -f3|cut -f1 -d' '`
i=100
while [ $i -le 110 ]; do 
#	$UXEXE/uxadd fla APP upr=31191a vupr=001 mu=DA_US_U_02 user=univa PDate=04/23/2004 lstart="(04/23/2004,0001)" lend="(04/23/2004,2359)" QUEUE=SYS_BATCH launchvar="((qq,$i))"
	$UXEXE/uxadd fla APP upr=31191a vupr=001 mu=DA_US_U_02 user=univa PDate=`date +%m/%d/%Y` lstart="(`date +%m/%d/%Y`,0001)" lend="(`date +%m/%d/%Y`,2359)" QUEUE=SYS_BATCH launchvar="((qq,$i))"
	i=`expr $i + 1`

done

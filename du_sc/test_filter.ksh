#!/usr/bin/ksh 
i=1
while [ $i == 1 ]; do

$UXEXE/uxlst ctl app status=t upr=$1 mu=* full

done

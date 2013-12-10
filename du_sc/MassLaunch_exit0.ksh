#!/usr/bin/ksh -x 
num=1
max=200000
until [ ${num} -gt $max ]
do
$UXEXE/uxadd fla exp upr=EXIT0 mu=CASDLSUP06 user=univa pdate=08/29/2008
        num=` expr ${num} + 1`
	sleep 30
done

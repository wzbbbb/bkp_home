#!/bin/ksh -x
num=1
max=1011
until [ ${num} -gt $max ]
do
	$UXEXE/uxadd evt upr=TEST user=univa mu=CASDLSUP06 pdate=10/15/2008
        num=` expr ${num} + 1`
        sleep 3
done

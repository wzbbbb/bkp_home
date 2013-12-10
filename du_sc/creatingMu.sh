#!/usr/bin/ksh
num=1
until [ ${num} -gt 6081 ]
do
	[ ${num} -lt 10 ] && mu_name=41465_000${num}
	[ ${num} -ge 10 ] && mu_name=41465_00${num}
	[ ${num} -ge 100 ] && mu_name=41465_0${num}
	[ ${num} -ge 1000 ] && mu_name=41465_${num}
	uxadd mu mu=${mu_name} tnode=DA_US_U_02 label=\"Test 41465 \"
	num=` expr ${num} + 1`
done

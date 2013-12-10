#!/usr/bin/ksh
num=1
until [ ${num} -gt 100 ]
do
	[ ${num} -lt 100 ] && mu_name=Q_0${num}
	uxadd mu mu=${mu_name} tnode=casplda02 label=\"Test pb109735 \"
	num=` expr ${num} + 1`
done

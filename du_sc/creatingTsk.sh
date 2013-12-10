#!/usr/bin/ksh
num=1
#upr_name=""

LOOP_1()
{
upr_base=QA24403
mu_name=DA_US_U_02
num_2=1
area=exp
user=univa
until [ ${num_2} -gt 99 ]
do
	[ ${num_2} -ge 10 ] || uproc_name=${upr_base}0${num_2}
	[ ${num_2} -ge 10 ] && uproc_name=${upr_base}${num_2}
	uxadd TSK $area UPR=${uproc_name} MU=${mu_name} TECHINF type=p USER=$user
	num_2=` expr ${num_2} + 1`
done
num=` expr ${num} + 1`
}

LOOP_2()
{
until [ ${num} -gt 99 ]
do
	num_2=1
	[ ${num} -ge 10 ] || mu_name=W_A_02_0${num}
	[ ${num} -ge 10 ] && mu_name=W_A_02_${num}
	until [ ${num_2} -gt 99 ]
	do
		[ ${num_2} -ge 10 ] || uproc_name=TC23156U0${num_2}
		[ ${num_2} -ge 10 ] && uproc_name=TC23156U${num_2}
		uxadd TSK $area UPR=${uproc_name} MU=${mu_name} TECHINF type=p USER=$user
		num_2=` expr ${num_2} + 1`
	done
	num=` expr ${num} + 1`
done
}

LOOP_1

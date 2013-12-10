#!/usr/bin/ksh -x
num=1
upr_base=QA24403
area=exp
vupr=000
upr_dir=$UXPEX
max=700
until [ ${num} -gt 99 ]
do
	[ ${num} -ge 10 ] || uproc_name=${upr_base}0${num}
	[ ${num} -ge 10 ] && uproc_name=${upr_base}${num}
	uxadd UPR $area UPR=${uproc_name} VUPR=$vupr LABEL=\"QA for 24403, MassTskCreation\" FPERIOD=d appl="U_" memo="O" nbper=1
	echo "exit 0" > ${upr_dir}/${uproc_name}.001
	chmod 777 ${upr_dir}/${uproc_name}.001
	num=` expr ${num} + 1`
done

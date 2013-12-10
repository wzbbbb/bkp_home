#!/usr/bin/ksh -x
# It will use external script /tmp/uproc_script.ksh
num=1
upr_base=PB105118_
area=app
vupr=001
upr_dir=$UXPAP
max=200
until [ ${num} -gt $max ]
do
	[ ${num} -ge 10 ] || uproc_name=${upr_base}0${num}
	[ ${num} -ge 10 ] && uproc_name=${upr_base}${num}
	uxadd UPR $area UPR=${uproc_name} VUPR=$vupr LABEL=\"mass user\" FPERIOD=d appl="U_" memo="O" nbper=1 CLFIL=/tmp/uproc_script.ksh UPT=CL_EXT
	#echo "exit 0" > ${upr_dir}/${uproc_name}.001
	#chmod 777 ${upr_dir}/${uproc_name}.001
	num=` expr ${num} + 1`
done

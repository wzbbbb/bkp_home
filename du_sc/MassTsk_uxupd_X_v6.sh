#!/bin/bash -x
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

#$UNI_DIR_EXEC/uxupd tsk APP tsk=${uproc_name} upr=${uproc_name} vupr=001 MU=\"S_TWEOTC_XX\" MODEL TIME MULW="((0730,0000,000)(0100,0000,000)(1300,0000,000),000,10)"
#$UNI_DIR_EXEC/uxupd tsk exp tsk=${uproc_name} upr=${uproc_name} vupr=000 MU=\"S_TWEOTC_XX\" TECHINF MULT TYPE=\"S\" LABEL=\"TWE_OTC_DP_ALL_WM TRANSFER POST\" USER=zwa QUEUE=SYS_BATCH
$UNI_DIR_EXEC/uxupd tsk exp tsk=${uproc_name} upr=${uproc_name} vupr=000 MU=\"S_TWEOTC_XX\" TECHINF MULT TYPE=\"C\" LABEL=\"TWE_OTC_DP_ALL_WM PICK STAT\" USER=zwa QUEUE=SYS_BATCH


	#echo "exit 0" > ${upr_dir}/${uproc_name}.001
	#chmod 777 ${upr_dir}/${uproc_name}.001
	num=` expr ${num} + 1`
done

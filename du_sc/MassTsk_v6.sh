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
	#uxadd UPR $area UPR=${uproc_name} VUPR=$vupr LABEL=\"mass user\" FPERIOD=d appl="U_" memo="O" nbper=1 CLFIL=/tmp/uproc_script.ksh UPT=CL_EXT

#$UNI_DIR_EXEC/uxadd tsk APP tsk=${uproc_name} upr=${uproc_name} vupr=001 MU=\"S_TWEOTC_XX\" MODEL TECHINF MULT TYPE=\"S\" LABEL=\"TWE_OTC_DP_ALL_WM TRANSFER POST\" USER=zwa QUEUE=SYS_BATCH 
#$UNI_DIR_EXEC/uxupd tsk APP tsk=${uproc_name} upr=${uproc_name} vupr=001 MU=\"S_TWEOTC_XX\" MODEL IMPL add rule="(ALLDAYS-MTWTFSS-001DAY,01/01/2012)" SDATE=05/02/2012 
#$UNI_DIR_EXEC/uxupd tsk APP tsk=${uproc_name} upr=${uproc_name} vupr=001 MU=\"S_TWEOTC_XX\" MODEL TIME MULW="((0730,0000,000)(0100,0000,000)(1300,0000,000),000,10)"

$UNI_DIR_EXEC/uxadd tsk app tsk=${uproc_name} upr=${uproc_name} vupr=001 MU=\"S_TWEOTC_XX\" model TECHINF NOHOLD MULT TYPE=\"C\" LABEL=\"TWE_OTC_DP_ALL_WM PICK STAT\" USER=zwa QUEUE=SYS_BATCH 
$UNI_DIR_EXEC/uxupd tsk app tsk=${uproc_name} upr=${uproc_name} vupr=001 MU=\"S_TWEOTC_XX\" model TIME CYCLICAL="((00000,15),(01/01/2012),(1400),(000,14))" ;

	#echo "exit 0" > ${upr_dir}/${uproc_name}.001
	#chmod 777 ${upr_dir}/${uproc_name}.001
	num=` expr ${num} + 1`
done

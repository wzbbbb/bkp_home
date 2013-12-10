#!/bin/ksh -x
# To call the SNC_RSYNC uproc, to sync different directories 
# d_dir, s_dir, diff_dir 

#$UXEXE/uxadd fla exp upr=SNC_RSYNC vupr=000 mu=DA_US_U_02 user=root launchvar=(/lcbkp/images, /etc )

p_date=`date +%m/%d/%Y`
#for /etc weekly
$UXEXE/uxadd fla exp upr=SNC_RSYNC vupr=000 mu=DA_US_U_02 user=root launchvar="((d_dir,/lcbkp/images/etc),(s_dir,/etc),(with_diff,no),(diff_dir,))" pdate=${p_date}

#for /data daily

$UXEXE/uxadd fla exp upr=SNC_RSYNC vupr=000 mu=DA_US_U_02 user=root launchvar="((d_dir,/lcbkp/images/data),(s_dir,/data),(with_diff,yes),(diff_dir,/lcbkp/images/data_diff))" pdate=${p_date}

#for /cases daily
$UXEXE/uxadd fla exp upr=SNC_RSYNC vupr=000 mu=DA_US_U_02 user=root launchvar="((d_dir,/lcbkp/images/cases),(s_dir,/cases),(with_diff,yes),(diff_dir,/lcbkp/images/cases_diff))" pdate=${p_date}


## /windata weekly

d_dir=/lcbkp/images/windata
#diff_dir=/lcbkp/images/windata/diff/
#re_diff_dir=/bkp/windata/diff/
s_dir=/windata
base_dir=/windata
list=`ls ${base_dir}`

#echo $list
MSG "for s in $list ; do"
for s in $list ; do
        if [ $s != "00_DA_US_Doc" ] && [ $s != "60_Projects" ] && [ $s != "60_Others_Projects" ] && [ $s != "Z_Old" ] ; then
                s_name1=$s
                fin_dir1=${d_dir}/${s_name1}
		$UXEXE/uxadd fla exp upr=SNC_RSYNC vupr=000 mu=DA_US_U_02 user=root launchvar="((d_dir,${fin_dir1}),(s_dir,${s_dir}/${s_name1}),(with_diff,no),(diff_dir,/lcbkp/images/windata_diff))" pdate=${p_date}

                #rsync -avb --delete  ${s_dir}/${s_name1}/ ${fin_dir1}/
        fi
done



# /windata daily

$UXEXE/uxadd fla exp upr=SNC_RSYNC vupr=000 mu=DA_US_U_02 user=root launchvar="((d_dir,/lcbkp/images/windata/00_DA_US_Doc),(s_dir,/windata/00_DA_US_Doc),(with_diff,yes),(diff_dir,/lcbkp/images/windata/00_DA_US_Doc_diff))" pdate=${p_date}

$UXEXE/uxadd fla exp upr=SNC_RSYNC vupr=000 mu=DA_US_U_02 user=root launchvar="((d_dir,/lcbkp/images/windata/60_Projects),(s_dir,/windata/60_Projects),(with_diff,yes),(diff_dir,/lcbkp/images/windata/60_Projects_diff))" pdate=${p_date}



#!/bin/ksh -x

MSG () {
echo "#CMD `date +%Y%m%d-%H:%M:%S`# $1"
}

#d_dir=/lcbkp/images/data
#diff_dir=/lcbkp/images/data_diff
#s_dir=/data
if [ ${with_diff} = "yes" ]; then
	tsp=`date +%Y%m%d-%H%M%S`
	MSG "rsync -avb --delete --backup-dir=${diff_dir}/${tsp} ${s_dir}/ ${d_dir}/"
	#rsync -avb --delete --backup-dir=${diff_dir}/${tsp} ${s_dir}/ ${d_dir}/
	rsync -avb  --backup-dir=${diff_dir}/${tsp} ${s_dir}/ ${d_dir}/
else
	MSG "rsync -avb --delete  ${s_dir}/ ${d_dir}/"
	#rsync -avb --delete  /${s_name1}/ ${fin_dir1}/
	rsync -avb   ${s_dir}/ ${d_dir}/
	#rsync -avb --delete  ${s_dir}/ ${d_dir}/
fi

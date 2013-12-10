#!/bin/ksh 
#set -x
###########
# For Daily Backup on data
# Works on 00_DA_US_Doc and 60_Projects
###########
MSG () {
echo "#CMD `date +%Y%m%d-%H:%M:%S`# $1"
}

d_dir=/lcbkp/images/data
diff_dir=/lcbkp/images/data_diff
re_d_dir=/bkp/data
re_diff_dir=/bkp/data/diff
s_dir=/data
name=data
tsp=`date +%Y%m%d-%H%M%S`
s_dir_tsp=${tsp}-${name}
diff_s_dir_tsp=${s_dir_tsp}_diff
tmp=/tmp
arc_days=1
keep_diff_days=7
rsync -avb --delete --backup-dir=${diff_dir}/${tsp} ${s_dir}/ ${d_dir}/
#gzip diff file; move to /bkp and remove them from support2
mount|grep "/bkp" |grep "support5" >> /dev/null
l_rc=$?
[ $l_rc -ne 0 ] && MSG "/bkp on Support5 is not mounted" && exit $l_rc

available_bkp=`df -k|grep /bkp|tr ' ' '#'|tr -s "#" "#"|cut -d# -f4`
[ $available_bkp -lt 1000000 ] && MSG "not enough space on /bkp" && exit 1

#keeping 1 day's image diff
MSG "find ${diff_dir}/ -mtime +${arc_days} -maxdepth 1 -exec rm -rf {} \; "
find ${diff_dir}/ -mtime +${arc_days} -maxdepth 1 -exec rm -rf {} \; 
l_rc=$?
[ $l_rc -ne 0 ] && MSG "find diff failed" && exit $l_rc

MSG "if [ -d ${diff_dir}/${tsp}/ ] ; then "
if [ -d ${diff_dir}/${tsp}/ ] ; then 
	MSG "tar zcf ${diff_dir}/${tsp}.tar.gz ${diff_dir}/${tsp}/"
	tar zcf ${diff_dir}/${tsp}.tar.gz ${diff_dir}/${tsp}/
	l_rc=$?
	[ $l_rc -ne 0 ] && MSG "tar failed" && exit $l_rc
	MSG "mv  ${diff_dir}/${tsp}.tar.gz  ${re_diff_dir}"
	mv  ${diff_dir}/${tsp}.tar.gz  ${re_diff_dir}
	l_rc=$?
	[ $l_rc -ne 0 ] && MSG "mv failed" && exit $l_rc
	#rm -rf ${diff_dir}/${diff_name1_tsp} 
	MSG "find ${re_diff_dir}/ -mtime +${keep_diff_days} -maxdepth 1 -exec rm -f {} \;"
	#keeping 7 day's gziped diff
	find ${re_diff_dir}/ -mtime +${keep_diff_days} -maxdepth 1 -exec rm -f {} \; 
	l_rc=$?
	[ $l_rc -ne 0 ] && MSG "find diff failed" && exit $l_rc
fi
#rm -rf ${diff_dir}/*
#gzip images and move to bkp.
MSG  "tar zcf ${tmp}/${s_dir_tsp}.tar.gz  ${d_dir}/"
tar zcf ${tmp}/${s_dir_tsp}.tar.gz  ${d_dir}/
l_rc=$?
[ $l_rc -ne 0 ] && MSG "tar failed" && exit $l_rc
#mv ${d_dir}/${name1_tsp}.tar.gz ${d_dir}/${name2_tsp}.tar.gz ${re_d_dir}
MSG "mv ${tmp}/${s_dir_tsp}.tar.gz  ${re_d_dir}"
mv ${tmp}/${s_dir_tsp}.tar.gz  ${re_d_dir}
l_rc=$?
[ $l_rc -ne 0 ] && MSG "mv failed" && exit $l_rc
MSG "find ${re_d_dir}/ -mtime +${arc_days} -maxdepth 1 -exec rm -f {} \; "
find ${re_d_dir}/ -mtime +${arc_days} -maxdepth 1 -exec rm -f {} \; #keeping 1 day's image
l_rc=$?
[ $l_rc -ne 0 ] && MSG "find failed" && exit $l_rc
MSG "==The End=="
exit 0

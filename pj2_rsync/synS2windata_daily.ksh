#!/bin/ksh 
#set -x
###########
# For Daily Backup on windata
# Works on 00_DA_US_Doc and 60_Projects
###########
MSG () {
echo "#CMD `date +%Y%m%d-%H:%M:%S`# $1"
}

d_dir=/lcbkp/images/windata
diff_dir=/lcbkp/images/windata/diff
re_d_dir=/bkp/windata/
re_diff_dir=/bkp/windata/diff/
s_dir=/windata
s_name1=00_DA_US_Doc
s_name2=60_Projects
fin_dir1=${d_dir}/${s_name1}
fin_dir2=${d_dir}/${s_name2}
tsp=`date +%Y%m%d-%H%M%S`
name1_tsp=${tsp}-${s_name1} 
name2_tsp=${tsp}-${s_name2}
diff_name1_tsp=`date +%Y%m%d-%H%M%S`${s_name1}_diff 
diff_name2_tsp=`date +%Y%m%d-%H%M%S`${s_name2}_diff 
arc_days=1
rsync -avb --delete --backup-dir=${diff_dir}/${diff_name1_tsp} ${s_dir}/${s_name1}/ ${fin_dir1}/
rsync -avb --delete --backup-dir=${diff_dir}/${diff_name2_tsp} ${s_dir}/${s_name2}/ ${fin_dir2}/
mount|grep "/bkp" |grep "support5" >> /dev/null
l_rc=$?
[ $l_rc -ne 0 ] && MSG "/bkp on Support5 is not mounted" && exit $l_rc

available_bkp=`df -k|grep /bkp|tr ' ' '#'|tr -s "#" "#"|cut -d# -f4`
[ $available_bkp -lt 1000000 ] && MSG "not enough space on /bkp" && exit 1

#gzip diff file; move to /bkp and remove them from support2
MSG "if [ -d ${diff_dir}/${diff_name1_tsp} ] ; then "
if [ -d ${diff_dir}/${diff_name1_tsp} ] ; then 
	MSG "tar zcf ${diff_dir}/${diff_name1_tsp}.tar.gz ${diff_dir}/${diff_name1_tsp}"
	tar zcf ${diff_dir}/${diff_name1_tsp}.tar.gz ${diff_dir}/${diff_name1_tsp}
	l_rc=$?
	[ $l_rc -ne 0 ] && MSG "tar failed" && exit $l_rc
	MSG "mv  ${diff_dir}/${diff_name1_tsp}.tar.gz  ${re_diff_dir}"
	mv  ${diff_dir}/${diff_name1_tsp}.tar.gz  ${re_diff_dir}
	l_rc=$?
	[ $l_rc -ne 0 ] && MSG "mv failed" && exit $l_rc
	#rm -rf ${diff_dir}/${diff_name1_tsp} 
fi
MSG "if [ -d  ${diff_dir}/${diff_name2_tsp} ] ; then "
if [ -d  ${diff_dir}/${diff_name2_tsp} ] ; then 
	MSG "tar zcf ${diff_dir}/${diff_name2_tsp}.tar.gz ${diff_dir}/${diff_name2_tsp}"
	tar zcf ${diff_dir}/${diff_name2_tsp}.tar.gz ${diff_dir}/${diff_name2_tsp}
	l_rc=$?
	[ $l_rc -ne 0 ] && MSG "tar failed" && exit $l_rc
	MSG "mv   ${diff_dir}/${diff_name2_tsp}.tar.gz ${re_diff_dir}"
	mv   ${diff_dir}/${diff_name2_tsp}.tar.gz ${re_diff_dir}
	l_rc=$?
	[ $l_rc -ne 0 ] && MSG "mv failed" && exit $l_rc

	#rm -rf  ${diff_dir}/${diff_name2_tsp}
fi
MSG "rm -rf ${diff_dir}/*"
rm -rf ${diff_dir}/*
l_rc=$?
[ $l_rc -ne 0 ] && MSG "mv failed" && exit $l_rc
#gzip images and move to bkp.
MSG "tar zcf ${d_dir}/${name1_tsp}.tar.gz  ${d_dir}/${s_name1}/"
tar zcf ${d_dir}/${name1_tsp}.tar.gz  ${d_dir}/${s_name1}/
l_rc=$?
[ $l_rc -ne 0 ] && MSG "tar failed" && exit $l_rc
MSG "tar zcf ${d_dir}/${name2_tsp}.tar.gz  ${d_dir}/${s_name2}/"
tar zcf ${d_dir}/${name2_tsp}.tar.gz  ${d_dir}/${s_name2}/
l_rc=$?
[ $l_rc -ne 0 ] && MSG "tar failed" && exit $l_rc
MSG "mv ${d_dir}/${name1_tsp}.tar.gz ${d_dir}/${name2_tsp}.tar.gz ${re_d_dir}"
mv ${d_dir}/${name1_tsp}.tar.gz ${d_dir}/${name2_tsp}.tar.gz ${re_d_dir}
l_rc=$?
[ $l_rc -ne 0 ] && MSG "mv failed" && exit $l_rc
MSG "find ${re_d_dir} -mtime +${arc_days} -name "*${s_name1}*" -exec rm -f {} \; #keeping 1 day"
find ${re_d_dir} -mtime +${arc_days} -name "*${s_name1}*" -exec rm -f {} \; #keeping 1 day
l_rc=$?
[ $l_rc -ne 0 ] && MSG "find failed" && exit $l_rc
MSG "find ${re_d_dir} -mtime +${arc_days} -name "*${s_name2}*" -exec rm -f {} \; #keeping 1 day"
find ${re_d_dir} -mtime +${arc_days} -name "*${s_name2}*" -exec rm -f {} \; #keeping 1 day
l_rc=$?
[ $l_rc -ne 0 ] && MSG "find failed" && exit $l_rc
MSG "== The End =="
exit 0

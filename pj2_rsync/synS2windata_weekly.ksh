#!/bin/ksh 
#set -x
###########
# For Weekly Backup on windata and /etc
###########
## for /etc
MSG () {
echo "#CMD `date +%Y%m%d-%H:%M:%S`# $1"
}

s_name1=etc
d_dir=/lcbkp/images
re_d_dir=/bkp/etc
#s_dir=/
tsp=`date +%Y%m%d-%H%M%S`
fin_dir1=${d_dir}/${s_name1}
name1_tsp=${tsp}-${s_name1} 
arc_days=1
rsync -avb --delete  /${s_name1}/ ${fin_dir1}/
mount|grep "/bkp" |grep "support5" >> /dev/null
l_rc=$?
[ $l_rc -ne 0 ] && MSG "/bkp on Support5 is not mounted" && exit $l_rc
MSG "tar zcf ${d_dir}/${name1_tsp}.tar.gz  ${d_dir}/${s_name1}/"
tar zcf ${d_dir}/${name1_tsp}.tar.gz  ${d_dir}/${s_name1}/
l_rc=$?
[ $l_rc -ne 0 ] && MSG "tar failed" && exit $l_rc
MSG "mv ${d_dir}/${name1_tsp}.tar.gz  ${re_d_dir}"
mv ${d_dir}/${name1_tsp}.tar.gz  ${re_d_dir}
l_rc=$?
[ $l_rc -ne 0 ] && MSG "mv failed" && exit $l_rc
MSG "find ${re_d_dir} -mtime +${arc_days} -exec rm -f {} \; #keeping 1 day"
find ${re_d_dir} -mtime +${arc_days} -exec rm -f {} \; #keeping 1 day
l_rc=$?
[ $l_rc -ne 0 ] && MSG "find failed" && exit $l_rc

available_bkp=`df -k|grep /bkp|tr ' ' '#'|tr -s "#" "#"|cut -d# -f4`
[ $available_bkp -lt 1000000 ] && MSG "not enough space on /bkp" && exit 1

## /windata

d_dir=/lcbkp/images/windata
#diff_dir=/lcbkp/images/windata/diff/
re_d_dir=/bkp/windata
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
		name1_tsp=${tsp}-${s_name1} 
		arc_days=1
		rsync -avb --delete  ${s_dir}/${s_name1}/ ${fin_dir1}/
		MSG "tar zcf ${d_dir}/${name1_tsp}.tar.gz  ${d_dir}/${s_name1}/"
		tar zcf ${d_dir}/${name1_tsp}.tar.gz  ${d_dir}/${s_name1}/
		l_rc=$?
		[ $l_rc -ne 0 ] && MSG "tar failed" && exit $l_rc
		MSG "find ${re_d_dir}  -name "*${s_name1}*" -exec rm -f {} \;"
		find ${re_d_dir}  -name "*${s_name1}*" -exec rm -f {} \; 
		l_rc=$?
		[ $l_rc -ne 0 ] && MSG "find & remove failed" && exit $l_rc
		MSG "mv ${d_dir}/${name1_tsp}.tar.gz  ${re_d_dir}"
		mv ${d_dir}/${name1_tsp}.tar.gz  ${re_d_dir}
		l_rc=$?
		[ $l_rc -ne 0 ] && MSG "mv failed" && exit $l_rc
        fi
done
MSG  "== The End =="
exit 0

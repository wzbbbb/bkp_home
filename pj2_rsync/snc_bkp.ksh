#arc_days, local archive days
#diff__dir
#re_diff_dir
#s_dir
#d_dir
#with_diff
#keep_diff_days, remote diff days

tsp=`date +%Y%m%d-%H%M%S`

day_=`date +%Y%m%d`
#keeping 1 day's image diff
if [ $with_diff = yes ]; then
	MSG "find ${diff_dir}/ -mtime +${arc_days} -maxdepth 1 -exec rm -rf {} \; "
	find ${diff_dir}/ -mtime +${arc_days} -maxdepth 1 -exec rm -rf {} \;
	l_rc=$?
	[ $l_rc -ne 0 ] && MSG "find diff failed" && exit $l_rc

	MSG "if [ -d ${diff_dir}/${day_}* ] ; then "
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


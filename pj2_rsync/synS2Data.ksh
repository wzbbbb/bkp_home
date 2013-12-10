#!/bin/ksh
#set -x
g_name=data
g_host=s2
g_src_dir=/${g_name}
g_trg_dir=/lcbkp/images
g_tmp_dir=/lcbkp/tmp
g_diff_dir=/lcbkp/images/${g_name}_diff
g_tsp=`date +%Y%m%d-%H%M%S`
g_fin_bkp=/bkp/Clean
#ZWA: Modify begin#
g_data_bkp=/bkp/data
g_arc_days=1
#ZWA: Modify end#
g_bkp_flag=on

g_dir_lst="g_src_dir g_trg_dir g_diff_dir"
for l_dir_var in ${g_dir_lst}
do
	eval l_dir=\$${l_dir_var}
	if [ ! -d ${l_dir} ]; then
		echo "#WAR# the directory ${l_dir} does not exists"
		exit 1
	fi
done

echo "#CMD# rsync --delete -av --backup --backup-dir=${g_diff_dir}/${g_tsp} ${g_src_dir} ${g_trg_dir}"
rsync --delete -av --backup --backup-dir=${g_diff_dir}/`date +%Y%m%d-%H%M%S` ${g_src_dir} ${g_trg_dir}
l_rc=$?
[ ${l_rc} -eq 0 ] || exit ${l_rc}

[ ${g_bkp_flag} = on ] || exit 0
[ -d ${g_diff_dir}/${g_tsp} ] || exit 0

mount | grep /bkp | grep "support5:" > /dev/null 2>&1
l_rc=$?

if [ ${l_rc} -eq 0 ]; then
	echo "#REM# Backup of the differencies"
	cd ${g_diff_dir}
	tar -cf ${g_tmp_dir}/${g_host}_${g_name}_incr_${g_tsp}.tar ./${g_tsp}
	gzip ${g_tmp_dir}/${g_host}_${g_name}_incr_${g_tsp}.tar
	if [ -f ${g_tmp_dir}/${g_host}_${g_name}_incr_${g_tsp}.tar ]; then
		echo "#CMD# mv ${g_tmp_dir}/${g_host}_${g_name}_incr_${g_tsp}.tar ${g_fin_bkp}"
		mv ${g_tmp_dir}/${g_host}_${g_name}_incr_${g_tsp}.tar ${g_fin_bkp}
	fi
	if [ -f ${g_tmp_dir}/${g_host}_${g_name}_incr_${g_tsp}.tar.gz ];then
		echo "#CMD# mv ${g_tmp_dir}/${g_host}_${g_name}_incr_${g_tsp}.tar.gz ${g_fin_bkp}"
		mv ${g_tmp_dir}/${g_host}_${g_name}_incr_${g_tsp}.tar.gz ${g_fin_bkp}
	fi
else
	echo "#WAR# /bkp is not mounted from support5"
	exit 1
fi

#ZWA: Modify begin#
tar zcf ${g_data_bkp}/${g_tsp}_${g_name}.tar.gz ${g_trg_dir}/${g_name}
find ${g_data_bkp}/ -mtime +${g_arc_days} -exec rm -f {} \; #keep 1 days immages.
#ZWA: Modify end#



#/bin/ksh
# Aug. 05th, 2005
# ORSYP Software Inc.
# Zhibing Wang
# Version 1.0.0 Aug. 09th, 2005
############################################
#Purpose: this APS script detects patches and launch the patching script.
############################################
set -x
err_log_dir=/etc/APS/err_log/
arch_log_dir=/etc/APS/log/
pkg_base=/etc/APS/
if [ $1 = "US" ] ; then
	#script_base=/data/daenv/APS/
	script_base=/etc/daenv/APS/
	else	
	#script_base=/dadata/daenv/APS/
	script_base=/etc/daenv/APS/
fi
detect_patches () {
	# find is there is a patch
	path_list=`find ${pkg_base} -name *.taz` 
	# test if the patch_list is null
	[ -z "$path_list" ] && echo "No new patches." && exit 0
}
prepare_parameters () { #find the company name and patch name from the directory structure
	p=$1
	company_name=`echo $p|cut -f4 -d"/"`
	patch_name=`echo $p|cut -f6 -d"/"|cut -f1 -d"."`
}
start_pathing () {
	#going to the directory and check if the  APS_special.ksh exists.
	tsp=`date +%Y%m%d-%H%M%S`
	p=$1
	dir=`echo $p|cut -f1-5 -d"/"`
	[ -z "$dir" ] && echo "Can't find the patch directory." && exit 1
	cd $dir
	ls ./APS_special.ksh
	if [ $? -eq 0 ] ; then # using the APS_special.ksh
		./APS_special.ksh $company_name $patch_name $dir > ${tsp}_${company_name}_${patch_name}.log
		rc=$?
	else
		${script_base}/APS_normal.ksh $company_name $patch_name $dir > ${tsp}_${company_name}_${patch_name}.log
		rc=$?
	fi
}
patch_fail () {
	[ -z "$dir" ] && echo "Can't find the patch directory." && exit 1
	cd $dir
	mv -f ${patch_name}.taz ${patch_name}.taz_fail
	cp *.log ${err_log_dir}
	#rm -rf ./linux
	rm -rf ./${patch_name}
	echo "One of the patching procedures failed. Abort the whole process!"
	exit 1
}
patch_success () {
	[ -z "$dir" ] && echo "Can't find the patch directory." && exit 1
	cd $dir
	mv -f *.log ${arch_log_dir}
	rm -f ./*.taz
	#rm -rf ./linux
	rm -rf ./${patch_name}
}
big_loop  () {
	for patch_path in $path_list ; do
		prepare_parameters $patch_path
		start_pathing $patch_path 
		if [ $rc -eq 0 ] ; then
			patch_success
		else
			patch_fail
		fi
	done
}
detect_patches
big_loop 


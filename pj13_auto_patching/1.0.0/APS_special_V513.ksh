#!/bin/ksh 
# Aug. 05th, 2005
# ORSYP Software Inc.
# Zhibing Wang
# Version 1.0.0 Aug. 09th, 2005
############################################
#Purpose: this APS script do the patching
############################################
set -x
tmp=/tmp/tmp$$
company_name=$1
patch_name=$2
dir=$3
update_level=513
stop_du() {
	$UXMGR/uxshutdown
	[ $? -ne 0  ] && echo "Failed to shutdown the Dollar Universe Company ${S_SOCIETE}" && exit 1

	# find if any processes are not stopped 
	ps -ef |grep  ${S_SOCIETE} |grep -v grep |grep -v APS_normal.ksh |grep -v APS_special.ksh
	# kill the remaining process
	if [ $? -eq 0  ] ; then  
		# get the process IDs
		list=`ps -ef|grep  ${S_SOCIETE}|grep -v grep|grep -v APS_normal.ksh|grep -v APS_special.ksh| tr -s ' ' ' '  |cut -f2 -d" "`
		kill ${list}
		[ $? -ne 0  ] && echo "Failed to kill remaining process" && exit 1
	fi
}

detect_patch () {
	#pkg_name=`ls ./*.taz >/dev/null 2>&1`
	pkg_name=`ls ${dir}/*.taz`
	if [ $? -ne 0  ] ; then # just in case it named *.TAZ
		#pkg_name=`ls ./*.TAZ >/dev/null 2>&1`
		pkg_name=`ls ${dir}/*.TAZ`
		[ $? -ne 0  ] && echo "No patch found in this directory!" && exit 1
	fi
	# cut off the .taz from the patch name
	# patch_name=`echo $pkg_name | tr '[a-z]' '[A-Z]' |sed -e "s/.TAZ//g"`
}
unpack () {
	tar zxvf $pkg_name
}
load_env () {
	env_file=`find /apps/ -name  uxsetenv |grep $company_name`
	. $env_file
}
#patching () {
#	cd ${dir}/linux/${patch_name}
#	sed '/C;ALL_COMP;OFF/s/^/#/' ./input.file >$tmp
#	mv -f $tmp ./input.file 
#	./install.ksh
#	[ $? -ne 0  ] && echo "Patching failed, please check the log!" && exit 1
#	sleep 3
#	$UXEXE/uxversion
#}
patching () {
	cd ${dir}/DUS${update_level}/tools
	#sed '/C;ALL_COMP;OFF/s/^/#/' ./input.file >$tmp
	#mv -f $tmp ./input.file 
	./uxupgrade.ksh $S_SOCIETE $UXMGR NO_VRFY_ALL_COMP_STATUS NO_CONFIRMATION
	#./install.ksh
	[ $? -ne 0  ] && echo "Patching failed, please check the log!" && exit 1
	sleep 3
	$UXEXE/uxversion
	cd ${dir}
	#rm -rf  ${dir}/DUS512
	rm -rf  ${dir}/DUS${update_level}
}
relink () {
	echo "Relinking ..."
	#/etc/daenv/du/DuRelink 512
	/etc/daenv/du/DuRelink $update_level
	[ $? -ne 0  ] && echo "Relink failed, please check the log!" && exit 1
	sleep 3
}
start_du () {
	$UXMGR/uxstartup
}

load_env
echo "Working on ${S_SOCIETE}"
stop_du
detect_patch
unpack
patching
relink
start_du


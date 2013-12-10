#!/bin/bash
PROC_STATUS_LINUX()
{
	num_proc=`ps -eo pid,command |grep ux|grep -v grep |wc -l`
	s=`ps -eo pid,command |grep ux|grep -v grep| sed 's/$/\|/g'`
	outfile=${1}/ps_status.txt
	i=1
	while [ $i -le $num_proc ] ; do
		pic_comm=`echo $s |cut -f${i} -d"|"`
		pid_=`echo $pic_comm|cut -f1 -d" "`
		p_name_=`echo $pic_comm|cut -f2- -d" "`
		#echo "i is $i, PID iS $pid_, process name is $p_name_"
		cd /proc/${pid_}/
		echo "###### $pid_, $p_name_ ######" >> $outfile
		echo "=== statm ===" >> $outfile
		cat statm >> $outfile
		cat status |grep allowed >> $outfile
		echo "=== oom_score ===" >> $outfile
		cat oom_score >> $outfile
		echo "=== oom_adj ===" >> $outfile
		cat oom_adj >> $outfile
		echo "=== fd ===" >> $outfile
		ls -l fd >> $outfile 2>&1
		(( i += 1 ))
	done
}
PROC_STATUS_LINUX /users/zwa/pj8_unix_uxtrace/temp

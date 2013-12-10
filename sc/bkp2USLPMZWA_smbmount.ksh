#!/bin/ksh
set -x
s_dir=/data/home/zwa/
d_dir=/home/zwa/mnt/

umnt () {
	smbumount /home/zwa/mnt
	[ $? -ne 0 ] &&  mail -s "smbumount /home/zwa/mnt failed" zwa@orsyp.com && exit 1
}

ping -c1 calpmzwa > /dev/null
[ $? -ne 0 ] && mail -s "calpmzwa is down, support2 backup skipped" zwa@orsyp.com && exit 1
mount |grep /home/zwa/mnt > /dev/null 2>&1 

if [ $? -eq 0 ] ; then 
	 echo "/home/zwa/mnt is already mounted"   
else 
	smbmount //calpmzwa/Backup_support2 /home/zwa/mnt -o username=zwa,workgroup=ORSYP,password='mar999%!&'
fi
#rsync -av --delete $s_dir $d_dir 
cd $s_dir
ts=`date +%F_%H%M` 
tar_name=/tmp/${ts}_supprt2_bkp.tar.gz
tar zcf  $tar_name ./*
[ $? -ne 0 ] &&  mail -s "support2 tar failed" zwa@orsyp.com && umnt && exit 1
mv $tar_name $d_dir
[ $? -ne 0 ] &&  mail -s "support2 backup failed" zwa@orsyp.com && umnt && exit 1
find /home/zwa/mnt/ -mtime +7 -exec rm -f {} \;
[ $? -ne 0 ] &&  mail -s "find & rm  failed" zwa@orsyp.com && umnt && exit 1
umnt
exit 0

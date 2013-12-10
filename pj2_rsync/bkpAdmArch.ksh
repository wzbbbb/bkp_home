#!/bin/ksh 
set -x
######################
#
# To back up the ADMIN5/archive directory to the /bkp on support5
#
######################
tsp=`date +%Y%m%d-%H%M%S`
days=7
MSG () {
echo "#CMD `date +%Y%m%d-%H:%M:%S`# $1"
}
mount|grep "/bkp" |grep "support5" >> /dev/null
l_rc=$?
[ $l_rc -ne 0 ] && MSG "/bkp on Support5 is not mounted" && exit $l_rc
MSG "cd /apps/du/ADMIN5/"
cd /apps/du/ADMIN5/
MSG "tar zcvf /tmp/archive_${tsp}.tar.gz ./archive/*"
tar zcvf /tmp/archive_${tsp}.tar.gz ./archive/*
l_rc=$?
[ $l_rc -ne 0 ] && MSG "tar failed" && exit $l_rc
MSG "mv  /tmp/archive_${tsp}.tar.gz /bkp/admin_archive"
mv  /tmp/archive_${tsp}.tar.gz /bkp/admin_archive
l_rc=$?
[ $l_rc -ne 0 ] && MSG "mv to /bkp failed" && exit $l_rc
#ls -lR ./archive
MSG "find ./archive -mtime +${days} -exec rm -fr {} \;"
find ./archive -mtime +${days} -exec rm -rf {} \; 
#the return code may not be 0, even the files have all been deleted
#l_rc=$?
#[ $l_rc -ne 0 ] && MSG "find & rm failed" && exit $l_rc
old_file=`find ./archive -mtime +${days}| sed -n '$='` #Any old files not being deleted?
[ $old_file ] && MSG "Some old files are not deleted" && exit 1
MSG "find /bkp/admin_archive -mtime +${days} -name "archive*" -exec rm -f {} \;"
find /bkp/admin_archive -mtime +${days} -name "archive*" -exec rm -f {} \;
l_rc=$?
[ $l_rc -ne 0 ] && MSG "remove the old backup failed in /bkp/admin_archive" && exit $l_rc
MSG "== The End =="


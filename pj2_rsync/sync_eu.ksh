#!/bin/ksh
set -x
remote_dir=/eu/dadata
#s_dir=/data/daenv/
#d_dir=/eu/dadata/daenv/

ping -c1 frsdlsup01 > /dev/null
[ $? -ne 0 ] && echo "frsdlsup01 is down!" && exit 1

mount |grep ${remote_dir} > /dev/null 2>&1
if [ $? -eq 0 ] ; then
        echo "${remote_dir} is already mounted"
else
	mount ${remote_dir}
	[ $? -ne 0 ] && echo "Failed to mount ${remote_dir}!" && exit 1
fi

rsync -av  --delete --backup --backup-dir=/eu/dadata/diff_daenv/`date +%Y%m%d-%H%M%S`  /data/daenv/ /eu/dadata/daenv/
#rsync -av  --delete --backup --backup-dir=/eu/dadata/diff_dalcl/`date +%Y%m%d-%H%M%S`  /data/dalcl/ /eu/dadata/dalcl/

umount ${remote_dir}

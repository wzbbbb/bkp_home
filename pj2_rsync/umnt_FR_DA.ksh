#!bin/ksh -x

slot_beg=20
slot_end=8
MSG () {
echo "#CMD `date +%Y%m%d-%H:%M:%S`# $1"
}

MSG "mount |grep "/FR/DA" >/dev/null 2>&1"
mount |grep "/FR/DA" >/dev/null 2>&1
mounted_=$?
if [ $mounted_ -ne 0 ] ; then
	echo "The /FR/DA partition is not mounted. Nothing to do!"
	exit 0
fi

now_=`date +%H`
while [ $now_ -ge $slot_beg -o $now_ -lt $slot_end ] ; do
	#ps -ef | grep mv | grep "/FR/DA/Incident"
	ps -lef| grep "/FR/DA"|grep -v grep |grep -v smbmount
	in_use=$?
	if [ $in_use -eq 0 ]; then 
		sleep 600 #/FR/DA  in use
	else
		MSG "umount /FR/DA "
		umount /FR/DA 
		umounted_=$?
		if [ $umounted_ -ne 0 ] ; then
			MSG "umount failed with exit id $umounted_"
		else 
			MSG "/FR/DA unmounted!"
		fi
		exit $umounted_
	fi
	now_=`date +%H`
done

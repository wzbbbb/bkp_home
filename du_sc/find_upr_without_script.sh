#!/bin/bash 
#/tmp/uxlst_upr1.txt is the file with uproc name as the first and only column
cd /apps/du/530/FLS530/exp/upr
for ((i=1;i<19997;i++)); do
	s=`sed -n ${i}p /tmp/uxlst_upr1.txt`
	ls ${s}.000
	rc=$?
	if [ $rc -ne "0" ]; then
		echo "one uproc script missing, ${s}.000"
		echo "exit 0" > ${s}.000
		chmod +x ${s}.000
	fi
done

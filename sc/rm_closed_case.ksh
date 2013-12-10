#!/bin/ksh -x
if [ ${2:-NONE} = "NONE" ] ; then
echo "Usage: rm_closed_case.ksh XCASPLDA01CLN_CASES.0014122 "2008\/10" "
echo "Please specify the latest job log of CLN_CASES, and a date "
echo "All cases closed before that date will be removed. "
echo "For example: /apps/du/ADMLIN/exp/log/XCASPLDA01CLN_CASES.0014122"
exit 1
fi
date_=$2
#echo " date_ is $date_"
logdir=/apps/du/ADMLIN/exp/log
joblog=$1
cases_=`grep -b3 "Closure Date : $date_" ${logdir}/${joblog} |grep "Incident Number"|cut -f2 -d":"|tr -d " "`
for case_ in $cases_ ; do
find /dsk1/cases/ -name $case_ -exec rm -rf {} \;
done

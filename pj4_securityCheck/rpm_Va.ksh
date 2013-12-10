#!/bin/ksh -x
admin="zwa@orsyp.com gmu@orsyp.com"
random=$$
output=/tmp/rpm_V_${random}.txt
rpm -Va |grep bin |grep -v '/usr/bin/dbiproxy' > $output
rc=$?
[ $rc -eq 0 ] && mail -s "`date '+%F_%H:%M'` Support2: Some binaries have been changed!" $admin < $output
rm -f $output
rc=$?
[ $rc -ne 0 ] && exit $rc
exit 0

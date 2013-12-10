#!/bin/ksh
#set -x
###########
# For Weekly Backup on windata and /etc
###########
## for /etc
MSG () {
echo "#CMD `date +%Y%m%d-%H:%M:%S`# $1"
}

######################
## variables
######################
ses_monitored=SNCS2
days_monitored=3
email=zwa@orsyp.com
today=`date "+%Y%m%d"`
echo $today
MSG "$UXEXE/uxdat yyyymmdd "$today" mm/dd/yyyy -${days_monitored}d"
target_day=`$UXEXE/uxdat "yyyymmdd" "$today" mm/dd/yyyy -${days_monitored}d`
echo $target_day
MSG "$UXEXE/uxlst ctl ses=$ses_monitored since="\(${target_day},0001\)" full"
$UXEXE/uxlst ctl ses=$ses_monitored since="(${target_day},0001)" full > /tmp/SyncMonitor$$.txt
l_rc=$?
[ $l_rc -ne 0 ] && MSG "uxlst ctl failed" && exit $l_rc

mail -s "Sync Monitor report"  $email < /tmp/SyncMonitor$$.txt

rm -f /tmp/SyncMonitor$$.txt

exit 0

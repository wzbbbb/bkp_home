#
# ORSYP ZWA
# 09/22/2009
#
#!/bin/ksh 
output=./impacted_jobs.txt
date_time_fmt=`env|grep U_FMT_DATE |cut -f2 -d"="`
if [ ! ${date_time_fmt} ] ; then 
	echo "############ Error! "
	echo "############ Please load DUAS environment first! "
	exit 1
fi

if [ ! $1 ] ; then
	echo "############ Error!" 
	echo "############ Please input data and time in the following format: ${date_time_fmt}:HHMM" 
	echo "############ For example: ./impacted_jobs.sh 09/20/2019:2000"
	exit 1
fi
reading=$1
date_=`echo $reading |cut -f1 -d":"`
time_=`echo $reading |cut -f2 -d":"`
echo "############ Please be aware that this script can generate valid result, "  
echo "############ only when the launcher is not started."  

echo ""  >> ./$output
echo ""  >> ./$output
echo "############ The following jobs are still in LAUNCH WAIT"  > ./$output
echo ""  >> ./$output
echo ""  >> ./$output
$UXEXE/uxlst fla exp status=L full  before=${date_},${time_} >> ./$output

echo ""  >> ./$output
echo ""  >> ./$output
echo "############ The following jobs are in sessions, whose session hearders are still in LAUNCH WAIT"  >> ./$output
echo ""  >> ./$output
echo ""  >> ./$output
ses_name=`$UXEXE/uxlst fla exp full status=L ses=* before=${date_},${time_} |sed '1,4d' |cut -c1-12| tr -d ' '| grep -v ^$`

for s in $ses_name ; do
	$UXEXE/uxshw ses ses=$s lnk >> ./$output
done

echo ""  >> ./$output
echo ""  >> ./$output
echo "############ The following jobs were in EXECUTING status,"  >> ./$output
echo "############ they could show in ABORTED status after the launcher is started"  >> ./$output
echo ""  >> ./$output
echo ""  >> ./$output
$UXEXE/uxlst ctl exp status=E full  2>/dev/null>> ./$output

echo ""  >> ./$output
echo ""  >> ./$output
echo "############ Some uprocs in the following sessions were in EXECUTING status, as showing above."  >> ./$output
echo "############ The rest of the sessions may not run, if those uprocs ABORTED."  >> ./$output
echo ""  >> ./$output
echo ""  >> ./$output
ses_name=`uxlst ctl exp status=E full 2>/dev/null |sed '1,4d' |cut -c1-12| tr -d ' '| grep -v ^$`
for s in $ses_name ; do
	$UXEXE/uxshw ses ses=$s lnk >> ./$output
done

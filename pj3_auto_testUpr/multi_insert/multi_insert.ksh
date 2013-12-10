#!/bin/ksh 
#set -x
HELP () {
echo "   Extract case related objects (uprocs and sessions) and insert them to different \$U Companies"
echo "   Usage:"
echo "   Please load the Environment of the source Dollar Universe Company," 
echo "   and specify the case number or the first a few chars of the objects. "
echo "   By default, the APP area will be used."
echo "   ./multi_insert.ksh -c 34567 -a APP"
exit 1
}
[ ! $1 ] && HELP && exit 1
while getopts c:a:h options; do
	case $options in 
		c) case_no=$OPTARG;;
		#echo $case_no;;
		a) area_=$OPTARG;;
		#echo $area_;;
		h|help|*) HELP;;
	esac
done

tmp_no=$$
area_=${area_:-app}
case $area_ in 
	APP|app|A|a)
		area=app
		s_area=A;;
	INT|int|I|i)
		area=int
		s_area=I;;
	SIM|sim|S|s)
		area=sim
		s_area=S;;
	EXP|exp|X|x)
		area=exp
		s_area=X;;
esac
#env_file=${base_dir}/mgr/uxsetenv
#. $env_file
$UXEXE/uxshw upr $area upr="TC${case_no}*" > /dev/null
if [ $? -eq 0 ] ; then 
	$UXEXE/uxext upr $area upr="TC${case_no}*" output=/tmp/${tmp_no}_${case_no}_upr.ext
	$UXEXE/uxext ses $area ses="TC${case_no}*" output=/tmp/${tmp_no}_${case_no}_ses.ext
	[ $? -eq 0 ] && with_ses=y 
fi 
$UXEXE/uxshw upr $area upr="${case_no}*" > /dev/null
if [ $? -eq 0 ] ; then 
	$UXEXE/uxext upr $area upr="${case_no}*" output=/tmp/${tmp_no}_${case_no}_upr.ext
	$UXEXE/uxext ses $area ses="${case_no}*" output=/tmp/${tmp_no}_${case_no}_ses.ext
	[ $? -eq 0 ] && with_ses=y 
fi
s_company=$S_SOCIETE
#list="SUP500 QCL500 MNT500"
list=`ls /apps/du/500/*/mgr/uxsetenv`
for ls_output in $list ; do
company=`echo ${ls_output} |cut -f5 -d"/"`
	[ $company = $s_company ] && echo "Skipping the Company $s_company" && continue
	echo "Inserting to $company $area ..."
	netstat -a |grep LISTEN|grep ${company}_IO_${s_area} >> /dev/null
	[ $? -ne 0 ] && echo "The Company $company area $area is not started!" && continue
	#env_file=/apps/du/500/${company}/mgr/uxsetenv
	env_file=${ls_output}
	. $env_file
	$UXEXE/uxins upr $area upr=* input=/tmp/${tmp_no}_${case_no}_upr.ext
	[ ${with_ses:-n} = y ] && $UXEXE/uxins ses $area ses=* input=/tmp/${tmp_no}_${case_no}_ses.ext
done
rm -f /tmp/${tmp_no}_${case_no}_upr.ext /tmp/${tmp_no}_${case_no}_ses.ext
exit 0

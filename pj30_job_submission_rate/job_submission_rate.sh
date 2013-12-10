#
# ORSYP ZWA
# 09/24/2009
#
#!/bin/bash 
date_=$1
#hour_=$2
file_="EXP_dudmp_ctl_lst.txt"
thresh_hold=80
if [ $2 ] ; then 
	thresh_hold=$2
else 
	thresh_hold=80
fi
echo "The number of jobs were started in one minute." > ./loaded_moment.txt
echo "########### For the day $date_: " 
for ((i=0;i<25;i++)); do
	if [ $i -le 9 ] ; then
		h=0${i}
	else
		h=$i
	fi
	num_=`grep "  ${date_} ${h}" $file_ |wc -l`
	echo "### For the hour $h: ${num_}"
	for ((j=0;j<60;j++)); do
		if [ $j -le 9 ] ; then
			m=0${j}
		else
			m=$j
		fi
		num_m=`grep "  ${date_} ${h}${m}" $file_ |wc -l`
		if [ $num_m -gt $thresh_hold ] ; then
			echo "For the time ${h}${m}: ${num_m}  <======== Over the threshold" 
			echo "For the time ${date_} ${h}${m}: ${num_m}  <======== Over the threshold" >> ./loaded_moment.txt
		else
			echo "For the time ${h}${m}: ${num_m}"
		fi
	done
done



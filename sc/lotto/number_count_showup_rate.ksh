#!/bin/bash -x

#column=$1
declare -a num_count
i=1
#initialize all 0 array
while [[ $i -le 49 ]] ; do
	#echo "i is $i"
	num_count[${i}]=0
	[ $? -ne 0 ] &&  exit $?
	let i+=1
done
#get count totally show up times for each number 
for ((i=1;i<7;i++)); do
	list=`cut -f${i} -d" " lotto_num_total.txt `
	[ $? -ne 0 ] &&  exit $?

	for s in $list ; do
	       let num_count[$s]+=1
		[ $? -ne 0 ] &&  exit $?
	done

done
#output to a file
i=1
while [[ $i -le 49 ]] ; do
	echo "$i ${num_count[$i]}" >>./total_showup_times.txt
	let i+=1
	[ $? -ne 0 ] &&  exit $?
done

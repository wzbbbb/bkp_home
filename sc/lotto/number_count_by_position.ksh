#!/bin/bash -x

column=$1
declare -a num_count
i=1
while [[ $i -le 49 ]] ; do
	#echo "i is $i"
	num_count[${i}]=0
	[ $? -ne 0 ] &&  exit $?
	let i+=1
done
list=`cut -f${column} -d" " lotto_num_total.txt `
[ $? -ne 0 ] &&  exit $?

for s in $list ; do
       let num_count[$s]+=1
	[ $? -ne 0 ] &&  exit $?
done

i=1
while [[ $i -le 49 ]] ; do
	echo "$i ${num_count[$i]}" >>./row_$column.txt
	let i+=1
	[ $? -ne 0 ] &&  exit $?
done

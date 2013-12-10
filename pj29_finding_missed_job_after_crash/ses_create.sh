#!/bin/bash -x

total_line=`wc -l EXP_ses_shw.txt`
s=`grep -n ITEMS EXP_ses_shw.txt |cut -f1 -d":"`

#ses_name=`grep -n ITEMS EXP_ses_shw.txt |cut -f3 -d":"`

i=1
for n in $s ; do 
	array[$i]=$n
	let i+=1
	#echo ${array[$i]}
done 
i=1
for m in $s ; do
	let j=$i+1
	head_=${array[$i]}
	let tail_=${array[$j]}-3
	sed -n ${head_},${tail_}p EXP_ses_shw.txt >ses_output_${i}.txt
	let i+=1
done

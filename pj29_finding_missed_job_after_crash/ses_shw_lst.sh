#!/bin/bash -x
n=`wc -l $1|cut -f1 -d" "`
#let m=$n+1
i=1
while [[ $i -le $n ]]; do
	ses_name=`sed -n ${i}p $1 |tr "\r" " "`
	filename=`grep $ses_name ses_output_*|cut -f1 -d":"`

	cat $filename >> ses_shw_output.txt
	let i+=1
done

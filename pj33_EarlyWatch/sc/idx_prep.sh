# This is part of the monthly file prepartion 
# It will add the keys normally used for queries. 
#!/bin/bash

#company_id;node_name;product_name;time_stamp;country;region;OS;command_name;content

company_id=123456
node_name=casplda02
product_name=DU6.0.15
year_=2013
month_=06
date_=24
hour_=11
country=CANADA
region=QC
city=Montreal
OS=Linux
input=$1
temp_file=/dev/shm/keys.txt
cmd_line_nums=`grep -n '###CMD:' $input| cut -d":" -f1 `
#cmd_names=`grep -n '###CMD:' $input | cut -d":" -f3`
#echo $cmd_line_numss
end_line_nums=`grep -n '###END:' $input| cut -d":" -f1`
i=0
for cmd_line  in $cmd_line_nums ; do # where each cmd starts
	arr_cmd_line[$i]=$cmd_line
	echo "cmd arry"	${arr_cmd_line[$i]}
	let i+=1
done
i=0
for end_line  in $end_line_nums ; do # where each cmd ends
	arr_end_line[$i]=$end_line
	echo "end arry"	${arr_end_line[$i]}
	let i+=1
done
echo "Array items and indexes:"
for index in ${!arr_cmd_line[*]} #loop through the array
do
	printf "%4d: %s\n" $index ${arr_cmd_line[$index]}
	command_name=`sed -n "${arr_cmd_line[$index]}p" $input|cut -d":" -f2`
	#to add the keys to the end of temp_file
	num_lines_2_add=`expr ${arr_end_line[$index]} - ${arr_cmd_line[$index]} + 1` 
	for ((i=0;i<$num_lines_2_add;i++)); do
		echo "$company_id;$node_name;$product_name;$year_;$month_;$date_;$hour_;$country;$region;$city;$OS;${command_name};" >>$temp_file
	done
done
#then paste together with the target file
paste $temp_file $input >> ${company_id}_${node_name}_${year_}-${month_}-${date_}_${hour_}.txt
rm $temp_file

#!/bin/bash -x
declare -a ymd 
#define an array for each of 1-49
for ((i=1;i<50;i++)); do
	declare -a arr${i}
	#eval arr${i}[1]=0
	[ $? -ne 0 ] &&  exit $?
done
list_ymd=`cut -f1 -d" " lotto_history.txt`
#populating the ymd array
n=1
for s in $list_ymd ; do
	ymd[${n}]=$s
	[ $? -ne 0 ] &&  exit $?
	let n+=1
done
#echo "n is $n ==================================="
#echo "ymd[105] is ${ymd[105]}"
#n is the total number of records + 1
for ((m=1;m<50;m++)); do #loop through 49 arrays
	for ((j=1;j<$n;j++)); do #assigning 0 to each number array 
		eval arr${m}[${j}]="0"
		[ $? -ne 0 ] &&  exit $?
	done
done
#echo "arr49[105] is ${arr49[105]} ================================="
#reading 1 column a time, 
#and find the array and the location (date) to + 1
for ((i=2;i<8;i++)); do
	x=1 #the date position within each array
	list_num=`cut -f${i} -d" " lotto_history.txt`
	for s in $list_num ; do
		let arr${s}[$x]+=1
		[ $? -ne 0 ] &&  exit $?
		let x+=1 # now the next line in the lotto_history.txt
	done
done
#output each array
#for ((m=1;m<50;m++)); do #remove all output
#	array_name="arr$m"
#	echo "${arr1[@]}" >tmp.txt
#	sed 's/\s/\n/g' tmp.txt > time_position_1.txt
#	[ $? -ne 0 ] &&  exit $?
#done
echo "${arr1[@]}" >tmp.txt
sed 's/\s/\n/g' tmp.txt > time_position_1.txt
echo "${arr2[@]}" >tmp.txt
sed 's/\s/\n/g' tmp.txt > time_position_2.txt
echo "${arr3[@]}" >tmp.txt
sed 's/\s/\n/g' tmp.txt > time_position_3.txt
echo "${arr4[@]}" >tmp.txt
sed 's/\s/\n/g' tmp.txt > time_position_4.txt
echo "${arr5[@]}" >tmp.txt
sed 's/\s/\n/g' tmp.txt > time_position_5.txt
echo "${arr6[@]}" >tmp.txt
sed 's/\s/\n/g' tmp.txt > time_position_6.txt
echo "${arr7[@]}" >tmp.txt
sed 's/\s/\n/g' tmp.txt > time_position_7.txt
echo "${arr8[@]}" >tmp.txt
sed 's/\s/\n/g' tmp.txt > time_position_8.txt
echo "${arr9[@]}" >tmp.txt
sed 's/\s/\n/g' tmp.txt > time_position_9.txt
echo "${arr10[@]}" >tmp.txt
sed 's/\s/\n/g' tmp.txt > time_position_10.txt
echo "${arr11[@]}" >tmp.txt
sed 's/\s/\n/g' tmp.txt > time_position_11.txt
echo "${arr12[@]}" >tmp.txt
sed 's/\s/\n/g' tmp.txt > time_position_12.txt
echo "${arr13[@]}" >tmp.txt
sed 's/\s/\n/g' tmp.txt > time_position_13.txt
echo "${arr14[@]}" >tmp.txt
sed 's/\s/\n/g' tmp.txt > time_position_14.txt
echo "${arr15[@]}" >tmp.txt
sed 's/\s/\n/g' tmp.txt > time_position_15.txt
echo "${arr16[@]}" >tmp.txt
sed 's/\s/\n/g' tmp.txt > time_position_16.txt
echo "${arr17[@]}" >tmp.txt
sed 's/\s/\n/g' tmp.txt > time_position_17.txt
echo "${arr18[@]}" >tmp.txt
sed 's/\s/\n/g' tmp.txt > time_position_18.txt
echo "${arr19[@]}" >tmp.txt
sed 's/\s/\n/g' tmp.txt > time_position_19.txt
echo "${arr20[@]}" >tmp.txt
sed 's/\s/\n/g' tmp.txt > time_position_20.txt
echo "${arr21[@]}" >tmp.txt
sed 's/\s/\n/g' tmp.txt > time_position_21.txt
echo "${arr22[@]}" >tmp.txt
sed 's/\s/\n/g' tmp.txt > time_position_22.txt
echo "${arr23[@]}" >tmp.txt
sed 's/\s/\n/g' tmp.txt > time_position_23.txt
echo "${arr24[@]}" >tmp.txt
sed 's/\s/\n/g' tmp.txt > time_position_24.txt
echo "${arr25[@]}" >tmp.txt
sed 's/\s/\n/g' tmp.txt > time_position_25.txt
echo "${arr26[@]}" >tmp.txt
sed 's/\s/\n/g' tmp.txt > time_position_26.txt
echo "${arr27[@]}" >tmp.txt
sed 's/\s/\n/g' tmp.txt > time_position_27.txt
echo "${arr28[@]}" >tmp.txt
sed 's/\s/\n/g' tmp.txt > time_position_28.txt
echo "${arr29[@]}" >tmp.txt
sed 's/\s/\n/g' tmp.txt > time_position_29.txt
echo "${arr30[@]}" >tmp.txt
sed 's/\s/\n/g' tmp.txt > time_position_30.txt
echo "${arr31[@]}" >tmp.txt
sed 's/\s/\n/g' tmp.txt > time_position_31.txt
echo "${arr32[@]}" >tmp.txt
sed 's/\s/\n/g' tmp.txt > time_position_32.txt
echo "${arr33[@]}" >tmp.txt
sed 's/\s/\n/g' tmp.txt > time_position_33.txt
echo "${arr34[@]}" >tmp.txt
sed 's/\s/\n/g' tmp.txt > time_position_34.txt
echo "${arr35[@]}" >tmp.txt
sed 's/\s/\n/g' tmp.txt > time_position_35.txt
echo "${arr36[@]}" >tmp.txt
sed 's/\s/\n/g' tmp.txt > time_position_36.txt
echo "${arr37[@]}" >tmp.txt
sed 's/\s/\n/g' tmp.txt > time_position_37.txt
echo "${arr38[@]}" >tmp.txt
sed 's/\s/\n/g' tmp.txt > time_position_38.txt
echo "${arr39[@]}" >tmp.txt
sed 's/\s/\n/g' tmp.txt > time_position_39.txt
echo "${arr40[@]}" >tmp.txt
sed 's/\s/\n/g' tmp.txt > time_position_40.txt
echo "${arr41[@]}" >tmp.txt
sed 's/\s/\n/g' tmp.txt > time_position_41.txt
echo "${arr42[@]}" >tmp.txt
sed 's/\s/\n/g' tmp.txt > time_position_42.txt
echo "${arr43[@]}" >tmp.txt
sed 's/\s/\n/g' tmp.txt > time_position_43.txt
echo "${arr44[@]}" >tmp.txt
sed 's/\s/\n/g' tmp.txt > time_position_44.txt
echo "${arr45[@]}" >tmp.txt
sed 's/\s/\n/g' tmp.txt > time_position_45.txt
echo "${arr46[@]}" >tmp.txt
sed 's/\s/\n/g' tmp.txt > time_position_46.txt
echo "${arr47[@]}" >tmp.txt
sed 's/\s/\n/g' tmp.txt > time_position_47.txt
echo "${arr48[@]}" >tmp.txt
sed 's/\s/\n/g' tmp.txt > time_position_48.txt
echo "${arr49[@]}" >tmp.txt
sed 's/\s/\n/g' tmp.txt > time_position_49.txt

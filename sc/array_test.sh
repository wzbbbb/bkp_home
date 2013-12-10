#!/bin/bash -x
for ((i=1;i<50;i++)); do
        declare -a arr${i}
        #eval arr${i}[1]=0
        [ $? -ne 0 ] &&  exit $?
done
n=5
for ((m=1;m<50;m++)); do #loop through 49 arrays
        for ((j=1;j<$n;j++)); do #assigning 0 to each number array
                eval arr${m}[${j}]="0"
                [ $? -ne 0 ] &&  exit $?
        done
        #ssss=eval ${arr${m}[@]:0}
        #echo  " ======================  ${arr${m}[@]}"
done
p=49
m=10
echo "${arr1[@]}"
 arr_name="arr$m"
echo "arr_name is $arr_name"

eval " ${\$arr_name[@]} " 
#for ((m=1;m<50;m++)); do #loop through 49 arrays
#                 arr_name="arr$m"
#                 echo  " ${$arr_name[@]}" >>array_test_${m}.txt
#                [ $? -ne 0 ] &&  exit $?
#done


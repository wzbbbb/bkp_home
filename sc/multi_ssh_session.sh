#!/bin/ksh
target_node=demeter
#user_name=plwr
loop=15
i=0
while [[ $i -le $loop ]];do
	#echo "i is $i"
	ssh $target_node "env|grep SSH_CONNECTION"  > /tmp/ssh_output_$i.txt &
   (( i += 1 ))
done




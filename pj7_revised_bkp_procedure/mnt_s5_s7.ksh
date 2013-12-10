#!/bin/ksh -x 

ck_space() {
#$1 partition name
#$2 space needed
	available=`df -k $1 |grep $1 |tr ' ' '#'|tr -s "#" "#"|cut -d# -f4`
	[ $available -lt $2 ] && echo "The space remains on $1 is less than $2!" && exit 1
	exit 0
}
if [ $S_UG = "N_NODE5" ]; then
	mount |grep support5 > /dev/null 2>&1
	if [ $? -eq 0 ]; then  
		echo "support5:/bkp is already mounted"  
		ck_space /bkp 1000000
	else
		ping -c1 support5 > /dev/null
		[ $? -ne 0 ] && echo "support5 is down, skip the mount" && exit 1
		mount /bkp
		rc=$?
		if [ $rc -eq 0 ]; then  
			echo "support5:/bkp is just mounted"  
			ck_space /bkp 1000000
		else
			echo "Failed to mount support5:/bkp" && exit $rc
		fi
	fi 
	#available_bkp=`df -k /bkp|grep /bkp|tr ' ' '#'|tr -s "#" "#"|cut -d# -f4`
	#[ $available_bkp -lt 1000000 ] && echo "not enough space on /bkp" && exit 1
fi

if [ $S_UG = "N_NODE7" ]; then
	mount |grep //USSDMDA007/DATA1 > /dev/null 2>&1
	if [ $? -eq 0 ]; then  
		echo "support7:/bkp is already mounted"  
		#available_s7bkp=`df -k /s7bkp|grep /s7bkp|tr ' ' '#'|tr -s "#" "#"|cut -d# -f4`
		#[ $available_s7bkp -lt 1000000 ] && echo "not enough space on /bkp" && exit 1
		ck_space /s7bkp 1000000
	else
		ping -c1 support7 > /dev/null
		[ $? -ne 0 ] && echo "support7 is down, skip the mount" && exit 1
		smbmount //USSDMDA007/DATA1 /s7bkp -o username=bkp,password=bkpbkp
		rc=$?
		if [ $rc -eq 0 ]; then  
			echo "support7:/bkp is just mounted"  
			#available_s7bkp=`df -k /s7bkp|grep /s7bkp|tr ' ' '#'|tr -s "#" "#"|cut -d# -f4`
			#[ $available_s7bkp -lt 1000000 ] && echo "not enough space on /bkp" && exit 1
			ck_space /s7bkp 1000000
		else
			echo "Failed to mount support7" && exit $rc
		fi
	fi 

fi



#! /bin/bash -x
for ((i=1;i<5500;i++)) ; do
	$UXEXE/uxadd node tnode=lnx${i}
done

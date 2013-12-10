#!/bin/bash
# to update all of the file resource to use a single local file
# to be used when implement customer produciton involving file resources
file_res_list=`$UXEXE/uxshw res res=* |grep -b2 "nature       : fil"|grep res | cut -f2 -d:`
for file_res in  $file_res_list ; do
	$UXEXE/uxupd res res=$file_res dir=/tmp fname=file_res.txt
done

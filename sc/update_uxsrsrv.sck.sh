#!/bin/bash

tmp_file=/tmp/tmp_$$
tmp_file1=/tmp/tmp_$$_1
file_list=`locate mgr\/uxsrsrv.sck`

for ff in $file_list ; do
	cat $ff | sed "s/casdlsup06.orsypgroup.com/casplda02/g" > $tmp_file
	cat $tmp_file | sed "s/casdlsup06$/casplda02/g"  > $tmp_file1
	mv $ff ${ff}_old
	mv  $tmp_file1 $ff
	chown univa:univ $ff
done

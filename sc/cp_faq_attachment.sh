#!/bin/bash -x
path_=`pwd`
last_dir=`basename $path_`
if [ $last_dir != "work" ] ; then
echo "### This script need to be run in the work directory of a case"
echo "### This script assumes that the images are saved in the work directory."
exit 1
fi

#if [ ! $1 ] ; then
#echo "Please input the image file names!"
#exit 1
#fi
#filename_=$1

path1_=`dirname $path_`
case_no=`basename $path1_`
t_dir1=`echo $case_no|cut -c1,2` 
t_dir2=`echo $case_no|cut -c1,2,3` 

for f in *.JPG ; do mv ./"$f" "${f%JPG}jpg"; done
#scp $filename_ root@frsdlpegas:/faq_attach/${t_dir1}xxx/${t_dir2}xx/${case_no}/
scp *.jpg root@frsdlpegas:/faq_attach/${t_dir1}xxx/${t_dir2}xx/${case_no}/


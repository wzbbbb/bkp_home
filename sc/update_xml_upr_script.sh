#! /bin/ksh

files_=`ls *.000`

for file_ in $files_ ; do
	sed /\<value\>/s/\'//g $file_ |sed /\<printerName\>/s/\"//g|sed /\<style\>/s/\"//g > ./${file_}_new
done

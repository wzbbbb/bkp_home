#!/bin/ksh
#set -x
x=1
y=2

while getopts abc: options; do
	case $options
	in
	a) x="x is a"
	echo $x ;;
	b) y="y is b"
	echo $y ;;
	c) case ${OPTARG} in 
		[0-9]) echo "c is a number" ;;
		[a-z]) echo "c is a small letter";;
		[A-Z]) echo "c is a capital letter" ;;


	esac

	esac
done

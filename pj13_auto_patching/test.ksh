#!/bin/ksh
set -x

def1 () {
	a=1
	echo "in def1 a=$a"
}
def2() {
	a=`expr $a + 1` 
	echo "in def2 a=$a"
}

def1
def2

#!/bin/ksh
# Oct. 28th, 2005
# ORSYP Software Inc.
# Zhibing Wang
# Version 0.0.1 Oct. 28th, 2005
############################################
#Purpose: 
# Automatically generate a summary of the current environment
########################################
echo "##################################################################"
echo "========== Automatically generated environment report ============"
echo "##################################################################"
echo
echo
echo "====== date and time"
date
echo
echo
echo "====== hostname"
uname -a 
echo
echo
echo "====== OS release"
head /etc/*release*
echo
echo
echo "====== Dollar Universe node name"
env|grep NOEUD
echo
echo
echo "====== Dollar Universe Company name"
env|grep SOC
echo
echo
echo "====== Dollar Universe Company patch level"
if [ -z $UXEXE ] ; then
	echo "No Dollar Universe Environment loaded!"
else
	$UXEXE/uxversion
fi

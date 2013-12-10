#!/bin/ksh
cd /apps/du/530/TST530/mgr
. ./uxsetenv
$UXEXE/uxlst ctl exp full
echo ""
echo "############################################"
echo "############################################"
echo ""
$UXEXE/uxlst ctl app full

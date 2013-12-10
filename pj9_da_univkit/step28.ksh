#/bin/ksh -x
tmp=/tmp/tmp$$
rgz_line=`grep ux_vrf_rgz_rst $UXMGR/uxstartup|grep "#"`
commented_out=$?
if [ $commented_out -eq 0 ]; then
	line_no=`grep -n ux_vrf_rgz_rst $UXMGR/uxstartup|cut -f1 -d":"`
	sed "${line_no}s/#//g" $UXMGR/uxstartup  > $tmp
	mv $UXMGR/uxstartup $UXMGR/uxstartup_bkp  
	mv  $tmp $UXMGR/uxstartup
fi

sed -e '/uxsetenv/a\' -e "/etc/daenv/du/lib_lnk_chk"  $UXMGR/uxstartup> $tmp # append to the line
mv $UXMGR/uxstartup $UXMGR/uxstartup_bkp  
mv  $tmp $UXMGR/uxstartup


chown univa:users $UXMGR/uxstartup
chmod 750 $UXMGR/uxstartup 

#!/usr/bin/ksh
# kill -s 16 pidof(trap_sig.ksh)
# the output will be in /tmp/script.out
#
exec >>/tmp/script.out 2>&1
trap ext_t 16
function ext_t
{
print "USR1 recieved"
date
print
}

while true
do
sleep 10
done

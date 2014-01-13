#!/bin/bash
# find the local IP that is used for the GW
# normally should be eth0, for this test, it is eth1
# then send heartbeat and get the respond
# if the respond is not "OK", run it with curl|bash
IP=`/sbin/ifconfig  eth1|grep "inet "|cut -f2 -d":"|cut -f1 -d' '`
ts=`date +%s`
echo $ts
ver=1
#IP='192.168.114.208'
s=`curl -s http://$IP/SDC/`
echo $s
if [ $s = "\"OK\"" ] ; then
    echo 'yes'
fi
resp=`curl -s -X POST -H "Content-Type: application/json" -d "{"IP":"$IP","time_stamp":"${ts}","version",$ver}" http://$IP/SDC/heartbeat/`
echo $resp
if [ "${resp}" != "\"OK\"" ] ; then
    curl -s http://$IP/$resp|bash
fi

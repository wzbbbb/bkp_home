#!/bin/bash 
# find the local IP that is used for the GW
# normally should be eth0, for this test, it is eth1
# then send heartbeat and get the respond
# if the respond is not "OK", run it with curl|bash
IP=`/sbin/ifconfig  eth1|grep "inet "|cut -f2 -d":"|cut -f1 -d' '`
ts=`date +%s`
n_ver=`/usr/sbin/nginx -v 2>&1|cut -f2 -d'/'`
#echo $ts
ver=`cat gw.version`
#IP='192.168.114.208'
s=`curl -s http://$IP/SDC/`
#echo $s
#if [ $s = "\"OK\"" ] ; then
#    echo 'yes'
#fi
resp=`curl -s -X POST -H "Content-Type: application/json" -d "{"\"IP"\":"\"$IP"\","\"time_stamp"\":$ts,"\"version"\":$ver,"\"nginx_version"\":"\"${n_ver}"\"}" http://$IP/SDC/heartbeat/`
#echo $resp
if [ "${resp}" != "\"OK\"" ] ; then
    url=`echo $resp|cut -f2 -d'"'|cut -f1 -d'"'`
    #echo $url
    curl -s http://$IP/$url|bash
fi

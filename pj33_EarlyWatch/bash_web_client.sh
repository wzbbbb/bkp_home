#!/bin/bash

#exec 5<> /dev/tcp/freegeoip.com/80
#cat <&5 &
#printf "GET /csv/ HTTP/1.0\r\n\r\n" >&5
#(echo 'GET /csv HTTP/1.1\nHost: www.freegeoip.net\n\n'; sleep 2 ) | telnet www.freegeoip.net 80
(echo -e 'GET http://freegeoip.net/csv/ HTTP/1.1\nHost: www.freegeoip.net\n\n'; sleep 2 ) | telnet www.freegeoip.net 80

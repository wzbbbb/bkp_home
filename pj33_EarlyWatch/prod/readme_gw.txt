The design of gateway is focused on easy to implement, configure and maintenance.
To implement run, the IP is the server that provide the download. It can be a different server from the SD. 
curl -s 192.168.115.41/download/gw6.sh|bash

That script will download and install necessary package, and scripts.  

The hearbeat and GW control  is based on the same mechanism. 
The hearbeat will read respons from SD, then download and run script if necessary.


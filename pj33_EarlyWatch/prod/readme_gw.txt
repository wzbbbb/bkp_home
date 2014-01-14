The design of gateway is focused on easy to implement, configure and maintenance.
To implement run, the IP is the server that provide the download. It can be a different server from the SD. 

gw6.sh  -
curl -s 192.168.115.41/download/gw6.sh|bash    ---

That script will download and install necessary package, and scripts.  

1. install and configure nginx
2. enable log rotation for nginx
3. download heartbeat.sh and schedule it as cron job
4. create ~root/gw.version
5. create ~root/ready_for_upgrade


The hearbeat and GW control  is based on the same mechanism. 
The hearbeat will read respons from SD, then download and run script if necessary.

Trigger a update on the GW	 -
To do that, upload a new control script to the SD, like this
curl -F "file=@version_x_upgrade.sh" http://192.168.115.41/SDC/gateway  ---

It will register into SD. When the next heartbeat comes, the SD will compare
the version info. If the GW version is old, SD will send the url in the reply
to the hearbeat. The GW will then run the new update script specified in that
url. 

The control script then increase the ~root/gw.version to +1. So, the next time
the heartbeat will have a newer version in it.

The update script will also check a status file, and remove it during the
update, to avoid mulitple update running the same time. Once, the update is
done, the status file will be put back.
The status file is.
~root/ready_for_upgrade

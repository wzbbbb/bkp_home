#!/bin/bash 
ls -la /etc/daenv/env/Alias|grep 2004
if [ $? -eq 0 ] ; then
rm /etc/daenv/env/Alias_old
mv /etc/daenv/env/Alias /etc/daenv/env/Alias_old
cp /users/zwa/sc/env_restore/Alias /etc/daenv/env/Alias
fi

ls -la /etc/daenv/env/Env |grep 2004
if [ $? -eq 0 ] ; then
rm /etc/daenv/env/Env_old
mv /etc/daenv/env/Env /etc/daenv/env/Env_old
cp /users/zwa/sc/env_restore/Env /etc/daenv/env/Env
fi

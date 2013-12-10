#!/bin/bash -x

num=1
max=160
until [ ${num} -gt $max ]
do
        code=` expr ${num} + 200`
        $UXEXE/uxadd user user=user_${num} code=$code prof=PROFADM 

        num=` expr ${num} + 1`
done


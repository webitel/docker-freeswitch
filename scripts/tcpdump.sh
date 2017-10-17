#!/bin/bash

fl=$(date +%s%N)
/usr/sbin/tcpdump -nq -s 0 -i any -w $1 $3 > /tmp/$fl 2>&1 &
PID=$!
sleep 1s

if [ -e /proc/$PID ]
then
    sleep $2
    kill $PID
else
    cat /tmp/$fl > $1
    echo error
fi

sleep 1s
rm -rf /tmp/$fl
exit 0

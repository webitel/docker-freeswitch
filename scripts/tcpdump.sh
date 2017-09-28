#!/bin/sh

/usr/sbin/tcpdump -nq -s 0 -i any -w $1 $3 &
pid=$!
sleep $2
kill $pid

exit 0

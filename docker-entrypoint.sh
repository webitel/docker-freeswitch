#!/bin/bash
set -e
export PATH=/usr/local/freeswitch/bin:$PATH

echo 'Webitel '$VERSION

if [ "$DEV" ]; then
    export PRIVATE_IPV4="${PRIVATE_IPV4:-$(ip addr show eth0 | grep 'inet ' | awk '{print $2}' | cut -d/ -f1)}"
else
    export PRIVATE_IPV4="${PRIVATE_IPV4:-$(ip addr show eth1 | grep 'inet ' | awk '{print $2}' | cut -d/ -f1)}"
fi

if [ "$PRIVATE_IPV4" ]; then
    sed -i 's/PRIVATE_IPV4/'$PRIVATE_IPV4'/g' /conf/configuration.xml
else
    sed -i '/PRIVATE_IPV4/d' /conf/configuration.xml
fi

if [ "$RTP_START_PORT" ]; then
    sed -i 's/RTP_START_PORT/'$RTP_START_PORT'/g' /conf/configuration.xml
else
    sed -i 's/RTP_START_PORT/20000/g' /conf/configuration.xml
fi

if [ "$RTP_END_PORT" ]; then
    sed -i 's/RTP_END_PORT/'$RTP_END_PORT'/g' /conf/configuration.xml
else
    sed -i 's/RTP_END_PORT/29999/g' /conf/configuration.xml
fi

if [ "$MAX_SESSIONS" ]; then
    sed -i 's/MAX_SESSIONS/'$MAX_SESSIONS'/g' /conf/configuration.xml
else
    sed -i 's/MAX_SESSIONS/1000/g' /conf/configuration.xml
fi

if [ "$SESSIONS_PER_SECOND" ]; then
    sed -i 's/SESSIONS_PER_SECOND/'$SESSIONS_PER_SECOND'/g' /conf/configuration.xml
else
    sed -i 's/SESSIONS_PER_SECOND/30/g' /conf/configuration.xml
fi

if [ "$LOGLEVEL" ]; then
    sed -i 's/LOGLEVEL/'$LOGLEVEL'/g' /conf/vars.xml
else
    sed -i 's/LOGLEVEL/err/g' /conf/vars.xml
fi

test -d /logs || mkdir -p /logs /certs /sounds /db /recordings /scripts/lua

chown -R freeswitch:freeswitch /usr/local/freeswitch
chown -R freeswitch:freeswitch /{logs,tmp,db,sounds,conf,certs,scripts,recordings,images}

ln -s /dev/null /dev/raw1394
ln -s /usr/local/freeswitch/bin/fs_cli /usr/local/bin/fs_cli

if [ "$1" = 'freeswitch' ]; then

    if [ -d /docker-entrypoint.d ]; then
        for f in /docker-entrypoint.d/*.sh; do
	    echo "$f"
            [ -f "$f" ] && /bin/bash "$f"
        done
    fi

    echo 'Starting FreeSWITCH '$FS_VERSION

    exec freeswitch -u freeswitch -g freeswitch -c \
        -sounds /sounds -recordings /recordings \
        -certs /certs -conf /conf -db /db \
        -scripts /scripts -log /logs
fi

exec "$@"


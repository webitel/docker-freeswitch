#!/bin/bash
set -e
export PATH=/usr/local/freeswitch/bin:$PATH

echo 'Webitel '$VERSION

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
        -scripts /scripts -log /logs \
        -nonat
fi

exec "$@"

#!/bin/bash
set -e
export PATH=/usr/local/freeswitch/bin:$PATH

echo 'Webitel '$VERSION

if [ "$DEV" ]; then
    export PRIVATE_IPV4="${PRIVATE_IPV4:-$(ip addr show eth0 | grep 'inet ' | awk '{print $2}' | cut -d/ -f1)}"
else
    export PRIVATE_IPV4="${PRIVATE_IPV4:-$(ip addr show eth1 | grep 'inet ' | awk '{print $2}' | cut -d/ -f1)}"
fi

if [ "$SBC" ]; then
    mv -f /conf/freeswitch.xml.sbc /conf/freeswitch.xml
    sed -i '/dsn/d' /conf/configuration.xml
    sed -i '/module=\"mod_amd/d' /conf/configuration.xml
    sed -i '/module=\"mod_spandsp/d' /conf/configuration.xml
    sed -i '/module=\"mod_imagick/d' /conf/configuration.xml
    sed -i '/module=\"mod_png/d' /conf/configuration.xml
    sed -i '/module=\"mod_av/d' /conf/configuration.xml
    sed -i '/module=\"mod_sndfile/d' /conf/configuration.xml
    sed -i '/module=\"mod_native_file/d' /conf/configuration.xml
    sed -i '/module=\"mod_shout/d' /conf/configuration.xml
    sed -i '/module=\"mod_local_stream/d' /conf/configuration.xml
    sed -i '/module=\"mod_tone_stream/d' /conf/configuration.xml
    sed -i '/module=\"mod_lua/d' /conf/configuration.xml
    sed -i '/module=\"mod_say_ru/d' /conf/configuration.xml
    sed -i '/module=\"mod_say_en/d' /conf/configuration.xml
    sed -i '/module=\"mod_conference/d' /conf/configuration.xml
    sed -i '/module=\"mod_valet_parking/d' /conf/configuration.xml
    sed -i '/module=\"mod_http_cache/d' /conf/configuration.xml
    sed -i '/module=\"mod_spy/d' /conf/configuration.xml
    sed -i '/module=\"mod_grpc/d' /conf/configuration.xml
    sed -i '/module=\"mod_amqp/d' /conf/configuration.xml
fi

if [ "$PRIVATE_IPV4" ]; then
    sed -i 's/PRIVATE_IPV4/'$PRIVATE_IPV4'/g' /conf/configuration.xml
else
    sed -i '/PRIVATE_IPV4/d' /conf/configuration.xml
fi

if [ "$CONSUL" ]; then
    sed -i 's/CONSUL_HOST/'$CONSUL'/g' /conf/configuration.xml
else
    sed -i '/CONSUL_HOST/d' /conf/configuration.xml
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


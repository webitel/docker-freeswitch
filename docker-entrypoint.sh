#!/bin/bash
set -e
export PATH=$PATH:/usr/local/freeswitch/bin

echo 'Webitel '$VERSION
sed -i 's/WEBITEL_MAJOR/'$WEBITEL_MAJOR'/g' /conf/vars.xml

if [ "$RTP_START_PORT" ]; then
    sed -i 's/RTP_START_PORT/'$RTP_START_PORT'/g' /conf/configur*.xml
else
    sed -i 's/RTP_START_PORT/20000/g' /conf/configur*.xml
fi

if [ "$RTP_END_PORT" ]; then
    sed -i 's/RTP_END_PORT/'$RTP_END_PORT'/g' /conf/configur*.xml
else
    sed -i 's/RTP_END_PORT/29999/g' /conf/configur*.xml
fi

if [ "$MAX_SESSIONS" ]; then
    sed -i 's/MAX_SESSIONS/'$MAX_SESSIONS'/g' /conf/configur*.xml
else
    sed -i 's/MAX_SESSIONS/1000/g' /conf/configur*.xml
fi

if [ "$SESSIONS_PER_SECOND" ]; then
    sed -i 's/SESSIONS_PER_SECOND/'$SESSIONS_PER_SECOND'/g' /conf/configur*.xml
else
    sed -i 's/SESSIONS_PER_SECOND/30/g' /conf/configur*.xml
fi

if [ "$AMQP_HOST" ]; then
    sed -i 's/AMQP_HOST/'$AMQP_HOST'/g' /conf/vars.xml
else
    sed -i 's/AMQP_HOST/172.17.0.1/g' /conf/vars.xml
fi

if [ "$GRPC_BIND" ]; then
    sed -i 's/GRPC_BIND/'$GRPC_BIND'/g' /conf/vars.xml
else
    sed -i 's/GRPC_BIND/172.17.0.1:50051/g' /conf/vars.xml
fi

if [ "$PGSQL_HOST" ]; then
    sed -i 's/PGSQL_HOST/'$PGSQL_HOST'/g' /conf/vars.xml
else
    sed -i 's/PGSQL_HOST/172.17.0.1/g' /conf/vars.xml
fi

if [ "$CDR_SERVER" ]; then
    sed -i 's/CDR_SERVER/'$CDR_SERVER'/g' /conf/vars.xml
else
    sed -i 's/CDR_SERVER/172.17.0.1:10021/g' /conf/vars.xml
fi

if [ "$CONF_SERVER" ]; then
    sed -i 's/CONF_SERVER/'$CONF_SERVER'/g' /conf/vars.xml
else
    sed -i 's/CONF_SERVER/172.17.0.1:10024/g' /conf/vars.xml
fi

if [ "$ACR_SERVER" ]; then
    sed -i 's/ACR_SERVER/'$ACR_SERVER'/g' /conf/vars.xml
else
    sed -i 's/ACR_SERVER/172.17.0.1:10030/g' /conf/vars.xml
fi

if [ "$SIP_PORT" ]; then
    sed -i 's/sofia_sip_port/'$SIP_PORT'/g' /conf/configuration.xml
else
    sed -i 's/sofia_sip_port/5062/g' /conf/configuration.xml
fi

if [ "$SIP_IP" ]; then
    sed -i 's/sofia_sip_ip/'$SIP_IP'/g' /conf/configuration.xml
else
    sed -i 's/sofia_sip_ip/$${local_ip_v4}/g' /conf/configuration.xml
fi

if [ "$SIP_EXT_IP" ]; then
    sed -i 's/sofia_ext_sip_ip/'$SIP_EXT_IP'/g' /conf/configuration.xml
else
    sed -i 's/sofia_ext_sip_ip/auto-nat/g' /conf/configuration.xml
fi

if [ "$RTP_EXT_IP" ]; then
    sed -i 's/sofia_ext_rtp_ip/'$RTP_EXT_IP'/g' /conf/configuration.xml
else
    sed -i 's/sofia_ext_rtp_ip/auto-nat/g' /conf/configuration.xml
fi

if [ "$RTP_IP" ]; then
    sed -i 's/sofia_rtp_ip/'$RTP_IP'/g' /conf/configuration.xml
else
    sed -i 's/sofia_rtp_ip/$${local_ip_v4}/g' /conf/configuration.xml
fi

if [ "$ES_IP" ]; then
    sed -i 's/event_socket_ip/'$ES_IP'/g' /conf/configuration.xml
else
    sed -i 's/event_socket_ip/172.17.0.1/g' /conf/configuration.xml
fi

if [ "$ES_PORT" ]; then
    sed -i 's/event_socket_port/'$ES_PORT'/g' /conf/configuration.xml
else
    sed -i 's/event_socket_port/8021/g' /conf/configuration.xml
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

#/iptables-reload.sh &
/sounds/get_sounds.sh &

if [ "$1" = 'freeswitch' ]; then

    if [ -d /docker-entrypoint.d ]; then
        for f in /docker-entrypoint.d/*.sh; do
            [ -f "$f" ] && . "$f"
        done
    fi

    echo 'Starting FreeSWITCH '$FS_VERSION

    exec freeswitch -u freeswitch -g freeswitch -c \
        -sounds /sounds -recordings /recordings \
        -certs /certs -conf /conf -db /db \
        -scripts /scripts -log /logs
fi

exec "$@"


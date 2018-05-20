#!/bin/bash
set -e
export PATH=$PATH:/usr/local/freeswitch/bin

echo 'Webitel '$VERSION
sed -i 's/WEBITEL_MAJOR/'$WEBITEL_MAJOR'/g' /conf/vars.xml

if [ "$FS_CONF_FILE" ]; then
    sed -i 's/FS_CONF_FILE/'$FS_CONF_FILE'/g' /conf/freeswitch.xml
else
    sed -i 's/FS_CONF_FILE/configuration_pgsql.xml/g' /conf/freeswitch.xml
fi

if [ "$RTP_START_PORT" ]; then
    sed -i 's/RTP_START_PORT/'$RTP_START_PORT'/g' /conf/configur*.xml
else
    sed -i 's/RTP_START_PORT/16384/g' /conf/configur*.xml
fi

if [ "$RTP_END_PORT" ]; then
    sed -i 's/RTP_END_PORT/'$RTP_END_PORT'/g' /conf/configur*.xml
else
    sed -i 's/RTP_END_PORT/32768/g' /conf/configur*.xml
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

if [ "$SIP_NONREG_IP" ]; then
    sed -i 's/nonreg_ip_value/'$SIP_NONREG_IP'/g' /conf/vars.xml
else
    sed -i 's/nonreg_ip_value/$${local_ip_v4}/g' /conf/vars.xml
fi

if [ "$SIP_NONREG_EXT_IP" ]; then
    sed -i 's/nonreg_ext_ip_value/'$SIP_NONREG_EXT_IP'/g' /conf/vars.xml
else
    sed -i 's/nonreg_ext_ip_value/auto-nat/g' /conf/vars.xml
fi

if [ "$SIP_EXTERNAL_IP" ]; then
    sed -i 's/external_ip_value/'$SIP_EXTERNAL_IP'/g' /conf/vars.xml
else
    sed -i 's/external_ip_value/$${local_ip_v4}/g' /conf/vars.xml
fi

if [ "$SIP_EXTERNAL_EXT_IP" ]; then
    sed -i 's/external_ext_ip_value/'$SIP_EXTERNAL_EXT_IP'/g' /conf/vars.xml
else
    sed -i 's/external_ext_ip_value/auto-nat/g' /conf/vars.xml
fi

if [ "$SIP_INTERNAL_IP" ]; then
    sed -i 's/internal_ip_value/'$SIP_INTERNAL_IP'/g' /conf/vars.xml
else
    sed -i 's/internal_ip_value/$${local_ip_v4}/g' /conf/vars.xml
fi

if [ "$SIP_INTERNAL_EXT_IP" ]; then
    sed -i 's/internal_ext_ip_value/'$SIP_INTERNAL_EXT_IP'/g' /conf/vars.xml
else
    sed -i 's/internal_ext_ip_value/$${local_ip_v4}/g' /conf/vars.xml
fi

if [ "$VERTO_IP" ]; then
    sed -i 's/verto_ip_value/'$VERTO_IP'/g' /conf/vars.xml
else
    sed -i 's/verto_ip_value/$${local_ip_v4}/g' /conf/vars.xml
fi

if [ "$VERTO_EXT_IP" ]; then
    sed -i 's/verto_ext_ip_value/'$VERTO_EXT_IP'/g' /conf/vars.xml
else
    sed -i 's/verto_ext_ip_value/$${local_ip_v4}/g' /conf/vars.xml
fi

if [ "$ES_IP" ]; then
    sed -i 's/event_socket_ip_value/'$ES_IP'/g' /conf/vars.xml
else
    sed -i 's/event_socket_ip_value/172.17.0.1/g' /conf/vars.xml
fi

if [ "$LOGLEVEL" ]; then
    sed -i 's/LOGLEVEL/'$LOGLEVEL'/g' /conf/vars.xml
else
    sed -i 's/LOGLEVEL/err/g' /conf/vars.xml
fi

if [ "$CODECS_GLOBAL_PREF" ]; then
    sed -i 's/CODECS_GLOBAL_PREF/'$CODECS_GLOBAL_PREF'/g' /conf/vars.xml
else
    sed -i 's/CODECS_GLOBAL_PREF/OPUS,G722,PCMA,PCMU,GSM,G729,ilbc,VP8,VP9,H264,H263,H263-1998/g' /conf/vars.xml
fi

if [ "$CODECS_OUTBOUND_PREF" ]; then
    sed -i 's/CODECS_OUTBOUND_PREF/'$CODECS_OUTBOUND_PREF'/g' /conf/vars.xml
else
    sed -i 's/CODECS_OUTBOUND_PREF/PCMA,PCMU,G729,GSM/g' /conf/vars.xml
fi

iptables -F INPUT

if [ -f /drop-sip-uac ]; then
    iptables -F SIPUAC
    iptables -X SIPUAC
    if ! iptables -nL SIPUAC 2>&1 >/dev/null; then
        iptables -N SIPUAC
        while read line
        do
            iptables -A INPUT -p udp -m udp --match multiport --dports 5060,5070,5080 -m string --string "$line" --algo bm --to 65535 -m comment --comment "deny $line" -j SIPUAC
            iptables -A INPUT -p tcp -m tcp --match multiport --dports 5060,5070,5080 -m string --string "$line" --algo bm --to 65535 -m comment --comment "deny $line" -j SIPUAC
        done < /drop-sip-uac
        iptables -A SIPUAC -j LOG --log-prefix "webitel-sip-uac: " --log-level 6
        iptables -A SIPUAC -j DROP
    fi
fi

if [ -f /drop-from-ip ]; then
    iptables -F DROPIP
    iptables -X DROPIP
    if ! iptables -nL DROPIP 2>&1 >/dev/null; then
        iptables -N DROPIP
        while read line
        do
            iptables -A INPUT -s $line -m comment --comment "deny $line" -j DROPIP
        done < /drop-from-ip
        iptables -A DROPIP -j LOG --log-prefix "webitel-drop-ip: " --log-level 6
        iptables -A DROPIP -j DROP
    fi
fi

test -d /logs || mkdir -p /logs /certs /sounds /db /recordings /scripts/lua

chown -R freeswitch:freeswitch /usr/local/freeswitch
chown -R freeswitch:freeswitch /{logs,tmp,db,sounds,conf,certs,scripts,recordings,images}

ln -s /dev/null /dev/raw1394

/sounds/get_sounds.sh &

if [ "$1" = 'freeswitch' ]; then

    if [ -d /docker-entrypoint.d ]; then
        for f in /docker-entrypoint.d/*.sh; do
            [ -f "$f" ] && . "$f"
        done
    fi

    echo 'Starting FreeSWITCH '$FS_VERSION

    ulimit -c unlimited
    ulimit -d unlimited
    ulimit -f unlimited
    ulimit -i unlimited
    ulimit -n 999999
    ulimit -q unlimited
    ulimit -u unlimited
    ulimit -v unlimited
    ulimit -x unlimited
    ulimit -s 240
    ulimit -l unlimited

    exec gosu freeswitch freeswitch -u freeswitch -g freeswitch -c \
        -sounds /sounds -recordings /recordings \
        -certs /certs -conf /conf -db /db \
        -scripts /scripts -log /logs
fi

exec "$@"


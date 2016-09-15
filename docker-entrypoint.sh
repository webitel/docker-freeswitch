#!/bin/bash
set -e
export PATH=$PATH:/usr/local/freeswitch/bin

echo 'Webitel '$VERSION
sed -i 's/WEBITEL_MAJOR/'$WEBITEL_MAJOR'/g' /conf/vars.xml

if [ "$RTP_START_PORT" ]; then
    sed -i 's/RTP_START_PORT/'$RTP_START_PORT'/g' /conf/freeswitch.xml
else
    sed -i 's/RTP_START_PORT/16384/g' /conf/freeswitch.xml
fi

if [ "$RTP_END_PORT" ]; then
    sed -i 's/RTP_END_PORT/'$RTP_END_PORT'/g' /conf/freeswitch.xml
else
    sed -i 's/RTP_END_PORT/32768/g' /conf/freeswitch.xml
fi

if [ "$MAX_SESSIONS" ]; then
    sed -i 's/MAX_SESSIONS/'$MAX_SESSIONS'/g' /conf/freeswitch.xml
else
    sed -i 's/MAX_SESSIONS/1000/g' /conf/freeswitch.xml
fi

if [ "$SESSIONS_PER_SECOND" ]; then
    sed -i 's/SESSIONS_PER_SECOND/'$SESSIONS_PER_SECOND'/g' /conf/freeswitch.xml
else
    sed -i 's/SESSIONS_PER_SECOND/30/g' /conf/freeswitch.xml
fi

if [ "$AMQP_HOST" ]; then
    sed -i 's/AMQP_HOST/'$AMQP_HOST'/g' /conf/vars.xml
else
    sed -i 's/AMQP_HOST/172.17.0.1/g' /conf/vars.xml
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
    sed -i 's/LOGLEVEL/all/g' /conf/vars.xml
fi

if [ "$SIPDOS" ]; then
    if ! iptables -nL SIPDOS 2>&1 >/dev/null; then
        iptables -N SIPDOS

        iptables -A INPUT -p udp -m udp --match multiport --dports 5060,5070,5080 -m string --string "sundayddr" --algo bm --to 65535 -m comment --comment "deny sundayddr" -j SIPDOS
        iptables -A INPUT -p udp -m udp --match multiport --dports 5060,5070,5080 -m string --string "sipsak" --algo bm --to 65535 -m comment --comment "deny sipsak" -j SIPDOS
        iptables -A INPUT -p udp -m udp --match multiport --dports 5060,5070,5080 -m string --string "sipvicious" --algo bm --to 65535 -m comment --comment "deny sipvicious" -j SIPDOS
        iptables -A INPUT -p udp -m udp --match multiport --dports 5060,5070,5080 -m string --string "friendly-scanner" --algo bm --to 65535 -m comment --comment "deny friendly-scanner" -j SIPDOS
        iptables -A INPUT -p udp -m udp --match multiport --dports 5060,5070,5080 -m string --string "User-Agent: sipcli" --algo bm --to 65535 -m comment --comment "deny sipcli" -j SIPDOS
        iptables -A INPUT -p udp -m udp --match multiport --dports 5060,5070,5080 -m string --string "iWar" --algo bm --to 65535 -m comment --comment "deny iWar" -j SIPDOS
        iptables -A INPUT -p udp -m udp --match multiport --dports 5060,5070,5080 -m string --string "sip-scan" --algo bm --to 65535 -m comment --comment "deny sip-scan" -j SIPDOS
        iptables -A INPUT -p udp -m udp --match multiport --dports 5060,5070,5080 -m string --string "SIP Call" --algo bm --to 65535 -m comment --comment "deny sip-scan" -j SIPDOS

        iptables -A INPUT -p tcp -m tcp --match multiport --dports 5060,5070,5080 -m string --string "sundayddr" --algo bm --to 65535 -m comment --comment "deny sundayddr" -j SIPDOS
        iptables -A INPUT -p tcp -m tcp --match multiport --dports 5060,5070,5080 -m string --string "sipsak" --algo bm --to 65535 -m comment --comment "deny sipsak" -j SIPDOS
        iptables -A INPUT -p tcp -m tcp --match multiport --dports 5060,5070,5080 -m string --string "sipvicious" --algo bm --to 65535 -m comment --comment "deny sipvicious" -j SIPDOS
        iptables -A INPUT -p tcp -m tcp --match multiport --dports 5060,5070,5080 -m string --string "friendly-scanner" --algo bm --to 65535 -m comment --comment "deny friendly-scanner" -j SIPDOS
        iptables -A INPUT -p tcp -m tcp --match multiport --dports 5060,5070,5080 -m string --string "iWar" --algo bm --to 65535 -m comment --comment "deny iWar" -j SIPDOS
        iptables -A INPUT -p tcp -m tcp --match multiport --dports 5060,5070,5080 -m string --string "sip-scan" --algo bm --to 65535 -m comment --comment "deny sip-scan" -j SIPDOS
        iptables -A INPUT -p tcp -m tcp --match multiport --dports 5060,5070,5080 -m string --string "SIP Call" --algo bm --to 65535 -m comment --comment "deny sip-scan" -j SIPDOS

        iptables -A SIPDOS -j LOG --log-prefix "firewall-sipdos: " --log-level 6
        iptables -A SIPDOS -j DROP
    fi
fi

test -d /logs || mkdir -p /logs /certs /sounds /db /recordings /scripts/lua

chown -R freeswitch:freeswitch /usr/local/freeswitch
chown -R freeswitch:freeswitch /{logs,tmp,db,sounds,conf,certs,scripts,recordings,images}

ln -s /dev/null /dev/raw1394

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

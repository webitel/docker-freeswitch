#!/bin/bash

iptables -F INPUT
if ! iptables -nL WHITEIPS 2>&1 >/dev/null; then
     iptables -N WHITEIPS
fi
iptables -A INPUT -j WHITEIPS


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

if [ -f /allow-from-ip ]; then
        while read line
        do
            iptables -A INPUT -s $line -m comment --comment "allow $line" -j ACCEPT
        done < /allow-from-ip
fi

if [ -f /drop-from-ip ]; then
    iptables -F DROPIP
    iptables -X DROPIP
    if ! iptables -nL DROPIP 2>&1 >/dev/null; then
        iptables -N DROPIP
        while read line
        do
            iptables -A INPUT -s $line -p udp -m udp --match multiport --dports 5060,5070,5080 -m comment --comment "drop SIP udp $line" -j DROPIP
            iptables -A INPUT -s $line -p tcp -m tcp --match multiport --dports 5060,5070,5080 -m comment --comment "drop SIP tcp $line" -j DROPIP
        done < /drop-from-ip
        iptables -A DROPIP -j LOG --log-prefix "webitel-drop-ip: " --log-level 6
        iptables -A DROPIP -j DROP
    fi
fi

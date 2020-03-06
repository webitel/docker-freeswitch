FROM webitel/freeswitch-base:latest

RUN apt-get update && apt-get -y build-dep freeswitch

RUN git clone https://github.com/signalwire/freeswitch.git -bv1.10 /freeswitch.git

RUN cd /freeswitch.git && git config pull.rebase true \
    && rm -rf /freeswitch.git/src/mod/event_handlers/mod_amqp \
    && git clone https://github.com/xadhoom/mod_bcg729.git /mod_bcg729 \
    && git clone https://github.com/webitel/mod_amqp.git /freeswitch.git/src/mod/event_handlers/mod_amqp \
    && git clone https://github.com/webitel/mod_amd.git /freeswitch.git/src/mod/applications/mod_amd \
    && sh bootstrap.sh -j && rm modules.conf

COPY src/modules.conf /freeswitch.git/modules.conf

RUN cd /freeswitch.git && ./configure -C --disable-zrtp --with-soundsdir=/sounds --with-recordingsdir=/recordings --with-certsdir=/certs --with-dbdir=/db --with-scriptdir=/scripts --with-logfiledir=/logs --with-storagedir=/recordings --with-cachedir=/tmp --with-imagesdir=/images && make && make install

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN cd /mod_bcg729 \
   && sed -i 's/usr\/include\/freeswitch/usr\/local\/freeswitch\/include\/freeswitch/g' Makefile \
   && sed -i 's/usr\/lib\/freeswitch\/mod/usr\/local\/freeswitch\/mod/g' Makefile \
   && head -n 6 Makefile \
   && make && make install && cd / && rm -rf /mod_bcg729

RUN cd / && rm -rf /usr/local/freeswitch/mod/*.la && rm -rf /usr/local/freeswitch/conf

FROM webitel/freeswitch-base
LABEL maintainer="Vitaly Kovalyshyn"

RUN apt-get update \
    && apt-get install -qqy --no-install-recommends imagemagick wget curl librabbitmq4 \
    && apt-get install -s freeswitch \
      | sed -n \
        -e "/^Inst freeswitch /d" \
        -e 's/^Inst \([^ ]\+\) .*$/\1/p' \
      | xargs apt-get install -y --no-install-recommends \
    && apt-get install -s freeswitch-mod-pgsql \
      | sed -n \
        -e "/^Inst freeswitch-mod-pgsql /d" \
        -e 's/^Inst \([^ ]\+\) .*$/\1/p' \
      | xargs apt-get install -y --no-install-recommends \
    && apt-get install -s freeswitch-mod-shout \
      | sed -n \
        -e "/^Inst freeswitch-mod-shout /d" \
        -e 's/^Inst \([^ ]\+\) .*$/\1/p' \
      | xargs apt-get install -y --no-install-recommends \
    && apt-get install -s freeswitch-mod-sndfile \
      | sed -n \
        -e "/^Inst freeswitch-mod-sndfile /d" \
        -e 's/^Inst \([^ ]\+\) .*$/\1/p' \
      | xargs apt-get install -y --no-install-recommends \
    && apt-get install -s freeswitch-mod-opus \
      | sed -n \
        -e "/^Inst freeswitch-mod-opus /d" \
        -e 's/^Inst \([^ ]\+\) .*$/\1/p' \
      | xargs apt-get install -y --no-install-recommends \
    && apt-get install -s freeswitch-mod-av \
      | sed -n \
        -e "/^Inst freeswitch-mod-av /d" \
        -e 's/^Inst \([^ ]\+\) .*$/\1/p' \
      | xargs apt-get install -y --no-install-recommends \
    && apt-get install -s freeswitch-mod-lua \
      | sed -n \
        -e "/^Inst freeswitch-mod-lua /d" \
        -e 's/^Inst \([^ ]\+\) .*$/\1/p' \
      | xargs apt-get install -y --no-install-recommends \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

ENV WEBITEL_MAJOR 20.02

WORKDIR /
COPY --from=0 /usr/local/freeswitch /usr/local/freeswitch

COPY conf /conf
COPY images /images
COPY scripts /scripts
COPY iptables-reload.sh /
COPY docker-entrypoint.d /docker-entrypoint.d
COPY docker-entrypoint.sh /

RUN ldconfig

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["freeswitch"]

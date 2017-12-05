FROM webitel/freeswitch-base:latest

RUN apt-get update
RUN apt-get install -y --force-yes vlc-nox librabbitmq1 librabbitmq-dev build-essential libshout3-dev libpq-dev
RUN apt-get update
RUN apt-get install -y --force-yes freeswitch-video-deps-most

RUN git clone -b v1.6 https://freeswitch.org/stash/scm/fs/freeswitch.git /freeswitch.git
RUN git clone https://github.com/xadhoom/mod_bcg729.git /mod_bcg729
RUN git clone git://git.osmocom.org/libsmpp34 /libsmpp34
RUN git clone https://github.com/webitel/mod_amd.git /mod_amd

RUN cd libsmpp34 \
    && autoreconf -i\
    && ./configure && make && make install \
    && ldconfig && cd / && rm -rf /libsmpp34

COPY mod_commands-bgapi.diff /freeswitch.git/mod_commands-bgapi.diff

RUN cd /freeswitch.git && git apply mod_commands-bgapi.diff && sh bootstrap.sh && rm modules.conf

COPY modules.conf /freeswitch.git/modules.conf

RUN cd /freeswitch.git && ./configure -C --enable-zrtp --enable-core-pgsql-support --with-soundsdir=/sounds --with-recordingsdir=/recordings --with-certsdir=/certs --with-dbdir=/db --with-scriptdir=/scripts --with-logfiledir=/logs --with-storagedir=/recordings --with-cachedir=/tmp --with-imagesdir=/images && make && make install && git checkout master && make mod_callcenter && make mod_callcenter-install && git checkout v1.6

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

#Install mod_bcg729
RUN cd /mod_bcg729 \
   && sed -i 's/usr\/include\/freeswitch/usr\/local\/freeswitch\/include\/freeswitch/g' Makefile \
   && sed -i 's/usr\/lib\/freeswitch\/mod/usr\/local\/freeswitch\/mod/g' Makefile \
   && head -n 6 Makefile \
   && make && make install && cd / && rm -rf /mod_bcg729

#Install mod_amd
RUN cd /mod_amd \
   && export PKG_CONFIG_PATH=/usr/local/freeswitch/lib/pkgconfig/ \
   && make && make install && cd / && rm -rf /mod_amd

RUN cd / && rm -rf /usr/local/freeswitch/mod/*.la && rm -rf /usr/local/freeswitch/conf && tar czvf fs.tgz /usr/local/freeswitch /usr/local/lib/libsmpp34.so.0.0.1 /usr/local/lib/libsmpp34.so.0 /usr/local/lib/libsmpp34.so



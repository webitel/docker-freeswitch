FROM webitel/freeswitch-base:latest

RUN apt-get update
RUN apt-get install -y --force-yes vlc-nox build-essential librabbitmq1 librabbitmq-dev libshout3-dev libpq-dev
RUN apt-get update
RUN apt-get install -y --force-yes freeswitch-video-deps-most
RUN curl -o /tmp/libssl1.1_1.1.0g-2_amd64.deb http://ftp.de.debian.org/debian/pool/main/o/openssl/libssl1.1_1.1.0g-2_amd64.deb \
    && curl -o /tmp/librabbitmq4_0.8.0-1+b3_amd64.deb http://ftp.de.debian.org/debian/pool/main/libr/librabbitmq/librabbitmq4_0.8.0-1+b3_amd64.deb \
    && curl -o /tmp/librabbitmq-dev_0.8.0-1+b3_amd64.deb http://ftp.de.debian.org/debian/pool/main/libr/librabbitmq/librabbitmq-dev_0.8.0-1+b3_amd64.deb \
    && dpkg -i /tmp/libssl1.1_1.1.0g-2_amd64.deb && dpkg -i /tmp/librabbitmq4_0.8.0-1+b3_amd64.deb && dpkg -i /tmp/librabbitmq-dev_0.8.0-1+b3_amd64.deb

RUN git clone https://freeswitch.org/stash/scm/fs/freeswitch.git /freeswitch.git
RUN git clone https://github.com/xadhoom/mod_bcg729.git /mod_bcg729
RUN git clone git://git.osmocom.org/libsmpp34 /libsmpp34
RUN git clone https://github.com/webitel/mod_amd.git /mod_amd
RUN git clone https://github.com/webitel/mod_cdr_rabbitmq.git /mod_cdr_rabbitmq

RUN cd libsmpp34 \
    && autoreconf -i\
    && ./configure && make && make install \
    && ldconfig && cd / && rm -rf /libsmpp34

COPY src/mod_commands-bgapi.diff /mod_commands-bgapi.diff
RUN cp /freeswitch.git/src/mod/applications/mod_callcenter/mod_callcenter.c /
RUN cd /freeswitch.git && git checkout v1.6 && mv /mod_commands-bgapi.diff ./ \
    && mv /mod_callcenter.c /freeswitch.git/src/mod/applications/mod_callcenter/mod_callcenter.c \
    && git apply mod_commands-bgapi.diff && sh bootstrap.sh && rm modules.conf

COPY src/modules.conf /freeswitch.git/modules.conf

RUN cd /freeswitch.git && ./configure -C --enable-zrtp --enable-core-pgsql-support --with-soundsdir=/sounds --with-recordingsdir=/recordings --with-certsdir=/certs --with-dbdir=/db --with-scriptdir=/scripts --with-logfiledir=/logs --with-storagedir=/recordings --with-cachedir=/tmp --with-imagesdir=/images && make && make install 

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

#Install mod_cdr_rabbitmq
RUN cd /mod_cdr_rabbitmq \
   && export PKG_CONFIG_PATH=/usr/local/freeswitch/lib/pkgconfig/ \
   && make && make install && cd / && rm -rf /mod_cdr_rabbitmq

RUN cd / && rm -rf /usr/local/freeswitch/mod/*.la && rm -rf /usr/local/freeswitch/conf

FROM webitel/freeswitch-base:latest
LABEL maintainer="Vitaly Kovalyshyn"

COPY --from=0 /tmp/libssl1.1_1.1.0g-2_amd64.deb /var/lib/apt/lists/
COPY --from=0 /tmp/librabbitmq4_0.8.0-1+b3_amd64.deb /var/lib/apt/lists/

RUN apt-get update && apt-get install -y --force-yes --no-install-recommends vlc-nox libpq-dev libshout3-dev 'libtool-bin|libtool' libodbc1 libvpx2 libyuv libopenal1 libjbig2dec0 libjbig0 libilbc1 libmpg123-0 libopencv-calib3d2.4 libopencv-contrib2.4 libopencv-gpu2.4 libopencv-ocl2.4 libopencv-stitching2.4 libopencv-superres2.4 libopencv-ts2.4 libopencv-videostab2.4 libx264-142 imagemagick libldns1 iptables tcpdump librabbitmq1 && dpkg -i /var/lib/apt/lists/libssl1.1_1.1.0g-2_amd64.deb && dpkg -i
/var/lib/apt/lists/librabbitmq4_0.8.0-1+b3_amd64.deb && apt-get clean && chmod +s /usr/sbin/tcpdump && rm -rf /var/lib/apt/lists/*

ENV FS_MAJOR 1.6
ENV FS_VERSION v1.6.19
ENV WEBITEL_REPO_BASE https://github.com/webitel

ENV WEBITEL_MAJOR
ENV VERSION

WORKDIR /
COPY --from=0 /usr/local/freeswitch /usr/local/freeswitch
COPY --from=0 /usr/local/lib/libsmpp34.so.0.0.1 /usr/local/lib/libsmpp34.so.0.0.1
COPY --from=0 /usr/local/lib/libsmpp34.so.0 /usr/local/lib/libsmpp34.so.0
COPY --from=0 /usr/local/lib/libsmpp34.so /usr/local/lib/libsmpp34.so

COPY conf /conf
COPY images /images
COPY sounds /sounds
COPY scripts /scripts
COPY docker-entrypoint.sh /

RUN ldconfig

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["freeswitch"]

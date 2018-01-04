FROM webitel/freeswitch-base:latest

RUN apt-get update && apt-get install -y --force-yes --no-install-recommends vlc-nox libpq-dev libshout3-dev 'libtool-bin|libtool' libodbc1 libvpx2 libyuv libopenal1 libjbig2dec0 libjbig0 libilbc1 libmpg123-0 libopencv-calib3d2.4 libopencv-contrib2.4 libopencv-gpu2.4 libopencv-ocl2.4 libopencv-stitching2.4 libopencv-superres2.4 libopencv-ts2.4 libopencv-videostab2.4 libx264-142 imagemagick libldns1 iptables tcpdump && dpkg -i /tmp/libssl1.1_1.1.0g-2_amd64.deb && dpkg -i
/tmp/librabbitmq4_0.8.0-1+b3_amd64.deb && apt-get clean && chmod +s /usr/sbin/tcpdump && rm -rf /tmp/*deb && rm -rf /var/lib/apt/lists/*

ENV FS_MAJOR 1.6
ENV FS_VERSION v1.6.19
ENV WEBITEL_REPO_BASE https://github.com/webitel

ENV WEBITEL_MAJOR
ENV VERSION

ADD fs.tgz /
COPY conf /conf
COPY images /images
COPY sounds /sounds
COPY scripts /scripts
COPY docker-entrypoint.sh /

RUN ldconfig

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["freeswitch"]

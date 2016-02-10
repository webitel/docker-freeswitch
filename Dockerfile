FROM webitel/freeswitch-base:latest

RUN apt-get update && apt-get install -y --force-yes --no-install-recommends vlc-nox librabbitmq1 libshout3-dev 'libtool-bin|libtool' libodbc1 libvpx2 libyuv libopenal1 libjbig2dec0 libjbig0 libilbc1 libmpg123-0 libopencv-calib3d2.4 libopencv-contrib2.4 libopencv-gpu2.4 libopencv-ocl2.4 libopencv-stitching2.4 libopencv-superres2.4 libopencv-ts2.4 libopencv-videostab2.4 libx264-142 imagemagick libldns1 iptables && apt-get clean && rm -rf /var/lib/apt/lists/*

ENV FS_MAJOR 1.6
ENV FS_VERSION v.1.6.6
ENV WEBITEL_MAJOR 3.2
ENV WEBITEL_REPO_BASE https://github.com/webitel

ENV VERSION

ADD fs.tgz /
COPY conf /conf
COPY scripts /scripts
COPY images /images
COPY docker-entrypoint.sh /

RUN ldconfig

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["freeswitch"]

#
# UniFi Video Dockerfile
# Copyright (C) 2019 James T. Lee
#

FROM ubuntu:18.04

RUN apt-get update \
 && apt-get install -y wget \
 && wget --progress=dot:mega https://dl.ubnt.com/firmwares/ufv/v3.10.1/unifi-video.Ubuntu18.04_amd64.v3.10.1.deb -O unifi-video.deb \
 && apt install -y ./unifi-video.deb \
 && rm -f unifi-video.deb \
 && apt-get remove --purge --auto-remove -y wget \
 && rm -rf /var/cache/apt/lists/*

# The unifi-video script attempts to set the max core file size which fails in
# a docker container.
RUN sed -i 's/ulimit.*//' /usr/sbin/unifi-video

COPY init /

CMD ["/init"]
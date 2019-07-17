#
# UniFi Video Dockerfile
# Copyright (C) 2019 James T. Lee
#

FROM ubuntu:18.04

RUN apt-get update \
 && apt-get install -y wget \
 && wget --progress=dot:mega https://dl.ubnt.com/firmwares/ufv/v3.10.6/unifi-video.Ubuntu18.04_amd64.v3.10.6.deb -O unifi-video.deb \
 && apt install -y ./unifi-video.deb \
 && rm -f unifi-video.deb \
 && apt-get remove --purge --auto-remove -y wget \
 && rm -rf /var/cache/apt/lists/*

# Can't run ulimit in a container
RUN sed -i 's/ulimit.*//' /usr/sbin/unifi-video

COPY init /

CMD ["/init"]

# UniFi Video for Docker

This is an opinionated take on a UniFi Video container.  Because UniFi Video is
so complex, this image takes the approach of deviating as little as possible
from a supported configuration.  To that end, this image expects to be attached
directly to your video network and use Docker volumes to avoid the need for
port and uid mapping.  The result is a Dockerfile and init script a fraction of
the size of the popular
[`pducharme/unifi-video-controller`](https://hub.docker.com/r/pducharme/unifi-video-controller/)
image.  Because this image remains so close to a supported configuration, we
can more quickly respond to software updates without having to employ
[hacks](https://github.com/pducharme/UniFi-Video-Controller/pull/127).

## Usage

Create a Docker interface to your video network.  Suppose your video network is
on VLAN 100 with subnet 192.168.100.0/24 and accessible via the host interface
eth0.  Run the following:

```
docker network create \
  --driver macvlan \
  --subnet 192.168.100.0/24 \
  --gateway 192.168.100.1 \
  --opt parent=eth0.100 \
  video
```

To ensure your UniFi Video configs and recordings persist across restarts,
prepare a Docker volume to map into the container.  Do not simply map a host
directory into the container!  Docker won't initialize it properly and UniFi
Video almost certainly won't have permission to write to it.

```
docker volume create unifi-video
```

On a typical Docker installation, you will have access to this volume from the
host at `/var/lib/docker/volumes/unifi-video/_data`.

Finally, run the container as follows:

```
docker run \
  --name unifi-video \
  --net video \
  --ip 192.168.100.1 \
  -v unifi-video:/var/lib/unifi-video \
  --cap-add SYS_ADMIN \
  --cap-add DAC_READ_SEARCH \
  --sysctl net.ipv4.ip_unprivileged_port_start=0 \
  iamjamestl/unifi-video
```

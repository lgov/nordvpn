#!/bin/sh

echo "Stop any running nord_vpn container."
docker stop nord_vpn | xargs -r docker rm

docker run -ti --cap-add=NET_ADMIN --cap-add=SYS_MODULE --device /dev/net/tun --name nord_vpn \
            --sysctl net.ipv4.conf.all.rp_filter=2 \
            -e CONNECT="United States" -e TECHNOLOGY=NordLynx -d nordvpn

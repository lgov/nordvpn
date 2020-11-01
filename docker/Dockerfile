ARG ARCH=amd64
FROM balenalib/${ARCH}-debian

# https://github.com/bubuntux/nordvpn/issues/103
ARG NORDVPN_VERSION="3.7.4"
LABEL maintainer="Lieven Govaerts"

HEALTHCHECK --interval=5m --timeout=20s --start-period=1m \
  CMD if test $( curl -m 10 -s https://api.nordvpn.com/vpn/check/full | jq -r '.["status"]' ) = "Protected" ; then exit 0; else nordvpn connect ${CONNECT} ; exit $?; fi

#CROSSRUN [ "cross-build-start" ]
RUN addgroup --system vpn && \
    apt-get update && apt-get upgrade -y && \
    apt-get install -y wget dpkg curl gnupg2 jq privoxy && \
    wget -nc https://repo.nordvpn.com/deb/nordvpn/debian/pool/main/nordvpn-release_1.0.0_all.deb && dpkg -i nordvpn-release_1.0.0_all.deb && \
    apt-get update && apt-get install -yqq nordvpn${NORDVPN_VERSION:+=$NORDVPN_VERSION} || sed -i "s/init)/$(ps --no-headers -o comm 1))/" /var/lib/dpkg/info/nordvpn.postinst && \
    update-alternatives --set iptables /usr/sbin/iptables-legacy && \
    update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy && \
    apt-get install -yqq && apt-get clean && \
    rm -rf \
        ./nordvpn* \
        /tmp/* \
        /var/lib/apt/lists/* \
        /var/tmp/*
#CROSSRUN [ "cross-build-end" ]

COPY vpn/start_vpn.sh /usr/bin

ADD privoxy/privoxy-start.sh /usr/local/bin/
ADD privoxy/startup.sh /usr/local/bin/
ADD privoxy/config /etc/privoxy/
RUN chmod +r /etc/privoxy/config && chmod +x /usr/local/bin/privoxy-start.sh


# TODO: tail the nordvpn log file.?
ARG FTL_VERSION=v5.13
ARG PIHOLE_VERSION=latest
ARG TARGET_ARCH=arm64

FROM pihole/pihole:${PIHOLE_VERSION}

RUN apt-get -y update && apt-get -y upgrade && apt-get -y install unbound unbound-anchor unbound-host dns-root-data
COPY etc/ /etc/
COPY update-ftl /usr/sbin/
RUN /usr/sbin/update-ftl ${TARGET_ARCH} ${FTL_VERSION}
RUN chown -R root:unbound /etc/unbound && chmod 640 /etc/unbound/unbound.conf.d/* /etc/unbound/zones/*
RUN unbound-anchor -v || unbound-anchor -v

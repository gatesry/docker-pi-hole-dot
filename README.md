<!-- markdownlint-configure-file { "MD004": { "style": "consistent" } } -->
<!-- markdownlint-disable MD013 -->
<!-- markdownlint-disable MD033 -->
<p align="center">
    <a href="https://pi-hole.net/">
        <img src="https://pi-hole.github.io/graphics/Vortex/Vortex_with_Wordmark.svg" width="150" height="260" alt="Pi-hole">
    </a>
    <br>
    <strong>Network-wide ad blocking via your own Linux hardware with DoT</strong>
</p>
<!-- markdownlint-enable MD033 -->

# Pi-hole DoT

## About

🐳 Pi-hole Docker image from [Pi-hole](https://pi-hole.net) with Unbound DNS over TLS (DoT) proxy for several providers

The unbound daemon runs in 0.0.0.0#5353 and Pi Hole can use it as upstream DNS.

## Workflow scheme

👀`Local Client > (Local Clear DNS) -> Pi-hole > (Host Internal Clear DNS) -> Unbound > (Internet DoT) -> DoT DNS provider`

<!-- markdownlint-disable MD033 -->
<a href="https://pi-hole.net/2018/06/09/ftldns-and-unbound-combined-for-your-own-all-around-dns-solution/#page-content" target="_blank"><img height="300" src="https://pi-hole.net/wp-content/uploads/2018/05/pihole-ftldns-unbound-600x400.png"></a>
<!-- markdownlint-enable MD033 -->

## Pi-Hole configuration

💡 You can use all the environment configuration from the base docker image [Pi-hole](https://hub.docker.com/r/pihole/pihole/)

The enhancement is the the unbound daemon configured to use DNS over TLS (DoT)

## DoT Unbound upstream configuration

👉The unbound DoT upstream can be configured by the **DOT_UPSTREAM** environment variable

* [cloudflare](https://blog.cloudflare.com/announcing-1111/)
* [google](https://developers.google.com/speed/public-dns/docs/dns-over-tls)
* [cloud9-secure](https://quad9.net)
* [cloud9-insecure](https://quad9.net)
* [adguard](https://adguard.com/en/blog/adguard-dns-announcement.html)
* [adguard-family](https://adguard.com/en/blog/adguard-dns-announcement.html)
* [adguard-nonfiltering](https://adguard.com/en/blog/adguard-dns-announcement.html)
* [cleanbrowsing-security](https://cleanbrowsing.org/dnsovertls)
* [cleanbrowsing-family](https://cleanbrowsing.org/dnsovertls)
* [cleanbrowsing-adult](https://cleanbrowsing.org/dnsovertls)
* [comcast](https://corporate.comcast.com/privacy)
* [dnssb](https://dns.sb/)
* [pumplex](https://dns.oszx.co)

⭐Additionally the **DOT_UPSTREAM** environment variable can be defined by one or several user defined upstream DNS IP

* 8.4.4.8
* 1.1.1.1,8.8.8.8
* 8.8.8.8,1.1.1.1,9.9.9.9

## Pi-hole upstream configuration

☝️To use the local unbound daemon DoT DNS upstream server, it can be defined by **DNS1=127.0.01#5353** and **DNS2=no** environment variables

## Docker Compose

💪In this example is used **DOT_UPSTREAM** and **DNS1** environment variables

```bash
pihole:
container_name: pihole
build:
    args:
        PIHOLE_VERSION: 2022.01.1
        FTL_VERSION: v5.12.1
        TARGET_ARCH: amd64
    context: src/pihole-dot
cap_add:
    - NET_ADMIN
    - SYS_NICE
dns:
    - 1.1.1.1
    - 1.0.0.1
environment:
    DNS1: '127.0.0.1#5353'
    DOT_UPSTREAM: 'cloudflare'
    TZ: 'America/New_York'
hostname: pihole
labels:
    - com.centurylinklabs.watchtower.enable=false
expose:
    - '443'
ports:
    - '53:53/tcp'
    - '53:53/udp'
volumes:
    - /opt/docker/data/pihole/dnsmasq.d:/etc/dnsmasq.d
    - /opt/docker/data/pihole/lighttpd/external.conf:/etc/lighttpd/external.conf
    - /opt/docker/data/pihole/pihole:/etc/pihole
    - /opt/docker/data/pihole/unbound.conf.d/dns-rebinding.conf:/etc/unbound/unbound.conf.d/dns-rebinding.conf
restart: unless-stopped
```

## How to build 👷

```bash
git clone https://github.com/juampe/docker-pi-hole-dot.git

<Add to docker-compose.yml>

docker-compose build
docker-compose up -d
```

## Thanks

🙏 Thanks to <https://github.com/juampe/docker-pi-hole-dot>

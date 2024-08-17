FROM alpine:3.20.2 as downloader

ARG V2RAY_VERSION=v1.3.2

RUN apk add --no-cache wget && \
    wget -O- "https://github.com/shadowsocks/v2ray-plugin/releases/download/${V2RAY_VERSION}/v2ray-plugin-linux-amd64-${V2RAY_VERSION}.tar.gz" | \
        tar zx -C /tmp/

FROM debian:12-slim

COPY conf/ /conf
COPY entrypoint.sh /entrypoint.sh
COPY --from=downloader /tmp/v2ray-plugin_linux_amd64 /tmp/v2ray-plugin_linux_amd64

ARG DEBIAN_FRONTEND=noninteractive

ENV PASSWORD="5c301bb8-6c77-41a0-a606-4ba11bbab084" \
    ENCRYPT="chacha20-ietf-poly1305"\
    V2_Path="s233" \
    QR_Path="/qr_img" \
    DOMAIN="localhost" \
    PORT="80"


RUN apt update && \
    apt install -y qrencode shadowsocks-libev nginx-light jq && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /etc/shadowsocks-libev /v2raybin /wwwroot && \
    install /tmp/v2ray-plugin_linux_amd64 /usr/bin/v2ray-plugin && \
    rm -rf /tmp/*

ENTRYPOINT /entrypoint.sh

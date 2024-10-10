# shadowsocks_v2ray_docker

Shadowsocks in docker container with v2ray plugin

## Tuning server

1. Enable tcp fast open. [See for more](https://github.com/shadowsocks/shadowsocks/wiki/TCP-Fast-Open)

## How to deploy

1. Install docker on your server
2. Run this command to get compose file:
```bash
$ wget https://raw.githubusercontent.com/OldTyT/shadowsocks_v2ray_docker/master/example/docker-compose.yml 
```
3. Setup env in file `docker-compose.yml`
4. Run docker compose:
```bash
$ docker compose up -d
```

## How to get data to connect

There are several ways available:

1. For get SS-link, send a GET request to: `http://DOMAIN/QR_Path/`
2. For get QRCode, send a GET request to: `http://DOMAIN/QR_Path/vpn.png`
3. For get `connect.json`, send a GET request to: `http://DOMAIN/QR_Path/connect.json`

## Supported environment variables:

|ENV|Default value|Whats is it|
|-|-|-|
|`PASSWORD`|`5c301bb8-6c77-41a0-a606-4ba11bbab084`|Shadowsocks password|
|`ENCRYPT`|`chacha20-ietf-poly1305`|Shadowsocks encrypt type. [See for more](https://www.v2ray.com/en/configuration/protocols/shadowsocks.html#encryption-methods).|
|`V2_Path`|`s233`|V2Ray path|
|`QR_Path`|`/qr_img`|Path to qr code|
|`DOMAIN`|`localhost`|Shadowsocks domain|
|`PORT`|`80`|Use this port for shadowsocks|

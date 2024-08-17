#!/bin/bash
apt install shadowsocks-libev
wget https://github.com/shadowsocks/v2ray-plugin/releases/download/v1.3.2/v2ray-plugin-linux-amd64-v1.3.2.tar.gz
tar -xf v2ray-plugin-linux-amd64-v1.3.2.tar.gz
rm v2ray-plugin-linux-amd64-v1.3.2.tar.gz
mv v2ray-plugin_linux_amd64 /usr/bin/v2ray-plugin
chmod +x  /usr/bin/v2ray-plugin
setcap 'cap_net_bind_service=+ep' /usr/bin/v2ray-plugin
setcap 'cap_net_bind_service=+ep' /usr/bin/ss-local
systemctl stop shadowsocks-libev.service
test -d /etc/shadowsocks-libev || mkdir -p /etc/shadowsocks-libev
test -f /etc/shadowsocks-libev/config.json || touch /etc/shadowsocks-libev/config.json
systemctl disable shadowsocks-libev.service
cat <<EOF > /etc/systemd/system/ss-local.service
[Unit]
Description=Daemon to start Shadowsocks Client
Wants=network-online.target
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/ss-local -c /etc/shadowsocks-libev/config.json

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl enable ss-local.service
systemctl restart ss-local.service
systemctl status ss-local.service

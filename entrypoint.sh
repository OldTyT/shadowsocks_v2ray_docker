#!/bin/bash

echo ${PASSWORD}

export PASSWORD_JSON="$(echo -n "$PASSWORD" | jq -Rc)"
echo ${V2_Path}
echo ${QR_Path}


bash /conf/shadowsocks-libev_config.json >  /etc/shadowsocks-libev/config.json
echo /etc/shadowsocks-libev/config.json
cat /etc/shadowsocks-libev/config.json

bash /conf/nginx_ss.conf > /etc/nginx/conf.d/ss.conf
echo /etc/nginx/conf.d/ss.conf
cat /etc/nginx/conf.d/ss.conf

if [ "$DOMAIN" = "no" ]; then
  echo "Do not generate QR-code"
else
  [ ! -d /wwwroot/${QR_Path} ] && mkdir /wwwroot/${QR_Path}
  plugin=$(echo -n "v2ray;path=/${V2_Path};host=${DOMAIN};tls" | sed -e 's/\//%2F/g' -e 's/=/%3D/g' -e 's/;/%3B/g')
  ss="ss://$(echo -n ${ENCRYPT}:${PASSWORD} | base64 -w 0)@${DOMAIN}:443?plugin=${plugin}" 
  echo "${ss}" | tr -d '\n' > /wwwroot/${QR_Path}/index.html
  echo -n "${ss}" | qrencode -s 6 -o /wwwroot/${QR_Path}/vpn.png
fi

bash /conf/connect.json > /wwwroot${QR_Path}/connect.json
echo /wwwroot${QR_Path}/connect.json
cat /wwwroot${QR_Path}/connect.json

ss-server -c /etc/shadowsocks-libev/config.json &
rm -rf /etc/nginx/sites-enabled/default
nginx -g 'daemon off;'

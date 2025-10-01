#!/bin/bash

if [ -z "$1" ]; then
    echo "Error: 参数为你的域名！"
    echo "Usage: $0 domain"
    exit 1
fi

domain=$1
username=$(whoami)
random_port=$((RANDOM % 40001 + 20000))  


echo "to /home/$username/domains/$domain/public_html/index.js"
curl -s -o "/home/$username/domains/$domain/public_html/index.js" "https://raw.githubusercontent.com/frankiejun/node-ws/main/index.js"
if [ $? -ne 0 ]; then
    echo "Error: 下载脚本 index.js 失败！"
    exit 1
fi
curl -s -o "/home/$username/cron.sh" "https://raw.githubusercontent.com/frankiejun/node-ws/main/cron.sh"
if [ $? -ne 0 ]; then
    echo "Error: 下载脚本 cron.sh 失败！"  
    exit 1
fi
chmod +x /home/$username/cron.sh


read -p "输入UUID:" uuid
if [ -z "$uuid" ]; then
    echo "Error: UUID不能为空！"
    exit 1
fi
echo "你输入的UUID: $uuid"
read -p "是否安装探针? [y/n] [n]:" input
input=${input:-n}
if [ "$input" != "n" ]; then
   read -p "输入NEZHA_SERVER(哪吒v1填写形式：nz.abc.com:8008,哪吒v0填写形式：nz.abc.com):" nezha_server
   if [ -z "$nezha_server" ]; then
    echo "Error: nezha_server不能为空！"
    exit 1
  fi
  read -p "输入NEZHA_PORT( v1面板此处按回车, v0的agent端口为{443,8443,2096,2087,2083,2053}其中之一时开启tls):" nezha_port
  nezha_port=${nezha_port:-""}
  read -p "输入NEZHA_KEY(v1的NZ_CLIENT_SECRET或v0的agent端口):" nezha_key
  if [ -z "$nezha_key" ]; then
    echo "Error: nezha_key不能为空！"
    exit 1
  fi
fi
echo "你输入的nezha_server: $nezha_server, nezha_port:$nezha_port, nezha_key:$nezha_key"



sed -i "s/NEZHA_SERVER || ''/NEZHA_SERVER || '$nezha_server'/g" "/home/$username/domains/$domain/public_html/index.js"
sed -i "s/NEZHA_PORT || ''/NEZHA_PORT || '$nezha_port'/g" "/home/$username/domains/$domain/public_html/index.js"
sed -i "s/NEZHA_KEY || ''/NEZHA_KEY || '$nezha_key'/g" "/home/$username/domains/$domain/public_html/index.js"
sed -i "s/#DOMAIN#/$domain/g" "/home/$username/domains/$domain/public_html/index.js"
sed -i "s/#PORT#;/$random_port;/g" "/home/$username/domains/$domain/public_html/index.js"
sed -i "s/#UUID#/$uuid/g" "/home/$username/domains/$domain/public_html/index.js"
sed -i "s|/HOME|/home/$username|g" "/home/$username/domains/$domain/public_html/index.js"

if [ "$input" = "y" ]; then
    sed -i "s/nezha_check=false/nezha_check=true/g" "/home/$username/cron.sh"
fi


cat > "/home/$username/domains/$domain/public_html/package.json" << EOF
{
  "name": "node-ws",
  "version": "1.0.0",
  "description": "Node.js Server",
  "main": "index.js",
  "author": "fkj",
  "repository": "https://github.com/frankiejun/node-ws",
  "license": "MIT",
  "private": false,
  "scripts": {
    "start": "node index.js"
  },
  "dependencies": {
    "ws": "^8.14.2",
    "axios": "^1.6.2",
    "mime-types": "^2.1.35"
  },
  "engines": {
    "node": ">=14"
  }
}
EOF

echo "*/1 * * * * cd /home/$username/public_html && /home/$username/cron.sh" > ./mycron
crontab ./mycron >/dev/null 2>&1
rm ./mycron

echo "安装完毕" 

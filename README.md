# 安装  

> **注意：** 记得把命令中的 `yourdomain` 改为你真实的域名

```bash 
curl -Ls https://raw.githubusercontent.com/frankiejun/node-ws/refs/heads/main/setup.sh > setup.sh && chmod +x setup.sh && ./setup.sh yourdomain
```

> webhostmost目前只能手动上传 index.js, package.json, cron.sh 然后面板启动！  

### 查看节点  
https://你的域名/你的uuid

### 关于保活  
默认自动保活哪吒和节点(webhostmost保活哪吒和一定程度保活节点)，无需你特殊处理。  



# Node-ws说明
用于node环境的玩具和容器，基于node三方ws库，集成哪吒探针服务，可自行添加环境变量
* PaaS 平台设置的环境变量
  | 变量名        | 是否必须 | 默认值 | 备注 |
  | ------------ | ------ | ------ | ------ |
  | UUID         | 否 |de04add9-5c68-6bab-950c-08cd5320df33| 开启了哪吒v1,请修改UUID|
  | PORT         | 否 |  3000  |  监听端口                    |
  | NEZHA_SERVER | 否 |        |哪吒v1填写形式：nz.abc.com:8008   哪吒v0填写形式：nz.abc.com|
  | NEZHA_PORT   | 否 |        | 哪吒v1没有此变量，v0的agent端口| 
  | NEZHA_KEY    | 否 |        | 哪吒v1的NZ_CLIENT_SECRET或v0的agent端口 |
  | NAME         | 否 |        | 节点名称前缀，例如：Glitch |
  | DOMAIN       | 是 |        | 项目分配的域名或已反代的域名，不包括https://前缀  |
  | AUTO_ACCESS  | 否 |  true  | 是否开启自动访问保活,false为关闭,true为开启,需同时填写DOMAIN变量 |


* js混肴地址：https://obfuscator.io



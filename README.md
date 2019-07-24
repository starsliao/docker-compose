# docker-compose
docker：  
redis、mango、mysql、nginx、rabbitmq、riak-kv

```
curl -fsSL get.docker.com -o get-docker.sh
sh get-docker.sh --mirror Aliyun
systemctl enable docker
systemctl start docker

yum install epel-release
yum install python2-pip
pip install docker-compose
```

- RABBITMQ记得在主机的hosts文件里增加RABBITMQ的hostname和IP，新版RABBITMQ记得增加配置：`channel_max=0`。

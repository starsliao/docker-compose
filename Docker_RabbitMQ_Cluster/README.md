# Haproxy + RabbitMQ集群 for Docker配置脚本

#### RabbitMQ Docker 集群
> 从jrlangford的[docker_rabbitmq_cluster](https://github.com/jrlangford/docker_rabbitmq_cluster)克隆而来,并做了简单修改.

#### 节点网络连接方式
1. **DNS**方式  
使用Docker建立一个私有DNS服务器,用于数据路由. 集群创建脚本:`launch_dns_mode.sh`.
2. **Docker Networking**方式  
Docker v1.9新增了 `docker network`命令,此功能可以在单个主机中创建若干私有网络,私有网络内的主机可以互通. 集群创建脚本: `launch_dockernetworking_mode.sh`.
  
#### **备注**
Docker `--link`方式无法连接到RabbitMQ节点,直接修改`hosts`文件可行但维护麻烦.
  
#### 修改
1. 添加并引用`ERLANG_COOKIE`变量,从基础镜像rabbitmq中创建相同Cookie的节点.省去单独编译一个镜像作为集群的基础镜像(jrlangford/rabbitmq). 
2. 创建RabbitMQ节点时增加`p $AMQP_PORT:5672 `,用于将amqp协议端口绑定至宿主机,否则无法访问.
3. 将DNS域名提为变量,便于更改为个人喜欢的名称.

## mod 2018-09-17 by StarsL.cn

### install rabbitmq
```
./get-docker.sh
systemctl enable docker
service docker start
chmod 755 launch_dockernetworking_mode.sh
./launch_dockernetworking_mode.sh
docker ps -a
docker exec -it rabbitmqa /bin/bash
rabbitmqctl status
rabbitmqctl cluster_status
rabbitmqctl list_vhosts
rabbitmqctl list_users
rabbitmqctl add_vhost fg
rabbitmqctl delete_user guest
rabbitmqctl add_user fg sddwfqqo
rabbitmqctl set_user_tags fg administrator
rabbitmqctl set_permissions -p / fg ".*" ".*" ".*"
rabbitmqctl set_permissions -p fg fg ".*" ".*" ".*"
rabbitmqctl -p fg set_policy ha-all "^" '{"ha-mode":"all"}'
```
### install haproxy
```
yum install gcc pcre-static pcre-devel -y
wget https://www.haproxy.org/download/1.8/src/haproxy-1.8.13.tar.gz -O ~/haproxy.tar.gz
tar xzvf ~/haproxy.tar.gz -C ~/
cd ~/haproxy-1.8.13
make TARGET=linux2628
make install
mkdir -p /etc/haproxy
mkdir -p /var/lib/haproxy
touch /var/lib/haproxy/stats
ln -s /usr/local/sbin/haproxy /usr/sbin/haproxy
cp ~/haproxy-1.8.13/examples/haproxy.init /etc/init.d/haproxy
chmod 755 /etc/init.d/haproxy
systemctl daemon-reload
useradd -r haproxy
haproxy -v
ulimit -a
systemctl enable haproxy
vi /etc/haproxy/haproxy.cfg
service haproxy restart
```

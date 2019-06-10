#!/bin/bash
#节点的联网方式增加Docker Network，此为1.9版新增的功能. 可以组建私有网络.

#设置变量,建议将ERLANG_COOKIE内容进行修改.DNS_NAME修改自己喜欢的.
NODE1=rabbitmq1
NODE2=rabbitmq2
NODE3=rabbitmq3
ERLANG_COOKIE='YZSDHWMFSMKEMBDHSGGZ'
DNS_NAME=localdomain

echo "Launching dns resolver"
docker run -d --name dns -v /var/run/docker.sock:/docker.sock phensley/docker-dns --domain $DNS_NAME
sleep 3

echo "Launching nodes"
function launch_node {
	NODE=$1
	AMQP_PORT=$2
	MGMT_PORT=$3
	docker run -d \
        	--name=$NODE \
        	-p $AMQP_PORT:5672 \
        	-p $MGMT_PORT:15672 \
        	-e RABBITMQ_NODENAME=$NODE \
			-e RABBITMQ_ERLANG_COOKIE=$ERLANG_COOKIE \
        	-h ${NODE}.$DNS_NAME \
        	--dns $(docker inspect -f '{{.NetworkSettings.IPAddress}}' dns) \
        	--dns-search $DNS_NAME \
		rabbitmq:3.5-management
}

#调用函数创建节点, 参数分别为：节点名称(也是Docker容器名称),AMQP端口,Management端口
launch_node $NODE1 5672 15672
launch_node $NODE2 5673 15673
launch_node $NODE3 5674 15674

echo "Sleeping to allow time for initialisation"
sleep 3

echo "Clustering containers"
#可根据需求将节点更改为内存节点,增加: --ram
docker exec $NODE2 bash -c \
	"rabbitmqctl stop_app && \
	rabbitmqctl join_cluster $NODE1@$NODE1 && \
	rabbitmqctl start_app" &
docker exec $NODE3 bash -c \
	"rabbitmqctl stop_app && \
	rabbitmqctl join_cluster --ram $NODE1@$NODE1 && \
	rabbitmqctl start_app" &

wait

echo "Setting cluster to High Availability"
#生产环境不建议这样设置，应该逐个设置需要进行镜像复制的队列
docker exec $NODE1 rabbitmqctl set_policy HA '^(?!amq\.).*' '{"ha-mode": "all"}'

echo
echo "Finished, cluster running!!!"
echo
echo "RabbitMQ Management Console - localhost:15672"

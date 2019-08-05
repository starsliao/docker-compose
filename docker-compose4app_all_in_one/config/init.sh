#!/bin/bash
. /data/deploy/.env
cat >/data/rabbitmq/mq_init.sh <<EOF
#!/bin/bash
if rabbitmqctl list_users|grep -q ${MQ_USER};then
  echo "exist"
else
  rabbitmqctl add_vhost ${MQ_VHOST} && \
  rabbitmqctl delete_user guest && \
  rabbitmqctl add_user ${MQ_USER} ${MQ_PASSWD} && \
  rabbitmqctl set_user_tags ${MQ_USER} administrator && \
  rabbitmqctl set_permissions -p / ${MQ_USER} ".*" ".*" ".*" && \
  rabbitmqctl set_permissions -p ${MQ_VHOST} ${MQ_USER} ".*" ".*" ".*" && \
  echo "successful"
fi
EOF
chmod 755 /data/rabbitmq/mq_init.sh
docker exec mq /var/lib/rabbitmq/mq_init.sh

cat >/data/mysql/mysql_init.sh <<EOF
#!/bin/bash
mysql -e "GRANT ALL PRIVILEGES ON *.* TO '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_USER_PASSWD}';SELECT DISTINCT CONCAT('SHOW GRANTS FOR ''',user,'''@''',host,''';') AS query FROM mysql.user;" --connect-expired-password -uroot -p${MYSQL_ROOT_PASSWD}
EOF
chmod 755 /data/mysql/mysql_init.sh
docker exec mysql /var/lib/mysql/mysql_init.sh

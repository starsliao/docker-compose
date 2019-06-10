cat >rabbitmq/mq_init.sh <<EOF
#!/bin/bash
if rabbitmqctl list_users|grep -q appuser;then
  echo "exist"
else
  rabbitmqctl add_vhost app && \
  rabbitmqctl delete_user guest && \
  rabbitmqctl add_user appuser xxxxxxxx && \
  rabbitmqctl set_user_tags appuser administrator && \
  rabbitmqctl set_permissions -p / appuser ".*" ".*" ".*" && \
  rabbitmqctl set_permissions -p app appuser ".*" ".*" ".*" && \
  echo "successful"
fi
EOF
chmod 755 rabbitmq/mq_init.sh
docker exec mq /var/lib/rabbitmq/mq_init.sh

#GRANT ALL PRIVILEGES ON *.* TO 'appuser'@'%' IDENTIFIED BY 'xxxxxxxx';

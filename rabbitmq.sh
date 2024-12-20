rabbitmq_pass=$1
if [ -z ${rabbitmq_pass} ]; then
  echo "Password Missing! Input Password"
  exit 1
fi
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash
dnf install rabbitmq-server -y
systemctl enable rabbitmq-server
systemctl restart rabbitmq-server
rabbitmqctl add_user roboshop ${rabbitmq_pass} #roboshop123
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
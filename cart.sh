source common.sh

component=cart
schema_enabled=no

func_nodejs

#dnf module disable nodejs -y
#dnf module enable nodejs:18 -y
#dnf install nodejs -y
#useradd roboshop
#mkdir /app
#curl -L -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip
#cd /app
#unzip /tmp/cart.zip
#cd /app
#npm install
#cd /home/centos/roboshop-shell-d76
#cp cart.service /etc/systemd/system/cart.service
#systemctl daemon-reload
#systemctl enable cart
#systemctl restart cart
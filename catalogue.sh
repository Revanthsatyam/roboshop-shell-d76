source common.sh

component=catalogue
schema_enabled=yes
schema_type=mongodb

func_nodejs

#dnf module disable nodejs -y
#dnf module enable nodejs:18 -y
#dnf install nodejs -y
#useradd roboshop
#mkdir /app
#curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
#cd /app
#unzip /tmp/catalogue.zip
#cd /app
#npm install
#cd /home/centos/roboshop-shell-d76
#cp catalogue.service /etc/systemd/system/catalogue.service
#systemctl daemon-reload
#systemctl enable catalogue
#systemctl restart catalogue
#cp mongo.repo /etc/yum.repos.d/mongo.repo
#dnf install mongodb-org-shell -y
#mongo --host mongodb-dev.rsdevops.in </app/schema/catalogue.js
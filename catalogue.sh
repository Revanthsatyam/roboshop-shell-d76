component=catalogue
schema_type=mongodb
source common.sh

func_nodejs





#cp catalogue.service /etc/systemd/system/catalogue.service
#cp mongo.repo /etc/yum.repos.d/mongo.repo
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
#systemctl daemon-reload
#systemctl enable catalogue
#systemctl start catalogue
#dnf install mongodb-org-shell -y
#mongo --host mongodb-dev.rsdevops.in </app/schema/catalogue.js
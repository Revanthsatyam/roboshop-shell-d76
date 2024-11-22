source common.sh

component=shipping
schema_enabled=yes
schema_type=mysql

func_java

#dnf install maven -y
#useradd roboshop
#mkdir /app
#curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip
#cd /app
#unzip /tmp/shipping.zip
#cd /app
#mvn clean package
#mv target/shipping-1.0.jar shipping.jar
#cd /home/centos/roboshop-shell-d76
#cp shipping.service /etc/systemd/system/shipping.service
#systemctl daemon-reload
#systemctl enable shipping
#systemctl restart shipping
#dnf install mysql -y
#mysql -h mysql-dev.rsdevops.in -uroot -pRoboShop@1 < /app/schema/shipping.sql
#systemctl restart shipping
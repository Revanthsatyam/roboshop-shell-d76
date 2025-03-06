log=/tmp/roboshop.log

func_nodejs() {
  echo -e "\e[36m>>>>>>>>> Copy ${component} Service <<<<<<<<<<\e[0m"
  cp catalogue.service /etc/systemd/system/catalogue.service
  cp mongo.repo /etc/yum.repos.d/mongo.repo

  echo -e "\e[36m>>>>>>>>> Install NodeJS Service <<<<<<<<<<\e[0m"
  dnf module disable nodejs -y
  dnf module enable nodejs:18 -y
  dnf install nodejs -y

  echo -e "\e[36m>>>>>>>>> Create Roboshop User <<<<<<<<<<\e[0m"
  useradd roboshop

  echo -e "\e[36m>>>>>>>>> Download ${component} Artifacts <<<<<<<<<<\e[0m"
  mkdir /app
  curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
  cd /app
  unzip /tmp/catalogue.zip
  cd /app

  echo -e "\e[36m>>>>>>>>> Install Dependencies <<<<<<<<<<\e[0m"
  npm install
}
log=/tmp/roboshop.log

func_nodejs() {
  echo -e "\e[36m>>>>>>>>> Copy ${component} Service <<<<<<<<<<\e[0m"
  cp catalogue.service /etc/systemd/system/catalogue.service &>>${log}
  cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}

  echo -e "\e[36m>>>>>>>>> Install NodeJS <<<<<<<<<<\e[0m"
  dnf module disable nodejs -y &>>${log}
  dnf module enable nodejs:18 -y &>>${log}
  dnf install nodejs -y &>>${log}

  echo -e "\e[36m>>>>>>>>> Create Roboshop User <<<<<<<<<<\e[0m"
  useradd roboshop &>>${log}
  mkdir /app &>>${log}

  echo -e "\e[36m>>>>>>>>> Download ${component} Artifacts <<<<<<<<<<\e[0m"
  curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${log}
  cd /app
  unzip /tmp/catalogue.zip &>>${log}
  cd /app

  echo -e "\e[36m>>>>>>>>> Install Dependencies <<<<<<<<<<\e[0m"
  npm install &>>${log}

  echo -e "\e[36m>>>>>>>>> Start ${component} Service <<<<<<<<<<\e[0m"
  systemctl daemon-reload &>>${log}
  systemctl enable catalogue &>>${log}
  systemctl start catalogue &>>${log}

  echo -e "\e[36m>>>>>>>>> Load Schema <<<<<<<<<<\e[0m"
  dnf install mongodb-org-shell -y &>>${log}
  mongo --host mongodb-dev.rsdevops.in </app/schema/catalogue.js &>>${log}
}
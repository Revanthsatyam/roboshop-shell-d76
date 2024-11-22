log=/tmp/roboshop.log

func_exit_status() {
  if [ $? -eq 0 ]; then
    echo -e "\e[32m>>>>>>>>> Success <<<<<<<<<<\e[0m"
  else
    echo -e "\e[31m>>>>>>>>> Failed <<<<<<<<<<\e[0m"
  fi
}

func_systemctl() {
  echo -e "\e[36m>>>>>>>>> Start ${component} Service <<<<<<<<<<\e[0m"
  systemctl daemon-reload &>>${log}
  systemctl enable ${component} &>>${log}
  systemctl restart ${component} &>>${log}
  func_exit_status
}

func_schema() {
  if [ "${schema_type}" == "mongodb" ]; then
    echo -e "\e[36m>>>>>>>>> Install Mongo Client <<<<<<<<<<\e[0m"
    dnf install mongodb-org-shell -y &>>${log}
    func_exit_status

    echo -e "\e[36m>>>>>>>>> Load Schema <<<<<<<<<<\e[0m"
    mongo --host mongodb-dev.rsdevops.in </app/schema/${component}.js &>>${log}
    func_exit_status
  fi

  if [ "${schema_type}" == "mysql" ]; then
    echo -e "\e[36m>>>>>>>>> Install MySQL Client <<<<<<<<<<\e[0m"
    dnf install mysql -y &>>${log}
    func_exit_status

    echo -e "\e[36m>>>>>>>>> Load Schema <<<<<<<<<<\e[0m"
    mysql -h mysql-dev.rsdevops.in -uroot -pRoboShop@1 < /app/schema/${component}.sql &>>${log}
    func_exit_status
  fi
}

func_appreq() {
  echo -e "\e[36m>>>>>>>>> Copy ${component} Service <<<<<<<<<<\e[0m"
  cp ${component}.service /etc/systemd/system/${component}.service
  func_exit_status

  echo -e "\e[36m>>>>>>>>> Create User <<<<<<<<<<\e[0m"
  id roboshop &>>${log}
  if [ $? -ne 0 ]; then
    useradd roboshop &>>${log}
  fi
  func_exit_status

  echo -e "\e[36m>>>>>>>>> Cleanup Existing Application Content <<<<<<<<<<\e[0m"
  rm -rf /app &>>${log}
  func_exit_status

  echo -e "\e[36m>>>>>>>>> Download Application Content <<<<<<<<<<\e[0m"
  mkdir /app &>>${log}
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log}
  func_exit_status

  echo -e "\e[36m>>>>>>>>> Extract Application Content <<<<<<<<<<\e[0m"
  cd /app
  unzip /tmp/${component}.zip &>>${log}
  func_exit_status
}

func_nodejs() {
  echo -e "\e[36m>>>>>>>>> Install NodeJS <<<<<<<<<<\e[0m"
  dnf module disable nodejs -y &>>${log}
  dnf module enable nodejs:18 -y &>>${log}
  dnf install nodejs -y &>>${log}
  func_exit_status

  if [ "${schema_enabled}" == "yes" ]; then
    echo -e "\e[36m>>>>>>>>> Copy Mongo Repo <<<<<<<<<<\e[0m"
    cp mongo.repo /etc/yum.repos.d/mongo.repo
    func_exit_status
  fi

  func_appreq

  echo -e "\e[36m>>>>>>>>> Download Dependencies <<<<<<<<<<\e[0m"
  npm install &>>${log}
  func_exit_status

  func_systemctl

  if [ "${schema_enabled}" == "yes" ]; then
    func_schema
  fi
}

func_java() {
  echo -e "\e[36m>>>>>>>>> Install Maven <<<<<<<<<<\e[0m"
  dnf install maven -y &>>${log}
  func_exit_status

  func_appreq

  echo -e "\e[36m>>>>>>>>> Build ${component} service <<<<<<<<<<\e[0m"
  mvn clean package &>>${log}
  mv target/${component}-1.0.jar ${component}.jar &>>${log}
  func_exit_status

  func_systemctl

  if [ "${schema_enabled}" == "yes" ]; then
    func_schema
  fi
}

func_python() {
  echo -e "\e[36m>>>>>>>>> Install Python <<<<<<<<<<\e[0m"
  dnf install python36 gcc python3-devel -y &>>${log}
  func_exit_status

  func_appreq

  echo -e "\e[36m>>>>>>>>> Build ${component} service <<<<<<<<<<\e[0m"
  pip3.6 install -r requirements.txtr &>>${log}
  func_exit_status

  func_systemctl
}

func_golang() {
  echo -e "\e[36m>>>>>>>>> Install Golang <<<<<<<<<<\e[0m"
  dnf install golang -y &>>${log}

  func_appreq

  echo -e "\e[36m>>>>>>>>> Download Dependencies <<<<<<<<<<\e[0m"
  cd /app
  go mod init dispatch &>>${log}
  go get &>>${log}
  go build &>>${log}

  func_systemctl
}
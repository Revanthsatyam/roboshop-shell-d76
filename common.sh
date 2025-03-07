log=/tmp/roboshop.log

func_exit_stat() {
  if [ "$?" == 0 ]; then
    echo -e "\e[32mSUCCESS\e[0m"
  else
    echo -e "\e[31mFAILED\e[0m"
  fi
}

func_sysd() {
  echo -e "\e[36m>>>>>>>>> Start ${component} Service <<<<<<<<<<\e[0m"
  systemctl daemon-reload &>>${log}
  systemctl enable ${component} &>>${log}
  systemctl restart ${component} &>>${log}
  func_exit_stat
}

func_schema() {
  if [ "${schema_type}" == mongodb ]; then
    echo -e "\e[36m>>>>>>>>> Install Mongo Client <<<<<<<<<<\e[0m"
    dnf install mongodb-org-shell -y &>>${log}
    func_exit_stat

    echo -e "\e[36m>>>>>>>>> Load Schema <<<<<<<<<<\e[0m"
    mongo --host mongodb-dev.rsdevops.in </app/schema/${component}.js &>>${log}
    func_exit_stat
  fi

  if [ "${schema_type}" == mysql ]; then
    echo -e "\e[36m>>>>>>>>> Install MySQL Client <<<<<<<<<<\e[0m"
    dnf install mysql -y &>>${log}
    func_exit_stat

    echo -e "\e[36m>>>>>>>>> Load Schema <<<<<<<<<<\e[0m"
    mysql -h mysql-dev.rsdevops.in -uroot -pRoboShop@1 < /app/schema/${component}.sql &>>${log}
    func_exit_stat
  fi
}

func_appreq() {
  echo -e "\e[36m>>>>>>>>> Copy ${component} Service <<<<<<<<<<\e[0m"
  cp ${component}.service /etc/systemd/system/${component}.service &>>${log}

  if [ "${component}" == catalogue ]; then
    cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}
  fi
  func_exit_stat

  echo -e "\e[36m>>>>>>>>> Create Roboshop User <<<<<<<<<<\e[0m"
  id roboshop &>>${log}
  if [ "$?" != 0 ]; then
    useradd roboshop &>>${log}
  fi
  func_exit_stat

  echo -e "\e[36m>>>>>>>>> Cleanup Existing Application Content <<<<<<<<<<\e[0m"
  rm -rf /app &>>${log}
  func_exit_stat

  echo -e "\e[36m>>>>>>>>>>>>  Create Application Directory  <<<<<<<<<<<<\e[0m"
  mkdir /app &>>${log}
  func_exit_status

  echo -e "\e[36m>>>>>>>>> Download ${component} Artifacts <<<<<<<<<<\e[0m"
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log}
  cd /app
  unzip /tmp/${component}.zip &>>${log}
  func_exit_stat
}

func_nodejs() {
  echo -e "\e[36m>>>>>>>>> Install NodeJS <<<<<<<<<<\e[0m"
  dnf module disable nodejs -y &>>${log}
  dnf module enable nodejs:18 -y &>>${log}
  dnf install nodejs -y &>>${log}
  func_exit_stat

  func_appreq

  echo -e "\e[36m>>>>>>>>> Install Dependencies <<<<<<<<<<\e[0m"
  npm install &>>${log}
  func_exit_stat

  func_schema

  func_sysd
}

func_java() {
  echo -e "\e[36m>>>>>>>>> Install Java <<<<<<<<<<\e[0m"
  dnf install maven -y &>>${log}
  func_exit_stat

  func_appreq

  echo -e "\e[36m>>>>>>>>> Install Dependencies <<<<<<<<<<\e[0m"
  mvn clean package &>>${log}
  mv target/shipping-1.0.jar shipping.jar &>>${log}
  func_exit_stat

  func_schema

  func_sysd
}

func_python() {
  echo -e "\e[36m>>>>>>>>> Install Python <<<<<<<<<<\e[0m"
  dnf install python36 gcc python3-devel -y &>>${log}
  func_exit_stat

  func_appreq

  echo -e "\e[36m>>>>>>>>> Install Dependencies <<<<<<<<<<\e[0m"
  pip3.6 install -r requirements.txt &>>${log}
  func_exit_stat

  func_sysd
}
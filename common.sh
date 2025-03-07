log=/tmp/roboshop.log

func_exit_stat() {
  if [ "$?" == 0 ]; then
    echo -e "\e[32mSUCCESS\e[0m"
  else
    echo -e "\e[31mFAILED\e[0m"
  fi
}

func_nodejs() {
  echo -e "\e[36m>>>>>>>>> Copy ${component} Service <<<<<<<<<<\e[0m"
  cp ${component}.service /etc/systemd/system/${component}.service &>>${log}

  if [ "${component}" == catalogue ]; then
    cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}
  fi
  func_exit_stat

  echo -e "\e[36m>>>>>>>>> Install NodeJS <<<<<<<<<<\e[0m"
  dnf module disable nodejs -y &>>${log}
  dnf module enable nodejs:18 -y &>>${log}
  dnf install nodejs -y &>>${log}
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
  curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log}
  cd /app
  unzip /tmp/${component}.zip &>>${log}
  func_exit_stat

  echo -e "\e[36m>>>>>>>>> Install Dependencies <<<<<<<<<<\e[0m"
  npm install &>>${log}
  func_exit_stat

  echo -e "\e[36m>>>>>>>>> Start ${component} Service <<<<<<<<<<\e[0m"
  systemctl daemon-reload &>>${log}
  systemctl enable ${component} &>>${log}
  systemctl start ${component} &>>${log}
  func_exit_stat

  if [ "${component}" == catalogue ]; then
    echo -e "\e[36m>>>>>>>>> Install Mongo Client <<<<<<<<<<\e[0m"
    dnf install mongodb-org-shell -y &>>${log}
    func_exit_stat

    echo -e "\e[36m>>>>>>>>> Load Schema <<<<<<<<<<\e[0m"
    mongo --host mongodb-dev.rsdevops.in </app/schema/catalogue.js &>>${log}
    func_exit_stat
  fi
}
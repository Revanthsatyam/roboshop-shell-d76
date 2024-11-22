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
    echo -e "\e[36m>>>>>>>>> Load Schema <<<<<<<<<<\e[0m"
    dnf install mongodb-org-shell -y &>>${log}
    mongo --host mongodb-dev.rsdevops.in </app/schema/${component}.js &>>${log}
    func_exit_status
  fi
}

func_nodejs() {
  echo -e "\e[36m>>>>>>>>> Install NodeJS <<<<<<<<<<\e[0m"
  dnf module disable nodejs -y &>>${log}
  dnf module enable nodejs:18 -y &>>${log}
  dnf install nodejs -y &>>${log}
  func_exit_status

  echo -e "\e[36m>>>>>>>>> Copy ${component} Service <<<<<<<<<<\e[0m"
  cp ${component}.service /etc/systemd/system/${component}.service
  func_exit_status

  if [ "${schema_enabled}" == "yes" ]; then
    echo -e "\e[36m>>>>>>>>> Copy Mongo Repo <<<<<<<<<<\e[0m"
    cp mongo.repo /etc/yum.repos.d/mongo.repo
    func_exit_status
  fi

  echo -e "\e[36m>>>>>>>>> Create User <<<<<<<<<<\e[0m"
  useradd roboshop &>>${log}
  func_exit_status

  echo -e "\e[36m>>>>>>>>> Download Application Content <<<<<<<<<<\e[0m"
  mkdir /app &>>${log}
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log}
  func_exit_status

  echo -e "\e[36m>>>>>>>>> Extract Application Content <<<<<<<<<<\e[0m"
  cd /app
  unzip /tmp/${component}.zip &>>${log}
  func_exit_status

  echo -e "\e[36m>>>>>>>>> Download Dependencies <<<<<<<<<<\e[0m"
  npm install &>>${log}
  func_exit_status

  func_systemctl

  if [ "${schema_enabled}" == "yes" ]; then
    func_schema
  fi
}
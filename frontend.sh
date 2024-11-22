source common.sh

echo -e "\e[36m>>>>>>>>> Installing Nginx Service <<<<<<<<<<\e[0m"
dnf install nginx -y &>>${log}
func_exit_status

echo -e "\e[36m>>>>>>>>> Copy Roboshop Config <<<<<<<<<<\e[0m"
cp nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${log}
func_exit_status

echo -e "\e[36m>>>>>>>>> Removing Default Nginx Content <<<<<<<<<<\e[0m"
rm -rf /usr/share/nginx/html/* &>>${log}
func_exit_status

echo -e "\e[36m>>>>>>>>> Downloading And Unzip Frontend Content <<<<<<<<<<\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log}
cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>>${log}
func_exit_status

echo -e "\e[36m>>>>>>>>> Start Nginx Service <<<<<<<<<<\e[0m"
systemctl enable nginx &>>${log}
systemctl restart nginx &>>${log}
func_exit_status
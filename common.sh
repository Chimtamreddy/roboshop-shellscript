func_nodejs() {
  log=/tmp/roboshop.log
  echo -e "\e[36m>>>>>>>>>>>>>Create user Service <<<<<<<<<<<<<<<<<\e[0m"
  cp user.service /etc/systemd/system/user.service &>>${log}
  echo -e "\e[36m>>>>>>>>>>>>>Create mongo Reo <<<<<<<<<<<<<<<<<\e[0m"
  cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}
  echo -e "\e[36m>>>>>>>>>>>>>Install Nodejs Disable and Enable Service <<<<<<<<<<<<<<<<<\e[0m"
  dnf module disable nodejs -y &>>${log}
  dnf module enable nodejs:18 -y &>>${log}
  echo -e "\e[36m>>>>>>>>>>>>>Create Nodejs Service <<<<<<<<<<<<<<<<<\e[0m"
  dnf install nodejs -y &>>${log}
  echo -e "\e[36m>>>>>>>>>>>>>Create Application Service <<<<<<<<<<<<<<<<<\e[0m"
  useradd roboshop &>>${log}
  echo -e "\e[36m>>>>>>>>>>>>>Remove Exiting Content <<<<<<<<<<<<<<<<<\e[0m"
  rm -rf /app &>>${log}
  echo -e "\e[36m>>>>>>>>>>>>>Create Application Service <<<<<<<<<<<<<<<<<\e[0m"
  mkdir /app &>>${log}
  echo -e "\e[36m>>>>>>>>>>>>>Download Application Content <<<<<<<<<<<<<<<<<\e[0m"
  curl -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip &>>${log}
  cd /app
  echo -e "\e[36m>>>>>>>>>>>>>Extract Content <<<<<<<<<<<<<<<<<\e[0m"
  unzip /tmp/user.zip &>>${log}
  cd /app
  echo -e "\e[36m>>>>>>>>>>>>>Install NPM Service <<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  npm install &>>${log}
  echo -e "\e[36m>>>>>>>>>>>>>Create Mongodb Service <<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  dnf install mongodb-org-shell -y &>>${log}
  echo -e "\e[36m>>>>>>>>>>>>>Schema <<<<<<<<<<<<<<<<<\e[0m"
  mongo --host mongodb.kr7348202.online </app/schema/user.js &>>${log}
  echo -e "\e[36m>>>>>>>>>>>>>Start user Service <<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  systemctl daemon-reload &>>${log}
  systemctl enable user &>>${log}
  systemctl restart user &>>${log}
}
nodejs() {
  log=/tmp/roboshop.log
  echo -e "\e[36m>>>>>>>>>>>>>>>>> Create ${component} Service <<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  cp ${component}.service /etc/systemd/system/${component}.service &>>${log}
  echo -e "\e[36m>>>>>>>>>>>>>>>>> Create Mongodb Repo <<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}
  echo -e "\e[36m>>>>>>>>>>>>>>>>> Disable Nodejs <<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  dnf module disable nodejs -y &>>${log}
  echo -e "\e[36m>>>>>>>>>>>>>>>>> Enable Nodejs <<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  dnf module enable nodejs:18 -y &>>${log}
  echo -e "\e[36m>>>>>>>>>>>>>>>>> Install Nodejs <<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  dnf install nodejs -y &>>${log}
  echo -e "\e[36m>>>>>>>>>>>>>>>>> Create Application  <<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  add roboshop &>>${log}
  echo -e "\e[36m>>>>>>>>>>>>>>>>> Remove Exiting Content <<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  rm -rf /app &>>${log}
  echo -e "\e[36m>>>>>>>>>>>>>>>>> Create Application Directory <<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  mkdir /app &>>${log}
  echo -e "\e[36m>>>>>>>>>>>>>>>>> Download Application Content <<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log}
  echo -e "\e[36m>>>>>>>>>>>>>>>>> Extract Application Content <<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  cd /app
  unzip /tmp/${component}.zip &>>${log}
  cd /app
  echo -e "\e[36m>>>>>>>>>>>>>>>>> Download Nodejs Dependencies <<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  npm install &>>${log}
  echo -e "\e[36m>>>>>>>>>>>>>>>>> Install Mongodb Client <<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  dnf install mongodb-org-shell -y &>>${log}
  echo -e "\e[36m>>>>>>>>>>>>>>>>> Load ${component} Schema <<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  mongo --host mongodb.kr7348202.online </app/schema/${component}.js &>>${log}
  echo -e "\e[36m>>>>>>>>>>>>>>>>> Start ${component} Service <<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  systemctl daemon-reload &>>${log}
  systemctl enable ${component} &>>${log}
  systemctl restart ${component} &>>${log}
}
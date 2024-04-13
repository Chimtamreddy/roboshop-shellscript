log=/tmp/roboshop.log

func_apppreq() {
  echo -e "\e[36m>>>>>>>>>>>>>Start ${component} Service <<<<<<<<<<<<<<<<<\e[0m"
    cp ${component}.service /etc/systemd/system/${component}.service &>>${log}
  echo -e "\e[36m>>>>>>>>>>>>>Create Application Service <<<<<<<<<<<<<<<<<\e[0m"
  useradd roboshop &>>${log}
  echo -e "\e[36m>>>>>>>>>>>>>Remove Exiting Content <<<<<<<<<<<<<<<<<\e[0m"
  rm -rf /app &>>${log}
  echo -e "\e[36m>>>>>>>>>>>>>Create Application Service <<<<<<<<<<<<<<<<<\e[0m"
  mkdir /app &>>${log}
  echo -e "\e[36m>>>>>>>>>>>>>Download Application Content <<<<<<<<<<<<<<<<<\e[0m"
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log}
  cd /app
  echo -e "\e[36m>>>>>>>>>>>>>Extract Content <<<<<<<<<<<<<<<<<\e[0m"
  unzip /tmp/${component}.zip &>>${log}
  cd /app
}

func_systmed() {
  echo -e "\e[36m>>>>>>>>>>>>>Start ${component} Service <<<<<<<<<<<<<<<<<\e[0m"
  systemctl daemon-reload &>>${log}
  systemctl enable ${component} &>>${log}
  systemctl restart ${component} &>>${log}
}
func_schema_setup() {
  if [ "${schema_type}" == "mongodb" ]; then
      echo -e "\e[36m>>>>>>>>>>>>>Create Mongodb Service <<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
      dnf install mongodb-org-shell -y &>>${log}
      echo -e "\e[36m>>>>>>>>>>>>>Schema <<<<<<<<<<<<<<<<<\e[0m"
      mongo --host mongodb.kr7348202.online </app/schema/${component}.js &>>${log}

  fi

  if [ "${schema_type}" == "mysql" ]; then
      echo -e "\e[36m>>>>>>>>>>>>>Create Mysql Service <<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
      dnf install mysql -y &>>${log}
      echo -e "\e[36m>>>>>>>>>>>>>Schema <<<<<<<<<<<<<<<<<\e[0m"
      mysql -h mysql.kr7348202.online -uroot -pRoboShop@1 < /app/schema/${component}.sql &>>${log}

  fi

}
func_nodejs() {
  

  echo -e "\e[36m>>>>>>>>>>>>>Create mongo Reo <<<<<<<<<<<<<<<<<\e[0m"
  cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}
  echo -e "\e[36m>>>>>>>>>>>>>Install Nodejs Disable and Enable Service <<<<<<<<<<<<<<<<<\e[0m"
  dnf module disable nodejs -y &>>${log}
  dnf module enable nodejs:18 -y &>>${log}
  echo -e "\e[36m>>>>>>>>>>>>>Create Nodejs Service <<<<<<<<<<<<<<<<<\e[0m"
  dnf install nodejs -y &>>${log}
  func_apppreq
  echo -e "\e[36m>>>>>>>>>>>>>Install NPM Service <<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  npm install &>>${log}
  func_schema_setup
  func_systmed
}

func_java() {

  echo -e "\e[36m>>>>>>>>>>>>>Start ${component} Service <<<<<<<<<<<<<<<<<\e[0m"
  dnf install maven -y &>>${log}
  func_apppreq
  mvn clean package &>>${log}
  mv target/${component}-1.0.jar ${component}.jar &>>${log}
  
  func_schema_setup
  func_systmed

}

func_python() {
  echo -e "\e[36m>>>>>>>>>>>>>Build ${component} Service <<<<<<<<<<<<<<<<<\e[0m"
  dnf install python36 gcc python3-devel -y &>>${log}
  func_apppreq
  echo -e "\e[36m>>>>>>>>>>>>>Build ${component} Service<<<<<<<<<<<<<<<<<\e[0m"
  pip3.6 install -r requirements.txt &>>${log}
  func_systmed

}
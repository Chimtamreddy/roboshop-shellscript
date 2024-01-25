log=/tmp/roboshop.log
func_apppreq() {
  echo -e "\e[36m>>>>>>>>>>>>>>>>> Create ${component} Service <<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  cp ${component}.service /etc/systemd/system/${component}.service &>>${log}
  echo $?
  echo -e "\e[36m>>>>>>>>>>>>>>>>> Create Application User <<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  useradd roboshop &>>${log}
  echo $?
  echo -e "\e[36m>>>>>>>>>>>>>>>>> Cleanup  Exiting Application Content <<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  rm -rf /app &>>${log}
  echo $?
  echo -e "\e[36m>>>>>>>>>>>>>>>>> Create Application Directory <<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  mkdir /app &>>${log}
  echo $?
  echo -e "\e[36m>>>>>>>>>>>>>>>>> Download Application Content <<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log}
  echo $?
  echo -e "\e[36m>>>>>>>>>>>>>>>>> Extract Application Content <<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  cd /app
  unzip /tmp/${component}.zip &>>${log}
  echo $?

}
func_systemd() {
  echo -e "\e[36m>>>>>>>>>>>>>>>>> Start ${component} Service <<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  systemctl daemon-reload &>>${log}
  echo $?
  systemctl enable ${component} &>>${log}
  echo $?
  systemctl restart ${component} &>>${log}
  echo $?
}

func_schema_setup() {
  if [ "${schema_type}" == "mongodb" ]; then
    echo -e "\e[36m>>>>>>>>>>>>>>>>> Install Mongodb Client <<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
    dnf install mongodb-org-shell -y &>>${log}
    echo $?
    echo -e "\e[36m>>>>>>>>>>>>>>>>> Load ${component} Schema <<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
    mongo --host mongodb.kr7348202.online </app/schema/${component}.js &>>${log}
    echo $?
  fi

  if [ "${schema_type}" == "mysql" ]; then
    echo -e "\e[36m>>>>>>>>>>>>>>>>> Install Mysql Client <<<<<<<<<<<<<<\e[0m"
    dnf install mysql -y &>>${log}
    echo $?
    echo -e "\e[36m>>>>>>>>>>>>>>>>> Load Schema <<<<<<<<<<<<<<\e[0m"
    mysql -h mysql.kr7348202.online -uroot -pRoboShop@1 < /app/schema/${component}.sql &>>${log}
    echo $?
  fi
}
func_nodejs() {


  echo -e "\e[36m>>>>>>>>>>>>>>>>> Create Mongodb Repo <<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}
  echo $?
  echo -e "\e[36m>>>>>>>>>>>>>>>>> Disable Nodejs <<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  dnf module disable nodejs -y &>>${log}
  echo $?
  echo -e "\e[36m>>>>>>>>>>>>>>>>> Enable Nodejs <<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  dnf module enable nodejs:18 -y &>>${log}
  echo $?
  echo -e "\e[36m>>>>>>>>>>>>>>>>> Install Nodejs <<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  dnf install nodejs -y &>>${log}
  echo $?
  
  func_apppreq
  
  echo -e "\e[36m>>>>>>>>>>>>>>>>> Download Nodejs Dependencies <<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  npm install &>>${log}
  echo $?

  func_schema_setup

  func_systemd
}

func_java() {


  echo -e "\e[36m>>>>>>>>>>>>>>>>> Install maven  <<<<<<<<<<<<<<\e[0m"
  dnf install maven -y &>>${log}
  echo $?
  
  func_apppreq

  echo -e "\e[36m>>>>>>>>>>>>>>>>> Build ${component} Service <<<<<<<<<<<<<<\e[0m"
  mvn clean package &>>${log}
  echo $?
  mv target/${component}-1.0.jar ${component}.jar &>>${log}
  echo $?

  func_schema_setup

  func_systemd
  
}

func_python() {

  echo -e "\e[36m>>>>>>>>>>>>>>>>> Build ${component} Service <<<<<<<<<<<<<<\e[0m"
  dnf install python36 gcc python3-devel -y &>>${log}
  echo $?

  func_apppreq

  echo -e "\e[36m>>>>>>>>>>>>>>>>> Build ${component} Service <<<<<<<<<<<<<<\e[0m"
  pip3.6 install -r requirements.txt &>>${log}
  echo $?

  func_systemd
}
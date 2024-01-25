log=/tmp/roboshop.log
echo -e "\e[36m>>>>>>>>>>>>>>>>> Create Catalogue Service <<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
cp catalogue.service /etc/systemd/system/catalogue.service &>>/tmp/roboshop.log
echo -e "\e[36m>>>>>>>>>>>>>>>>> Create Mongodb Repo <<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
cp mongo.repo /etc/yum.repos.d/mongo.repo &>>/tmp/roboshop.log
echo -e "\e[36m>>>>>>>>>>>>>>>>> Disable Nodejs <<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
dnf module disable nodejs -y &>>/tmp/roboshop.log
echo -e "\e[36m>>>>>>>>>>>>>>>>> Enable Nodejs <<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
dnf module enable nodejs:18 -y &>>/tmp/roboshop.log
echo -e "\e[36m>>>>>>>>>>>>>>>>> Install Nodejs <<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
dnf install nodejs -y &>>/tmp/roboshop.log
echo -e "\e[36m>>>>>>>>>>>>>>>>> Create Application User <<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
useradd roboshop &>>/tmp/roboshop.log
echo -e "\e[36m>>>>>>>>>>>>>>>>> Remove Exiting Content <<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
rm -rf /app &>>/tmp/roboshop.log
echo -e "\e[36m>>>>>>>>>>>>>>>>> Create Application Directory <<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
mkdir /app &>>/tmp/roboshop.log
echo -e "\e[36m>>>>>>>>>>>>>>>>> Download Application Content <<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>/tmp/roboshop.log
echo -e "\e[36m>>>>>>>>>>>>>>>>> Extract Application Content <<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
cd /app
unzip /tmp/catalogue.zip &>>/tmp/roboshop.log
cd /app
echo -e "\e[36m>>>>>>>>>>>>>>>>> Download Nodejs Dependencies <<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
npm install &>>/tmp/roboshop.log
echo -e "\e[36m>>>>>>>>>>>>>>>>> Install Mongodb Client <<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
dnf install mongodb-org-shell -y &>>/tmp/roboshop.log
echo -e "\e[36m>>>>>>>>>>>>>>>>> Load Catalogue Schema <<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
mongo --host mongodb.kr7348202.online </app/schema/catalogue.js &>>/tmp/roboshop.log
echo -e "\e[36m>>>>>>>>>>>>>>>>> Start Catalogue Service <<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
systemctl daemon-reload &>>/tmp/roboshop.log
systemctl enable catalogue &>>/tmp/roboshop.log
systemctl restart catalogue &>>/tmp/roboshop.log

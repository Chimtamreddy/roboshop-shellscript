echo -e "\e[36m>>>>>>>>>>>>>Create Catalogue Service <<<<<<<<<<<<<<<<<\e[0m"
cp catalogue.service /etc/systemd/system/catalogue.service >/tmp/roboshop.log
echo -e "\e[36m>>>>>>>>>>>>>Create mongo Reo <<<<<<<<<<<<<<<<<\e[0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo >/tmp/roboshop.log
echo -e "\e[36m>>>>>>>>>>>>>Install Nodejs Disable and Enable Service <<<<<<<<<<<<<<<<<\e[0m"
dnf module disable nodejs -y >/tmp/roboshop.log
dnf module enable nodejs:18 -y >/tmp/roboshop.log
echo -e "\e[36m>>>>>>>>>>>>>Create Nodejs Service <<<<<<<<<<<<<<<<<\e[0m"
dnf install nodejs -y >/tmp/roboshop.log
echo -e "\e[36m>>>>>>>>>>>>>Create Application Service <<<<<<<<<<<<<<<<<\e[0m"
useradd roboshop >/tmp/roboshop.log
echo -e "\e[36m>>>>>>>>>>>>>Remove Exiting Content <<<<<<<<<<<<<<<<<\e[0m"
rm -rf /app >/tmp/roboshop.log
echo -e "\e[36m>>>>>>>>>>>>>Create Application Service <<<<<<<<<<<<<<<<<\e[0m"
mkdir /app >/tmp/roboshop.log
echo -e "\e[36m>>>>>>>>>>>>>Download Application Content <<<<<<<<<<<<<<<<<\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip >/tmp/roboshop.log
cd /app
echo -e "\e[36m>>>>>>>>>>>>>Extract Content <<<<<<<<<<<<<<<<<\e[0m"
unzip /tmp/catalogue.zip >/tmp/roboshop.log
cd /app
echo -e "\e[36m>>>>>>>>>>>>>Install NPM Service <<<<<<<<<<<<<<<<<\e[0m"
npm install >/tmp/roboshop.log
echo -e "\e[36m>>>>>>>>>>>>>Create Mongodb Service <<<<<<<<<<<<<<<<<\e[0m"
dnf install mongodb-org-shell -y >/tmp/roboshop.log
echo -e "\e[36m>>>>>>>>>>>>>Schema <<<<<<<<<<<<<<<<<\e[0m"
mongo --host mongodb.kr7348202.online </app/schema/catalogue.js >/tmp/roboshop.log
echo -e "\e[36m>>>>>>>>>>>>>Start Catalogue Service <<<<<<<<<<<<<<<<<\e[0m"
systemctl daemon-reload >/tmp/roboshop.log
systemctl enable catalogue >/tmp/roboshop.log
systemctl restart catalogue >/tmp/roboshop.log
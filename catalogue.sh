echo -e "\e[36m>>>>>>>>>>>>>Create Catalogue Service <<<<<<<<<<<<<<<<<\e[0m"
cp catalogue.service /etc/systemd/system/catalogue.service
echo -e "\e[36m>>>>>>>>>>>>>Create mongo Reo <<<<<<<<<<<<<<<<<\e[0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo
echo -e "\e[36m>>>>>>>>>>>>>Install Nodejs Disable and Enable Service <<<<<<<<<<<<<<<<<\e[0m"
dnf module disable nodejs -y
dnf module enable nodejs:18 -y
echo -e "\e[36m>>>>>>>>>>>>>Create Nodejs Service <<<<<<<<<<<<<<<<<\e[0m"
dnf install nodejs -y
echo -e "\e[36m>>>>>>>>>>>>>Create Application Service <<<<<<<<<<<<<<<<<\e[0m"
useradd roboshop
echo -e "\e[36m>>>>>>>>>>>>>Remove Exiting Content <<<<<<<<<<<<<<<<<\e[0m"
rm -rf /app
echo -e "\e[36m>>>>>>>>>>>>>Create Application Service <<<<<<<<<<<<<<<<<\e[0m"
mkdir /app
echo -e "\e[36m>>>>>>>>>>>>>Download Application Content <<<<<<<<<<<<<<<<<\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app
echo -e "\e[36m>>>>>>>>>>>>>Extract Content <<<<<<<<<<<<<<<<<\e[0m"
unzip /tmp/catalogue.zip
cd /app
echo -e "\e[36m>>>>>>>>>>>>>Install NPM Service <<<<<<<<<<<<<<<<<\e[0m"
npm install
echo -e "\e[36m>>>>>>>>>>>>>Create Mongodb Service <<<<<<<<<<<<<<<<<\e[0m"
dnf install mongodb-org-shell -y
echo -e "\e[36m>>>>>>>>>>>>>Schema <<<<<<<<<<<<<<<<<\e[0m"
mongo --host mongodb.kr7348202.online </app/schema/catalogue.js
echo -e "\e[36m>>>>>>>>>>>>>Start Catalogue Service <<<<<<<<<<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue
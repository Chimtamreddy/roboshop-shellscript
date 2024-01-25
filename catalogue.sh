echo ">>>>>>>>>>>>>>>>> Create Catalogue Service <<<<<<<<<<<<<<"
cp catalogue.service /etc/systemd/system/catalogue.service
echo ">>>>>>>>>>>>>>>>> Create Mongodb Repo <<<<<<<<<<<<<<"
cp mongo.repo /etc/yum.repos.d/mongo.repo
echo ">>>>>>>>>>>>>>>>> Disable Nodejs <<<<<<<<<<<<<<"
dnf module disable nodejs -y
echo ">>>>>>>>>>>>>>>>> Enable Nodejs <<<<<<<<<<<<<<"
dnf module enable nodejs:18 -y
echo ">>>>>>>>>>>>>>>>> Install Nodejs <<<<<<<<<<<<<<"
dnf install nodejs -y
echo ">>>>>>>>>>>>>>>>> Remove Exiting Content <<<<<<<<<<<<<<"
rm -rf /app
echo ">>>>>>>>>>>>>>>>> Create Application User <<<<<<<<<<<<<<"
useradd roboshop
echo ">>>>>>>>>>>>>>>>> Create Application Directory <<<<<<<<<<<<<<"
mkdir /app
echo ">>>>>>>>>>>>>>>>> Download Application Content <<<<<<<<<<<<<<"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
echo ">>>>>>>>>>>>>>>>> Extract Application Content <<<<<<<<<<<<<<"
cd /app
unzip /tmp/catalogue.zip
cd /app
echo ">>>>>>>>>>>>>>>>> Download Nodejs Dependencies <<<<<<<<<<<<<<"
npm install
echo ">>>>>>>>>>>>>>>>> Install Mongodb Client <<<<<<<<<<<<<<"
dnf install mongodb-org-shell -y
echo ">>>>>>>>>>>>>>>>> Load Catalogue Schema <<<<<<<<<<<<<<"
mongo --host mongodb.kr7348202.online </app/schema/catalogue.js
echo ">>>>>>>>>>>>>>>>> Start Catalogue Service <<<<<<<<<<<<<<"
systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue

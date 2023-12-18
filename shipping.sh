script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

echo -e "\e[36m>>>>>>>>> Install Maven <<<<<<<<<<<\e[0m"
dnf install maven -y

echo -e "\e[36m>>>>>>>>> Create App User <<<<<<<<<<<\e[0m"
useradd ${app_user}

echo -e "\e[36m>>>>>>>>> Create App Directory <<<<<<<<<<<\e[0m"
rm-rf /app
mkdir /app

echo -e "\e[36m>>>>>>>>> Download App Content <<<<<<<<<<<\e[0m"
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip

echo -e "\e[36m>>>>>>>>> Extract App Content <<<<<<<<<<<\e[0m"
cd /app
unzip /tmp/shipping.zip

echo -e "\e[36m>>>>>>>>> Download Maven Dependencies <<<<<<<<<<<\e[0m"
mvn clean package
mv target/shipping-1.0.jar shipping.jar

echo -e "\e[36m>>>>>>>>> Copy User Systemd file <<<<<<<<<<<\e[0m"
cp $script_path/shipping.service /etc/systemd/system/shipping.service

echo -e "\e[36m>>>>>>>>> Install Mysql <<<<<<<<<<<\e[0m"
dnf install mysql -y

echo -e "\e[36m>>>>>>>>> Install Mysql <<<<<<<<<<<\e[0m"
mysql -h <MYSQL-SERVER-IPADDRESS> -uroot -pRoboShop@1 < /app/schema/shipping.sql

echo -e "\e[36m>>>>>>>>> Start Shipping Service <<<<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable shipping
systemctl restart shipping

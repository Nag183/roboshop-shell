source coommon.sh

echo -e "\e[36m>>>>>>>>> Disable Nodejs  <<<<<<<<<<<\e[0m"
dnf module disable nodejs -y
dnf module enable nodejs:18 -y

echo -e "\e[36m>>>>>>>>> Install NodeJs <<<<<<<<<<<\e[0m"
dnf install nodejs -y

echo -e "\e[36m>>>>>>>>> Add Application cart <<<<<<<<<<<\e[0m"
useradd ${app_user}

echo -e "\e[36m>>>>>>>>> Create Application Directory <<<<<<<<<<<\e[0m"
mkdir /app

echo -e "\e[36m>>>>>>>>> Download App Content <<<<<<<<<<<\e[0m"
curl -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip

echo -e "\e[36m>>>>>>>>> Unzip App Content <<<<<<<<<<<\e[0m"
cd /app
unzip /tmp/cart.zip

echo -e "\e[36m>>>>>>>>> Install NodeJs Dependencies <<<<<<<<<<<\e[0m"
npm install

echo -e "\e[36m>>>>>>>>> Copy cart Systemd file <<<<<<<<<<<\e[0m"
cp /home/centos/roboshop-shell/cart.service /etc/systemd/system/cart.service

echo -e "\e[36m>>>>>>>>> Start cart Service <<<<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable cart
systemctl restart cart

script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

echo -e "\e[36m>>>>>>>>> Install Nginx <<<<<<<<<<<\e[0m"
yum install nginx -y

echo -e "\e[36m>>>>>>>>> Copy roboshop Config file <<<<<<<<<<<\e[0m"
cp roboshop.conf /etc/ngnix/default.d/roboshop.conf

echo -e "\e[36m>>>>>>>>> Clean Old App content <<<<<<<<<<<\e[0m"
rm -rf /usr/share/nginx/html/*

echo -e "\e[36m>>>>>>>>> Download App Content <<<<<<<<<<<\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip

echo -e "\e[36m>>>>>>>>> Extracting App Content <<<<<<<<<<<\e[0m"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip

echo -e "\e[36m>>>>>>>>> Start Nginx <<<<<<<<<<<\e[0m"
systemctl restart nginx
systemctl enable nginx


echo -e "\e[36m>>>>>>>>> Install Redis <<<<<<<<<<<\e[0m"
cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[36m>>>>>>>>> Install Mongodb <<<<<<<<<<<\e[0m"
yum install mongodb-org -y

echo -e "\e[36m>>>>>>>>> Update Mongod Listen Address <<<<<<<<<<<\e[0m"
sed -i -e 's|127.0.0.1|0.0.0.0' /etc/mongod.conf

echo -e "\e[36m>>>>>>>>> Start Mongod Service <<<<<<<<<<<\e[0m"
systemctl enable mongod
systemctl start mongod

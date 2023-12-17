echo -e "\e[36m>>>>>>>>> Install Redis repos <<<<<<<<<<<\e[0m"
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y

echo -e "\e[36m>>>>>>>>> Install Redis <<<<<<<<<<<\e[0m"
dnf module enable redis:remi-6.2 -y
dnf install redis -y

echo -e "\e[36m>>>>>>>>> Update Redis Listen Address <<<<<<<<<<<\e[0m"
sed -i -e 's|127.0.0.1|0.0.0.0' /etc/redis.conf

echo -e "\e[36m>>>>>>>>> Start Redis Service <<<<<<<<<<<\e[0m"
systemctl enable redis
systemctl start redis

script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

mysql_root_password=$1

if [ -z "$mysql_root_password" ]; then
  echo Input Mysql Root Password Missing
  exit
fi

echo -e "\e[36m>>>>>>>>> Disable Mysql <<<<<<<<<<<\e[0m"
dnf module disable mysql -y

echo -e "\e[36m>>>>>>>>> Copy Mysql Repo File <<<<<<<<<<<\e[0m"
cp /home/centos/roboshop-shell/mysql.repo /etc/yum.repos.d/mysql.repo

echo -e "\e[36m>>>>>>>>> Install Mysql <<<<<<<<<<<\e[0m"
dnf install mysql-community-server -y

echo -e "\e[36m>>>>>>>>> Start Mysql <<<<<<<<<<<\e[0m"
systemctl enable mysqld
systemctl start mysqld

echo -e "\e[36m>>>>>>>>> Reset Mysql Password <<<<<<<<<<<\e[0m"
mysql_secure_installation --set-root-pass $mysql_root_password

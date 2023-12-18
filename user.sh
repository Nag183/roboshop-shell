script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

component=user

func_nodejs

echo -e "\e[36m>>>>>>>>> Copy Mongo repo <<<<<<<<<<<\e[0m"
cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[36m>>>>>>>>> Install MongoDB Client <<<<<<<<<<<\e[0m"
dnf install mongodb-org-shell -y

echo -e "\e[36m>>>>>>>>> Load Schema <<<<<<<<<<<\e[0m"
mongo --host MONGODB-SERVER-IPADDRESS </app/schema/user.js
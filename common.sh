app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")

print_head() {
  echo -e "\e[36m>>>>>>>>> $* <<<<<<<<<<<\e[0m"
}

schema_setup() {
  if [ "$schema_setup" == "mongo" ]; then
    print_head "Copy Mongo repo"
    cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo

    print_head "Install MongoDB Client"
    dnf install mongodb-org-shell -y

    print_head "Load Schema "
    mongo --host MONGODB-SERVER-IPADDRESS </app/schema/${component}.js
  fi
}

func_nodejs() {
  print_head "Disable Nodejs"
  dnf module disable nodejs -y
  dnf module enable nodejs:18 -y

  print_head "Install NodeJs "
  dnf install nodejs -y

  print_head "Add Application cart"
  useradd ${app_user}

  print_head "Create Application Directory"
  mkdir /app

  print_head "Download App Content"
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
  cd /app

  print_head "Unzip App Content"
  unzip /tmp/${component}.zip

  print_head "Install NodeJs Dependencies"
  npm install

  print_head "Copy cart Systemd file"
  cp $script_path/${component}.service /etc/systemd/system/${component}.service

  print_head "Start cart Service"
  systemctl daemon-reload
  systemctl enable ${component}
  systemctl restart ${component}

  schema_setup
}
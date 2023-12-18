app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")

func_nodejs() {
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
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
  cd /app

  echo -e "\e[36m>>>>>>>>> Unzip App Content <<<<<<<<<<<\e[0m"
  unzip /tmp/${component}.zip

  echo -e "\e[36m>>>>>>>>> Install NodeJs Dependencies <<<<<<<<<<<\e[0m"
  npm install

  echo -e "\e[36m>>>>>>>>> Copy cart Systemd file <<<<<<<<<<<\e[0m"
  cp $script_path/${component}.service /etc/systemd/system/${component}.service

  echo -e "\e[36m>>>>>>>>> Start cart Service <<<<<<<<<<<\e[0m"
  systemctl daemon-reload
  systemctl enable ${component}
  systemctl restart ${component}
}
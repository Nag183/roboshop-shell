app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")
log_file=/tmp/roboshop.log

func_print_head() {
  echo -e "\e[36m>>>>>>>>> $* <<<<<<<<<<<\e[0m"
}

func_stat_check() {
  if [ $1 -eq 0 ]; then
    echo -e "\e[32mSUCCESS\e[0m"
  else
    echo -e "\e[31mFAILURE\e[0m"
    echo "Refer the log file /tmp/roboshop.log for more information"
    exit 1
  fi
}

func_schema_setup() {
  if [ "$schema_setup" == "mongo" ]; then
    func_print_head "Copy Mongo repo"
    cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo &>>$log_file
    func_stat_check $?

    func_print_head "Install MongoDB Client"
    dnf install mongodb-org-shell -y &>>$log_file
    func_stat_check $?

    func_print_head "Load Schema "
    mongo --host MONGODB-SERVER-IPADDRESS </app/schema/${component}.js &>>$log_file
    func_stat_check $?
  fi
  if [ "${schema_setup}" == "mysql" ]; then
    func_print_head "Install Mysql"
    dnf install mysql -y &>>$log_file
    func_stat_check $?

    func_print_head "Install Mysql"
    mysql -h <MYSQL-SERVER-IPADDRESS> -uroot -p${mysql_root_password} < /app/schema/${component}.sql &>>$log_file
    func_stat_check $?
  fi
}

func_app_prereq() {
  func_print_head "Add Application User"
  useradd ${app_user} &>>$log_file
  func_stat_check $?

  func_print_head "Create Application Directory"
  rm-rf /app &>>$log_file
  mkdir /app &>>$log_file
  func_stat_check $?

  func_print_head "Download Application Content"
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>$log_file
  func_stat_check $?

  func_print_head "Extract Application Content"
  cd /app
  unzip /tmp/${component}.zip &>>$log_file
  func_stat_check $?
}

func_systemd_setup() {
  func_print_head "Copy User Systemd file"
  cp $script_path/${component}.service /etc/systemd/system/${component}.service
  func_stat_check $?

  func_print_head "Start Shipping Service"
  systemctl daemon-reload &>>$log_file
  systemctl enable ${component} &>>$log_file
  systemctl restart ${component} &>>$log_file
  func_stat_check $?
}

func_nodejs() {
  func_print_head "Disable Nodejs"
  dnf module disable nodejs -y &>>$log_file
  dnf module enable nodejs:18 -y &>>$log_file
  func_stat_check $?

  func_print_head "Install NodeJs "
  dnf install nodejs -y &>>$log_file
  func_stat_check $?

  func_app_prereq

  func_print_head "Install NodeJs Dependencies"
  npm install &>>$log_file
  func_stat_check $?

  func_schema_setup
  func_systemd_setup
}

func_java() {
  func_print_head "Install Maven"
  dnf install maven -y &>>$log_file
  func_stat_check $?

  func_app_prereq

   func_print_head "Download Maven Dependencies"
   mvn clean package &>>$log_file
   func_stat_check $?
   mv target/${component}-1.0.jar ${component}.jar &>>$log_file

  func_schema_setup
  func_systemd_setup
}

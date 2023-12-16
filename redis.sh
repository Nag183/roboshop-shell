dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y
dnf module enable redis:remi-6.2 -y
dnf install redis -y
systemctl enable redis
systemctl start redis

## Edit the file and replace 127.0.0.1 with 0.0.0.0
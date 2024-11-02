#!bin/bash

ID=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

MONGODB_HOST=mongodb.devsaibabu.site

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "Script Started at $TIMESTAMP" &>> $LOGFILE

VALIDATE(){
  if [ $1 -ne 0 ]
  then 
      echo -e "$2 ... $R Failed $N"
      exit 1
  else
      echo -e "$2 ... $G Success $N"
  fi    
}

if [ $ID -ne 0 ]
then 
    echo -e "$R ERROR - Run Script as Root User $N"
    exit 1
else 
    echo "You are Root User"
fi

dnf module disable mysql -y &>> $LOGFILE

VALIDATE $? "Disable current MySQL version"

cp mysql.repo /etc/yum.repos.d/mysql.repo

VALIDATE $? "Copied MySQL Repo"

dnf install mysql-community-server -y

VALIDATE $? "Installing MySQL Server"

systemctl enable mysqld

VALIDATE $? "Enable mySQL Server"

systemctl start mysqld

VALIDATE $? "Start mySQL Server"

mysql_secure_installation --set-root-pass RoboShop@1

VALIDATE $? "Setting mySQL root password"


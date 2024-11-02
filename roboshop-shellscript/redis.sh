#!bin/bash

ID=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

#MONGODB_HOST=mongodb.devsaibabu.site

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

exec &>$LOGFILE

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

dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y

VALIDATE $? "Installing Remi Release"

dnf module enable redis:remi-6.2 -y 

VALIDATE $? "Enabling Redis"

dnf install redis -y

VALIDATE $? "Installing Redis"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis.conf 

VALIDATE $? "Allwoing Remote connections"

systemctl enable redis

VALIDATE $? "Enable redis"

systemctl start redis

VALIDATE $? "Start redis"


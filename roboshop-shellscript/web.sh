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

dnf install nginx -y

VALIDATE $? "Installing Nginx"

systemctl enable nginx

VALIDATE $? "Enabling Nginx"

systemctl start nginx

VALIDATE $? "Starting Nginx"

rm -rf /usr/share/nginx/html/*

VALIDATE $? "Removing default website"

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip

VALIDATE $? "Download web application"

cd /usr/share/nginx/html

VALIDATE $? "Moving nginx html directory"

unzip -o /tmp/web.zip

VALIDATE $? "Unzipping web"

cp /home/centos/dawsSivakumarOne/roboshop-shellscript/roboshop.conf /etc/nginx/default.d/roboshop.conf 

VALIDATE $? "Copied roboshop reverse proxy conf"

systemctl restart nginx

VALIDATE $? "Restarting Nginx"

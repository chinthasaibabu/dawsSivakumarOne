#!bin/bash

ID=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

#MONGODB_HOST=mongodb.devsaibabu.site

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

dnf module disable nodejs -y  &>> $LOGFILE

VALIDATE $? "Disabling Current NODEJS"

dnf module enable nodejs:18 -y  &>> $LOGFILE

VALIDATE $? "Enabling Current NODEJS 18" 

dnf install nodejs -y  &>> $LOGFILE

VALIDATE $? "Installing NODEJS 18" 

id roboshop
if [ $? -ne 0 ]
then
    useradd roboshop &>> $LOGFILE
    VALIDATE $? "Roboshop User Creation"
else
    echo -e "ROboshop user already exist $Y SKIPPING $N"    
fi
#VALIDATE $? "Creating roboshop user" 

mkdir -p /app

VALIDATE $? "Creating app directory" 

curl -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip &>> $LOGFILE

VALIDATE $? "Downloading Cart Application"

cd /app

unzip -o /tmp/cart.zip &>> $LOGFILE

VALIDATE $? "Unzipping Cart" 

npm install &>> $LOGFILE

VALIDATE $? "Installing Dependencies" 

#use aboslute path
cp /home/centos/dawsSivakumarOne/roboshop-shellscript/cart.service /etc/systemd/system/cart.service &>> $LOGFILE

VALIDATE $? "Copying Cart Service file"

systemctl daemon-reload  &>> $LOGFILE

VALIDATE $? "Cart Daemon Reload" 

systemctl enable cart &>> $LOGFILE

VALIDATE $? "Enabling Cart" 

systemctl start cart &>> $LOGFILE

VALIDATE $? "Starting Cart" 

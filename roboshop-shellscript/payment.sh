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

dnf install python3.11 gcc python3-devel -y

id roboshop
if [ $? -ne 0 ]
then
    useradd roboshop &>> $LOGFILE
    VALIDATE $? "Roboshop User Creation"
else
    echo -e "ROboshop user already exist $Y SKIPPING $N"    
fi

mkdir -p /app 

curl -L -o /tmp/payment.zip https://roboshop-builds.s3.amazonaws.com/payment.zip

 VALIDATE $? "Downloading payment"

cd /app 

unzip -o /tmp/payment.zip

 VALIDATE $? "Unzipping Payment"

pip3.11 install -r requirements.txt

cp /home/centos/dawsSivakumarOne/roboshop-shellscript/payment.service /etc/systemd/system/payment.service

VALIDATE $? "Copying payment Service"

systemctl daemon-reload

systemctl enable payment 

VALIDATE $? "Enable Payment"

systemctl start payment

 VALIDATE $? "Start Payment"
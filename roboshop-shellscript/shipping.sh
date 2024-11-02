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

dnf install maven -y

id roboshop
if [ $? -ne 0 ]
then
    useradd roboshop &>> $LOGFILE
    VALIDATE $? "Roboshop User Creation"
else
    echo -e "ROboshop user already exist $Y SKIPPING $N"    
fi

mkdir -p /app

VALIDATE $? "Creating app directory"

curl -L -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip

VALIDATE $? "Download Shipping"

cd /app

VALIDATE $? "Moving to app directory"

unzip -o /tmp/shipping.zip

VALIDATE $? "Unzipping shipping"

mvn clean package

VALIDATE $? "Installing dependecies"

mv target/shipping-1.0.jar shipping.jar

VALIDATE $? "Renaminf JAR file"

cp /home/centos/dawsSivakumarOne/roboshop-shellscript/shipping.service /etc/systemd/system/shipping.service &>> $LOGFILE

VALIDATE $? "Copying shipping service"

systemctl daemon-reload

VALIDATE $? "daemon reload"

systemctl enable shipping

VALIDATE $? "enable shipping"

systemctl start shipping

VALIDATE $? "start shipping"

dnf install mysql -y &>> $LOGFILE

VALIDATE $? "Installing mySQL client"

mysql -h mysql.devsaibabu.site -uroot -pRoboShop@1 < /app/schema/shipping.sql &>> $LOGFILE

VALIDATE $? "Shipping Data"

systemctl restart shipping

VALIDATE $? "Restart Shipping"
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

curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>> $LOGFILE

VALIDATE $? "Downloading erlang script"

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>> $LOGFILE

VALIDATE $? "Downloading rabbitmq script"

dnf install rabbitmq-server -y &>> $LOGFILE

VALIDATE $? "Installing rabbitmq server"

systemctl enable rabbitmq-server &>> $LOGFILE

VALIDATE $? "Enablling rabbitmq server"

systemctl start rabbitmq-server &>> $LOGFILE

VALIDATE $? "Starting rabbitmq server"

rabbitmqctl add_user roboshop roboshop123 &>> $LOGFILE

VALIDATE $? "Creating user"

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>> $LOGFILE

VALIDATE $? "Setting Permissions"
#!bin/bash

ID=$(id -u)

R="\e[31m"
G="\e[32m"
N="\e[0m"

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "Script Started at $TIMESTAMP" &>> $LOGFILE

VALIDATE(){
  if [ $1 -ne 0 ]
  then 
      echo -e "$2 ... $R Failed $N"
}

if [ $ID -ne 0 ]
then 
    echo -e "$R ERROR - Run Script as Root User $N"
    exit 1
else 
    echo "You are Root User"
fi

#echo "All Arguments Passed $@"

#git mysql postfix net-tools
for package in $@
do
  yum list installed $package &>> $LOGFILE
  if [ $? -ne 0 ]
  then 
      yum install $package -y &>> $LOGFILE
      VALIDATE $? "Installation of $package"
  else
      echo -e "$package is already installed ... $Y Skipping $N"
  fi        
done
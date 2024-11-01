#!bin/bash

ID=$(id -u)

VALIDATE(){
  if [ $? -ne 0 ]
  then
      echo "Error is failed"
      exit 1
  else 
      echo "Installing is success"    
  fi
}

if [ $ID -ne 0 ]
then 
    echo "Error Please Run Script as Root Access"
    exit 1
else
    echo "You are root user"    
fi

yum install mysql -y

VALIDATE

yum install git -y

VALIDATE
    
#!bin/bash

ID=$(id -u)

if [ $ID -ne 0 ]
then 
    echo "Error Please Run Script as Root Access"
    exit 1
else
    echo "You are root user"    
fi

yum install mysql -y

if [ $? -ne 0 ]
then
    echo "Error Mysql is failed"
    exit 1
else 
    echo "Installing mysql is success"    
fi
    
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
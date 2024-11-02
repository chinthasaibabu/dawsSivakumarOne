#!bin/bash

ID=$(id -u)

if [ $ID -ne 0 ]
then 
    echo -e "$R ERROR - Run Script as Root User $N"
    exit 1
else 
    echo "You are Root User"
fi

echo "All Arguments Passed $@"
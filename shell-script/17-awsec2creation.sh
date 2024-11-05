#!bin/bash

#aws ec2 run-instances --image-id <ami-id> --count 1 --instance-type <instance-type> --key-name <keypair-name> --security-groups <security-group-name> --subnet-id <subnet-id> --associate-public-ip-address --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=<name>}]' --block-device-mappings '[{"DeviceName":"/dev/xvda","Ebs":{"VolumeSize":20,"VolumeType":"gp2"}}]'

AMI=ami-0b4f379183e5706b9
SG_ID=sg-0f516ae4ce666a615
INSTANCES=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "dispatch" "web")
HOSTEDZONE_ID=Z010740722CC0UUGEG0TN
DOMAIN_NAME="devsaibabu.site"

for i in "${INSTANCES[@]}"
do
    echo "Instance is : $i"
    if [ $i == "mongodb"] || [ $i == "mysql"] || [ $i == "shipping"]
    then 
        INSTANCE_TYPE="t3.small"
    else
        INSTANCE_TYPE="t2.micro"
    fi

    IP_ADDRESS=$(aws ec2 run-instances --image-id $AMI --instance-type $INSTANCE_TYPE --security-group-ids $SG_ID --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" --query 'Instances[0].PrivateIpAddress' --output text)

    echo "$i : $IP_ADDRESS"

   #delete existing records in doamain
    aws route53 change-resource-record-sets \
  --hosted-zone-id $HOSTEDZONE_ID \
  --change-batch '
  {
    "Comment": "Creating a record set for cognito endpoint"
    ,"Changes": [{
      "Action"              : "CREATE"
      ,"ResourceRecordSet"  : {
        "Name"              : "'$i'.'$DOMAIN_NAME'"
        ,"Type"             : "A"
        ,"TTL"              : 1
        ,"ResourceRecords"  : [{
            "Value"         : "'$IP_ADDRESS'"
        }]
      }
    }]
  }
  "

done

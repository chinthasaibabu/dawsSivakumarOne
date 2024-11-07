resource "aws_instance" "web" {
  ami           = "ami-0b4f379183e5706b9" #devops-practice
  instance_type = "t2.micro"
  #security_groups = [ aws_security_group.roboshop-all.id ]
  vpc_security_group_ids = [ aws_security_group.roboshop-all.id ]

  tags = {
    Name = "Hello Terraform"
  }
}

resource "aws_security_group" "roboshop-all" { #this is terraform name for terraform
#  name        = "roboshop-all-aws" #this is for AWS
#  description = "Allow TLS inbound traffic and all outbound traffic"

  name        = var.sg-name #this is for AWS
  description = var.sg-description

  #vpc_id      = aws_vpc.main.id
  ingress {
    description      = "Allow All Ports"
   # from_port        = 0 #all
    from_port        = var.inbound-from-port
    to_port          = 0
    protocol         = "tcp"
    #cidr_blocks      = ["0.0.0.0/0"]
    cidr_blocks      = var.cidr-blocks
    #ipv6_cidr_blocks = ["::/0"]
  }

  egress{
    from_port        = 0 #all
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    #ipv6_cidr_blocks = ["::/0"]
  }

  tags={
    Name    ="roboshop-all-aws"
  }
}
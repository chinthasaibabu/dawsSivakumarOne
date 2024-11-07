resource "aws_security_group" "roboshop-all" { #this is terraform name for terraform

  name        = var.sg-name #this is for AWS
  description = var.sg-description

  ingress {
    description      = "Allow All Ports"
    from_port        = var.inbound-from-port
    to_port          = 0
    protocol         = "tcp"
    cidr_blocks      = var.cidr_blocks
  }

  egress{
    from_port        = 0 #all
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags={
    Name    ="roboshop-all-aws"
  }
}
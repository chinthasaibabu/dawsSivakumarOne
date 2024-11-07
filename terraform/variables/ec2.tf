resource "aws_instance" "web" {
  ami           = var.ami_id #devops-practice
  instance_type = var.instance_type
  #security_groups = [ aws_security_group.roboshop-all.id ]
  vpc_security_group_ids = [ aws_security_group.roboshop-all.id ]

  tags = var.tags
}
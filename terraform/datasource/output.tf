output "ami_id" {
  value = data.aws_ami.centos8.id
}

output "aws_linux_id" {
  value = data.aws_ami.aws-linux-2.id
}

output "vpc_info" {
  value = data.aws_vpc.default
}
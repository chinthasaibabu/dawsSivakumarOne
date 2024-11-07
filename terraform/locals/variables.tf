variable "instance_names" {
  type = list
  default = ["mongodb","redis","mysql","rabbitmq","user","cart","shipping","payment","dispatch","web","catalogue"]
}

variable "ami_id" {
  type = string
  default = "ami-0b4f379183e5706b9"
}

variable "instance_type" {
  type = string
  default = "t2.micro"
}

variable "zone_id" {
  default = "Z010740722CC0UUGEG0TN"
}

variable "domain_name" {
  default = "devsaibabu.site"
}
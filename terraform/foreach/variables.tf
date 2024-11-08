variable "instance_names" {
  type = map
  default = {
    mongodb="t3.small"
    redis="t2.micro"
    mysql="t3.small"
    rabbitmq="t2.micro"
    catalogue="t2.micro"
    cart="t2.micro"
    user="t2.micro"
    shipping="t3.small"
    payment="t2.micro"
    dispatch="t2.micro"
    web="t2.micro"
  }
}

# variable "isProd" {
#   type = bool
#   default = false
# }

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
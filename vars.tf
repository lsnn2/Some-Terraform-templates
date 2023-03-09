variable "REGION" {
  default = "us-east-1"
}

variable "ZONE1" {
  default = "us-east-1a"
}

variable "ZONE2" {
  default = "us-east-1b"
}

variable "ZONE3" {
  default = "us-east-1c"
}

variable "AMIS" {
  type = map
  default = {
    "centos_7"       = "ami-002070d43b0a4f171"
    "ubuntu_18_04" = "ami-0263e4deb427da90e"
    "ubuntu_20_04" = "ami-09cd747c78a9add63"

  }
}

variable "USER" {
  type = map
  default = {
    "centos" = "centos"
    "ubuntu" = "ubuntu"
  }
}

variable "MYIP" {
  default = "13.41.87.223/32"
}

variable "VPCID" {
  default = "vpc-0927e8e29721bc9eb"
}
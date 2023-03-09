resource "aws_vpc" "jenkins" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  tags = {
    "Name" = "vpc_terraform"
  }

}

resource "aws_subnet" "jenkins-pub-1" {
  vpc_id                  = aws_vpc.jenkins.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = var.ZONE1
  tags = {
    Name = "jenkins-pub-1"
  }
}
resource "aws_subnet" "jenkins-pub-2" {
  vpc_id                  = aws_vpc.jenkins.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = var.ZONE2
  tags = {
    Name = "jenkins-pub-2"
  }
}
resource "aws_subnet" "jenkins-pub-3" {
  vpc_id                  = aws_vpc.jenkins.id
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = var.ZONE3
  tags = {
    Name = "jenkins-pub-3"
  }
}
resource "aws_subnet" "jenkins-priv-1" {
  vpc_id                  = aws_vpc.jenkins.id
  cidr_block              = "10.0.4.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = var.ZONE1
  tags = {
    Name = "jenkins-priv-1"
  }
}
resource "aws_subnet" "jenkins-priv-2" {
  vpc_id                  = aws_vpc.jenkins.id
  cidr_block              = "10.0.5.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = var.ZONE2
  tags = {
    Name = "jenkins-priv-2"
  }
}
resource "aws_subnet" "jenkins-priv-3" {
  vpc_id                  = aws_vpc.jenkins.id
  cidr_block              = "10.0.6.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = var.ZONE3
  tags = {
    Name = "jenkins-priv-3"
  }
}

resource "aws_internet_gateway" "terraform-IGW" {
  vpc_id = aws_vpc.jenkins.id
  tags = {
    Name = "terraform-IGW"
  }

}

resource "aws_route_table" "terra-pub-RT" {
  vpc_id = aws_vpc.jenkins.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terraform-IGW.id

  }
  tags = {
    Name = "terra-pub-RT"
  }

}
resource "aws_route_table_association" "terra-RT-association-1" {
  subnet_id      = aws_subnet.jenkins-pub-1.id
  route_table_id = aws_route_table.terra-pub-RT.id
}
resource "aws_route_table_association" "terra-RT-association-2" {
  subnet_id      = aws_subnet.jenkins-pub-2.id
  route_table_id = aws_route_table.terra-pub-RT.id
}
resource "aws_route_table_association" "terra-RT-association-3" {
  subnet_id      = aws_subnet.jenkins-pub-3.id
  route_table_id = aws_route_table.terra-pub-RT.id
}


variable "VPCID" {
  default = "vpc-03bce804ae35894d3"
}
variable "ZONE" {
  default = "eu-north-1a"
}

variable "AMIS" {
  type = map(any)
  default = {
    "centos_7"     = "ami-002070d43b0a4f171"
    "ubuntu_18_04" = "ami-00f3b1efb1e4d1fb7"
    "ubuntu_20_04" = "ami-09cd747c78a9add63"

  }
}

variable "USER" {
  type = map(any)
  default = {
    "centos" = "centos"
    "ubuntu" = "ubuntu"
  }
}
resource "aws_key_pair" "outline-key" {
  key_name   = "outline-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQD73wntsBAPwZuSQuooAZzU1BeFKHg7PZMhgGTK6z3P1/2LZvzEa0zm/EPlpw70TM2Tk+kcRv46UqqUWvI8UxI26W4s8CXfQb+4S3hDkjHgiNYKJgg6aIWV5OmgUgV3g9Ik/wSMh0o6P+UEp/ICcy+b49t6SQToqNtvRxEfB2LTH/Ve5fn5dldpQB6udOBtWgJzEIx9wipwtvOYjPTdOE5XwowGNtCYsXeHPfZ8Nbp7Lay52uDExVnnCX25ZxDjNZudUJwzjAHLZpyFkWZrDY99aHfoQsP+YKbaqFhJNvqpPZJBEur2HnAqLTLEVN2DGy+ClnGCpJwIX5SMtNDOE0tCuRGSIPBQprZb+nywA8zrtLBEWqk4YseniqL9TuCfigEsQ2usEA5t7caQWAh+ZsbykfrlOCqRw/BEEXblDiTHoGSxSxtkN+DQKnn6Tg4r9Rb07K+bm2vcz25GJLfV53WduUoYNoUDdScuaN9Xx6Mn2Uh1cH/01jYGdNqYD3477RiYE6FGCMfvcfBWjoJWGnDGDwQJWu9d6nwxurd1fO7bahayMljd7kwd2yy1gorpYewipFbcAWCS/zzpZtYK9w2mQsQAK3G0BSk354Hy0fVDkKzFsI8bmyUp3MnypgxEGxuCkO6JdoAT48ZLVmGD6xGAZAwP7y38KYIC/o/7o0tpjQ== siningli@Sinings-MacBook-Pro.local"
}
variable "MYIP" {
  default = "13.41.87.223/32"
}

resource "aws_security_group" "OutlineVPN-sg" {
  vpc_id      = var.VPCID
  name        = "OutlineVPN-sg"
  description = "Sec Grp for Outline"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.MYIP]
  }
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "outline-sg"
  }
}

resource "aws_instance" "Outline-instance" {
  ami                    = var.AMIS["ubuntu_18_04"]
  instance_type          = "t3.micro"
  availability_zone      = var.ZONE
  key_name               = aws_key_pair.outline-key.key_name
  vpc_security_group_ids = [aws_security_group.OutlineVPN-sg.id]
  tags = {
    Name    = "Outline-instance"
    Project = "VPN"
  }

  provisioner "file" {
    source      = "DeployOutlineVPN.sh"
    destination = "/tmp/DeployOutlineVPN.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod u+x /tmp/DeployOutlineVPN.sh"
      , "sudo /tmp/DeployOutlineVPN.sh"
    ]

  }

  connection {
    user        = var.USER["ubuntu"]
    private_key = file("id_rsa")
    host        = self.public_ip
  }
}

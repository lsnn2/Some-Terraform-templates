provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "jenkins-instance" {
  ami                    = "ami-006dcf34c09e50022"
  instance_type          = "t2.micro"
  availability_zone      = "us-east-1a"
  key_name               = "jenkins-key"
  vpc_security_group_ids = ["sg-0cbee5252f44d9e98"]
  tags = {
    "Name"    = "jenkins-instance"
    "Project" = "Jenkins"
  }
}

resource "aws_instance" "jenkins-inst" {
  ami                    = var.AMIS[var.REGION]
  instance_type          = "t2.micro"
  availability_zone      = var.ZONE1
  key_name               = "jenkins-key"
  vpc_security_group_ids = ["sg-0cbee5252f44d9e98"]
  tags = {
    "Name"    = "jenkins-instance"
    "Project" = "Jenkins"
  }

}
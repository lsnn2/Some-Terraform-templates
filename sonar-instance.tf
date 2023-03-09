resource "aws_instance" "sonar-instance" {
  ami                    = var.AMIS["ubuntu_18_04"]
  instance_type          = "t2.medium"
  availability_zone      = var.ZONE1
  key_name               = aws_key_pair.jenkins-key.key_name
  vpc_security_group_ids = [aws_security_group.sonar_sg.id]
  tags = {
    Name    = "sonar-instance"
    Project = "CICD"
  }

  provisioner "file" {
    source      = "sonar-setup.sh"
    destination = "/tmp/sonar-setup.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod u+x /tmp/sonar-setup.sh"
      , "sudo /tmp/sonar-setup.sh"
    ]

  }

  connection {
    user        = var.USER["ubuntu"]
    private_key = file("id_rsa")
    host        = self.public_ip
  }
}


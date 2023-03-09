resource "aws_instance" "nexus-instance" {
  ami                    = var.AMIS["centos_7"]
  instance_type          = "t2.medium"
  availability_zone      = var.ZONE1
  key_name               = aws_key_pair.jenkins-key.key_name
  vpc_security_group_ids = [aws_security_group.nexus_sg.id]
  tags = {
    Name    = "Nexus-instance"
    Project = "CICD"
  }

  provisioner "file" {
    source      = "nexus-setup.sh"
    destination = "/tmp/nexus-setup.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod u+x /tmp/nexus-setup.sh"
      , "sudo /tmp/nexus-setup.sh"
    ]

  }

  connection {
    user        = var.USER["centos"]
    private_key = file("id_rsa")
    host        = self.public_ip
  }
}

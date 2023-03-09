resource "aws_key_pair" "jenkins-key" {
  key_name   = "jenkinskey"
  public_key = file("id_rsa.pub")
}

resource "aws_instance" "nexus-instance" {
  ami                    = var.AMIS[var.REGION]
  instance_type          = "t2.micro"
  availability_zone      = var.ZONE1
  key_name               = aws_key_pair.jenkins-key.key_name
  vpc_security_group_ids = ["sg-0571d188fac48640b"]
  tags = {
    Name    = "Nexus-instance"
    Project = "CICD"
  }

  provisioner "file" {
    source      = "nexus-setup.sh"
    destination = "/tmp/nexus-setup"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod u+x /tmp/nexus-setup.sh"
      , "sudo /tmp/nexus-setup"
    ]

  }

  connection {
    user        = var.USER
    private_key = file("id_rsa")
    host        = self.public_ip
  }
}

output "PublicIP" {
  value = aws_instance.jenkins-inst.public_ip
}

output "PrivateIP" {
  value = aws_instance.jenkins-inst.private_ip
}
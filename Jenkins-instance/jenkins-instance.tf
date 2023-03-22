resource "aws_key_pair" "jenkins-key" {
  key_name   = "jenkinskey"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQD73wntsBAPwZuSQuooAZzU1BeFKHg7PZMhgGTK6z3P1/2LZvzEa0zm/EPlpw70TM2Tk+kcRv46UqqUWvI8UxI26W4s8CXfQb+4S3hDkjHgiNYKJgg6aIWV5OmgUgV3g9Ik/wSMh0o6P+UEp/ICcy+b49t6SQToqNtvRxEfB2LTH/Ve5fn5dldpQB6udOBtWgJzEIx9wipwtvOYjPTdOE5XwowGNtCYsXeHPfZ8Nbp7Lay52uDExVnnCX25ZxDjNZudUJwzjAHLZpyFkWZrDY99aHfoQsP+YKbaqFhJNvqpPZJBEur2HnAqLTLEVN2DGy+ClnGCpJwIX5SMtNDOE0tCuRGSIPBQprZb+nywA8zrtLBEWqk4YseniqL9TuCfigEsQ2usEA5t7caQWAh+ZsbykfrlOCqRw/BEEXblDiTHoGSxSxtkN+DQKnn6Tg4r9Rb07K+bm2vcz25GJLfV53WduUoYNoUDdScuaN9Xx6Mn2Uh1cH/01jYGdNqYD3477RiYE6FGCMfvcfBWjoJWGnDGDwQJWu9d6nwxurd1fO7bahayMljd7kwd2yy1gorpYewipFbcAWCS/zzpZtYK9w2mQsQAK3G0BSk354Hy0fVDkKzFsI8bmyUp3MnypgxEGxuCkO6JdoAT48ZLVmGD6xGAZAwP7y38KYIC/o/7o0tpjQ== siningli@Sinings-MacBook-Pro.local"
}

resource "aws_instance" "jenkins-instance" {
  ami                    = var.AMIS["ubuntu_20_04"]
  instance_type          = "t2.small"
  availability_zone      = var.ZONE1
  key_name               = aws_key_pair.jenkins-key.key_name
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
  tags = {
    Name    = "jenkins-instance"
    Project = "CICD"
  }

  provisioner "file" {
    source      = "jenkins-setup.sh"
    destination = "/tmp/jenkins-setup.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod u+x /tmp/jenkins-setup.sh"
      , "sudo /tmp/jenkins-setup.sh"
    ]

  }

  connection {
    user        = var.USER["ubuntu"]
    private_key = file("id_rsa")
    host        = self.public_ip
  }
}

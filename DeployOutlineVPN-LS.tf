resource "aws_lightsail_instance" "outline-instance" {
  name              = "outline-instance"
  availability_zone = "eu-north-1a"
  blueprint_id      = "ubuntu_18_04"
  bundle_id         = "nano_2_3"
  key_pair_name     = aws_lightsail_key_pair.outline-key.name
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
    host        = aws_lightsail_instance.outline-instance.public_ip_address
  }
}
resource "aws_lightsail_key_pair" "outline-key" {
  name       = "outline-key"
  public_key = file("./id_rsa.pub")
}

resource "aws_lightsail_instance_public_ports" "outline" {
  instance_name = aws_lightsail_instance.outline-instance.name

  port_info {
    protocol  = "tcp"
    from_port = 0
    to_port   = 65535
  }
  port_info {
    protocol  = "udp"
    from_port = 0
    to_port   = 65535
  }
  port_info {
    protocol  = "tcp"
    from_port = 22
    to_port   = 22
    cidrs = [var.MYIP]
  }
}
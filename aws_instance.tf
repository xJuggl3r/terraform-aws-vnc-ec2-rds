# Provides an EC2 instance resource.
resource "aws_instance" "web" {
  ami                         = "ami-0747bdcabd34c712a"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.instance.id]
  key_name                    = "automation"
  tags                        = { Name = var.app }

  # Wait for RDS to be ready to deploy VM (in order to get RDS endpoint)
  depends_on = [
    aws_db_instance.default,
  ]

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file(var.key_pair_location)
  }

  provisioner "file" {
    source      = "webserver.sh"
    destination = "/tmp/webserver.sh"
  }

  provisioner "file" {
    source      = "./files/credentials"
    destination = "/tmp/credentials"
  }

  provisioner "file" {
    source      = "./files/config"
    destination = "/tmp/config"
  }

  provisioner "file" {
    source      = "./files/client-config"
    destination = "/tmp/client-config"
  }

  provisioner "file" {
    source      = "./files/client-credentials"
    destination = "/tmp/client-credentials"
  }

  provisioner "file" {
    source      = "./files/dbpass"
    destination = "/tmp/dbpass"
  }

  provisioner "file" {
    source      = "./files/dbbatch"
    destination = "/tmp/dbbatch"
  }

  provisioner "file" {
    source      = "./files/readfile.txt"
    destination = "/tmp/readfile.txt"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/webserver.sh",
      "sudo /tmp/webserver.sh"
    ]
  }

}

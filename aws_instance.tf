# Provides an EC2 instance resource.
resource "aws_instance" "web" {
  ami                         = "ami-0747bdcabd34c712a"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.instance.id]
  key_name                    = "automation"
  tags                        = { Name = var.app }

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

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/webserver.sh",
      "cd /tmp",
      "sudo ./webserver.sh"
    ]
  }

}
# # Provides an SSM Parameter data source (Ubuntu 18.04).
# data "aws_ssm_parameter" "ubuntu-bionic" {
#   name = "/aws/service/canonical/ubuntu/server/18.04/stable/current/amd64/hvm/ebs-gp2"
# }

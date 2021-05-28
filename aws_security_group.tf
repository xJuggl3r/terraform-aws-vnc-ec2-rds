# Provides a security group resource.
resource "aws_security_group" "instance" {
  name        = var.app
  description = "secutity group for instanse of ${var.app}"
  vpc_id      = aws_vpc.main.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ssh_cidr_blocks
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = { Name = "${var.app}-instance-security-group" }
}

resource "aws_security_group" "db_instance" {
  name        = "${var.app}-db"
  description = "security group for db instance of ${var.app}"
  vpc_id      = aws_vpc.main.id
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.instance.id]
  }
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
  }
  tags = { Name = "${var.app}-db-instance-security-group" }
}

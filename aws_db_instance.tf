# Provides an RDS instance resource.
resource "aws_db_instance" "default" {
  allocated_storage = 20
  storage_type = "gp2"
  engine = "mysql"
  engine_version = "5.7.30"
  instance_class = "db.t2.micro"
  db_subnet_group_name = aws_db_subnet_group.default.id
  vpc_security_group_ids  = [ aws_security_group.db_instance.id ]
  parameter_group_name = aws_db_parameter_group.default.id
  name = var.db_name
  username = var.db_username
  password = var.db_password
  skip_final_snapshot = true
  tags = { Name = "${var.app}-rds" }
}
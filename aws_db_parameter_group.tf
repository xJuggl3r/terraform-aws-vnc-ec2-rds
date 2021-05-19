# Provides an RDS DB parameter group resource.
resource "aws_db_parameter_group" "default" {
  name_prefix = var.app
  family = "mysql5.7"
  description = "${var.app} parameter group for mysql5.7"
  parameter {
    name = "time_zone"
    value = "America/Cuiaba"
  }
  tags = { Name = var.app }
}
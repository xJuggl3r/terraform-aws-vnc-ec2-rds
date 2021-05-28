# Provides an RDS DB subnet group resource.
resource "aws_db_subnet_group" "default" {
  name        = "${var.app}-db-subnet-group"
  description = "${var.app}-db-subnet-group"
  subnet_ids  = [aws_subnet.private1.id, aws_subnet.private2.id]
  tags        = { Name = "${var.app}-db-subnet-group" }
}
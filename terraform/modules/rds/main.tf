resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "${var.project_name}-db-subnet-group"
  }
}

resource "aws_db_instance" "mysql" {
  identifier           = "${var.project_name}-mysql"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  allocated_storage    = 20
  storage_type         = "gp2"
  db_name              = "orders"
  username             = "dbadmin"
  password             = var.mysql_password
  db_subnet_group_name = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.rds_security_group_id]
  skip_final_snapshot  = true
  publicly_accessible  = false
  multi_az             = false

  tags = {
    Name = "${var.project_name}-mysql"
  }
}

resource "aws_db_instance" "postgres" {
  identifier           = "${var.project_name}-postgres"
  engine               = "postgres"
  engine_version       = "15"
  instance_class       = "db.t3.micro"
  allocated_storage    = 20
  storage_type         = "gp2"
  db_name              = "retaildb"
  username             = "postgres"
  password             = var.postgres_password
  db_subnet_group_name = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.rds_security_group_id]
  skip_final_snapshot  = true
  publicly_accessible  = false
  multi_az             = false

  tags = {
    Name = "${var.project_name}-postgres"
  }
}

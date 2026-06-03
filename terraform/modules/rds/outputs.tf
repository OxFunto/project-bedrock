output "mysql_endpoint" { value = aws_db_instance.mysql.endpoint }
output "postgres_endpoint" { value = aws_db_instance.postgres.endpoint }
output "mysql_host" { value = aws_db_instance.mysql.address }
output "postgres_host" { value = aws_db_instance.postgres.address }

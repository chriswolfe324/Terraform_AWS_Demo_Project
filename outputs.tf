output "RDS_endpoint" {
    description = "enpoint of RDS database"
    value = aws_db_instance.rds_instance.endpoint
}
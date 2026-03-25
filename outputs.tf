output "RDS_endpoint" {
  description = "enpoint of RDS database"
  value       = aws_db_instance.rds_instance.endpoint
}

output "private_subnet1" {
  description = "private_subnet1"
  value       = aws_subnet.private1.id
}

output "private_subnet2" {
  description = "private_subnet2"
  value       = aws_subnet.private1.id
}

output "Background_workers_SG" {
  description = "Security Group of background workers"
  value       = aws_security_group.background_workers.id
}
output "rds_endpoint" {
    value = aws_db_instance.default.endpoint
    description = "The endpoint of the RDS instance"
}


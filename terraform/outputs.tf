output "rds_endpoint" {
    value = aws_db_instance.default.endpoint
    description = "The endpoint of the RDS instance"
}

output "ec2_instance_id" {
    value = aws_ec2_instance.taskapp.id
    description = "The ID of the EC2 instance"
}

output "ec2_private_ip" {
    value = aws_ec2_instance.taskapp.private_ip
    description = "The private IP address of the EC2 instance"
}

output "ec2_cluster_name" {
    value = aws_ecs_cluster.main_cluster.name
    description = "The name of the ECS cluster"
}

output "ecs_service_arn" {
    value = aws_ecs_service.ecs_service.arn
    description = "The ARN of the ECS service"
}

resource "aws_db_subnet_group" "rds_subnet_group" {
    name = "rds_subnet_group"
    subnet_ids = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]

    tags = {
        Name = "rds_subnet_group"
    }
}

resource "aws_db_instance" "default" {
    allocated_storage    = 1
    db_name              = "task_db"
    engine               = "mysql"
    engine_version       = "8.0"
    instance_class       = "db.t3.micro"
    username             = var.db_username
    password             = var.db_password
    parameter_group_name = "default.mysql8.0"
    skip_final_snapshot  = true
    db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
    vpc_security_ids = [aws_security_group.rds_sg.id]

    tags = {
        Name = "task-db-database"
    }
}
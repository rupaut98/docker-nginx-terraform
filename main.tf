provider "aws" {
    region = "us-west-2"
}

resource "aws_vpc" "main_vpc"{
    cidr_block = "10.0.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true

    tags = {
        Name = "main_vpc"
    }
}

resource "aws_subnet" "private_subnet_1"{
    vpc_id = aws_vpc.main_vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-west-2a"

    tags = {
        Name = "private_subnet_1"
    }
}

resource "aws_subnet" "private_subnet_2"{
    vpc_id = aws_vpc.main_vpc.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "us-west-2b"

    tags = {
        Name = "private_subnet_2"
    }
}

resource "aws_route_table" "private_route_table" {
    vpc_id = aws_vpc.main_vpc.id

    tags = {
        Name = "private_route_table"
    }
}

resource "aws_route_table_association" "private_subnet_1_association" {
    subnet_id = aws_subnet.private_subnet_1.id
    route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_subnet_2_association" {
    subnet_id = aws_subnet.private_subnet_2.id
    route_table_id = aws_route_table.private_route_table.id
}

resource "aws_db_subnet_group" "rds_subnet_group" {
    name = "rds_subnet_group"
    subnet_ids = ["aws_subnet.private_subnet_1.id", "aws_subnet.private_subnet_2.id"]

    tags = {
        Name = "rds_subnet_group"
    }
}

resource "aws_security_group" "rds_sg"{
    vpc_id = aws_vpc.main_vpc.id

    ingress{
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        cidr_blocks = ["10.0.0.0/16"]
    }

    egress{
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_block = ["0.0.0.0/0"]
    }

    tags {
        Name = "rds_security_group"
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


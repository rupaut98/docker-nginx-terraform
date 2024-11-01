resource "aws_security_group" "rds_sg" {
    vpc_id = aws_vpc.main_vpc.id 

    ingress {
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        cidr_blocks = ["10.0.0.0/16"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]    
    }

    tags = {
        Name = "rds_security_group"
    }
}
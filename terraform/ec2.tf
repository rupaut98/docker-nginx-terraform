resource "aws_instance" "taskapp" {
    ami = "ami-07c5ecd8498c59db5"
    instance_type = "t3.micro"
    subnet_id = aws_subnet.public_subnet.id
    associate_public_ip_address = true
    key_name = "temp"

    security_groups = [aws_security_group.ec2_sg.id]

    tags = {
        Name = "taskapp"
    }
}

resource "aws_security_group" "ec2_sg" {
    name        = "ec2_security_group"
    description = "Security group for EC2 instance"
    vpc_id      = aws_vpc.main_vpc.id

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["10.0.0.0/16"]
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["69.246.48.44/32"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

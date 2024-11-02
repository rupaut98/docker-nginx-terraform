resource "aws_ec2_instance" "taskapp" {
    ami = "ami-0c55b159cbfafe1f0"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.private_subnet_1.id
    associate_public_ip_address = false

    security_groups = [aws_security_group.ec2_sg.id]

    tags = {
        Name = "taskapp"
    }
}

resource "aws_security_group" "ec2_sg" {
    name = "ec2_security_group"
    description = "Security group for EC2 instance"
    vpc_id = aws_vpc.main_vpc.id

    ingress = {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["10.0.0.0/16"]
    }

    egress = {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
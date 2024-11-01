resource "aws_subnet" "private_subnet_1" {
    vpc_id = aws_vpc.main_vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-west-2a"

    tags = {
        Name = "private_subnet_1"
    }
}

resource "aws_subnet" "private_subnet_2" {
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

resource "aws_route_table_association "private_subnet_2_association" {
    subnet_id = aws_subnet.private_subnet_2.id 
    route_table_id = aws_route_table.private_route_table.id 
}

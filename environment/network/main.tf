#VPC
resource "aws_vpc" "vpc4" {
cidr_block = var.vpcblock
enable_dns_hostnames = true
enable_dns_support = true
tags = { Name = "vpc4" }
}

#Internet Gateway
resource "aws_internet_gateway" "gateway" {
vpc_id = aws_vpc.vpc4.id
tags = { Name = "gateway" }
}

#Public Routing Table
resource "aws_route_table" "public" {
vpc_id = aws_vpc.vpc4.id
route {
cidr_block = var.cidrblock
gateway_id = aws_internet_gateway.gateway.id
}
tags = { Name = "Public_Routing_Table" }
}
#Private Routing Table
resource "aws_route_table" "private" {
vpc_id = aws_vpc.vpc4.id
route {
cidr_block = var.cidrblock
gateway_id = aws_internet_gateway.gateway.id
}
tags = { Name = " Private_Routing_Table" }
}

#Public Subnet
resource "aws_subnet" "public" {
vpc_id = aws_vpc.vpc4.id
cidr_block = var.sub[0]
map_public_ip_on_launch = true
availability_zone = var.azone
tags = { Name = "Public_Subnet" }
}

#Private Subnet
resource "aws_subnet" "private" {
vpc_id = aws_vpc.vpc4.id
cidr_block = var.sub[1]
availability_zone = var.azone
tags = { Name = "private_Subnet" }
}

# Association of public subnet with public routing table
resource "aws_route_table_association" "public" {
subnet_id = aws_subnet.public.id
route_table_id = aws_route_table.public.id
}


# Association of private subnet with private routing table
resource "aws_route_table_association" "private" {
subnet_id = aws_subnet.private.id
route_table_id = aws_route_table.private.id
}


# Configuration of security group
resource "aws_security_group" "security" {
name = "security"
description = "allow web traffic and SSH"
vpc_id = aws_vpc.vpc4.id
ingress {
description = "Allow SSH"
from_port = 22
to_port = 22
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}
ingress {
description = "Allow HTTP"
from_port = 80
to_port = 80
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}
egress {
description = "Allow all traffic"
from_port = 0
to_port = 0
protocol = "-1"
cidr_blocks = ["0.0.0.0/0"]
}
}

# Create EC2 instance in the public subnet
resource "aws_instance" "EC01" {
ami = var.ami-id
instance_type = "t2.micro"
subnet_id = aws_subnet.public.id
availability_zone = var.azone
security_groups = [aws_security_group.security.id]
key_name = "lab2"
tags = { Name = "EC01" }
}

# Create EC2 instance in the private subnet
resource "aws_instance" "EC02" {
ami = var.ami-id
instance_type = "t2.micro"
subnet_id = aws_subnet.private.id
availability_zone = var.azone
security_groups = [aws_security_group.security.id]
key_name = "lab2"
tags = { Name = "EC02" }
}


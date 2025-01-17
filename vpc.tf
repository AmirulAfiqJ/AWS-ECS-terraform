provider "aws" {
  region = "us-east-1"  # Update with the region you're working in
}

variable "vpc_cidr" {
 description = "The CIDR block for the VPC"
 type = string
 default = "10.1.0.0/16" 
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    name = "main"
  }
}

resource "aws_subnet" "subnet" {
  vpc_id = aws_vpc.main.id
  cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 8, 1)
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"   
}

resource "aws_subnet" "subnet2" {
  vpc_id = aws_vpc.main.id
  cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 8, 2)
  map_public_ip_on_launch = true
  availability_zone = "us-east-1b"
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.main.id
  tags = {
    name = "internet_gateway"
  }
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
}

resource "aws_route_table_association" "subnet_route" {
  subnet_id = aws_subnet.subnet.id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_security_group" "security_group" {
  name = "ecs-security-group"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port = 0
    to_port = 0
    protocol = -1
    self = "false"
    cidr_blocks = ["0.0.0.0/0"]
    description = "any"
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

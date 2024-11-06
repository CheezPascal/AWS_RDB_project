# Define provider
provider "aws" {
  region = "us-east-1"
}

# Create a VPC
resource "aws_vpc" "my_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

# Create a subnet
resource "aws_subnet" "my_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
}

# Create an Internet Gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
}

# Create a route table
resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }
}

# Associate the route table with the subnet
resource "aws_route_table_association" "my_route_table_assoc" {
  subnet_id      = aws_subnet.my_subnet.id
  route_table_id = aws_route_table.my_route_table.id
}

# Security Group allowing SSH and MySQL access
resource "aws_security_group" "my_sg" {
  vpc_id = aws_vpc.my_vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Be cautious; this allows access from all IPs.
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Adjust this to limit access.
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance with MySQL installation
resource "aws_instance" "my_instance" {
  ami             = "ami-08c40ec9ead489470" # Ubuntu 20.04 in us-east-1, update with your preferred version
  instance_type   = "t2.micro"              # Adjust to your needs and AWS Free Tier availability
  subnet_id       = aws_subnet.my_subnet.id
  security_groups = [aws_security_group.my_sg.name]

  user_data = <<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get install mysql-server -y
    systemctl start mysql
    systemctl enable mysql
  EOF

  tags = {
    Name = "MyUbuntuInstance"
  }
}

output "instance_id" {
  value = aws_instance.my_instance.id
}

output "instance_public_ip" {
  value = aws_instance.my_instance.public_ip
}

output "mysql_security_group_id" {
  value = aws_security_group.my_sg.id
}

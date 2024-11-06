/*
# Create a subnet group
resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = [aws_subnet.private.*.id]

  tags = {
    Name = "main"
  }
}

# Create two private subnets
resource "aws_subnet" "private" {
  count      = 2
  vpc_id     = aws_vpc.main.id
  cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)


  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "private-${count.index + 1}"
  }
}


# Create a security group for the database
resource "aws_security_group" "default" {
  name   = "rds_security_group"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 3306 # Replace with your desired port
    to_port     = 3306 # Replace with your desired port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Replace with your desired CIDR block
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds_security_group"
  }
}
*/ 

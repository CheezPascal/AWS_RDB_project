# Configure the AWS Provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

# Create a VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "main"
  }
}


# Retrieve available availability zones
data "aws_availability_zones" "available" {}

# Create an RDS instance
resource "aws_db_instance" "default" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql" # Replace with your desired engine
  engine_version         = "8.0"   # Replace with your desired engine version
  instance_class         = "db.t3.micro"
  identifier             = "aws-rds-instance"
  username               = "admin"    # Replace with your desired username
  password               = "password" # Replace with your desired password
  db_subnet_group_name   = aws_db_subnet_group.default.name
  vpc_security_group_ids = [aws_security_group.default.id]
  skip_final_snapshot    = true


  tags = {
    Name = "aws-rds-instance"
  }
}

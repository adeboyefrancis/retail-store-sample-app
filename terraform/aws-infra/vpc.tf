## VPC Definitionn

#VPC
resource "aws_vpc" "name" {
    cidr_block = var.vpc_cidr
    enable_dns_hostnames = true
    enable_dns_support = true
  
}


#Internet Gateway
resource "aws_internet_gateway" "name" {
  
}


#Public Subnets


#Private Subnets


#Elastic IP for NAT Gateway


#Public Route Table


#Private Route Table


#Public Route Table Associations


#Private Route Table Associations

## VPC Definitionn

#VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags                 = var.tags # Alternatively use merge function to and more key/value pair merge(var.tags,{ VPC = "${var.environment}-vpc"})

  lifecycle {
    prevent_destroy = false

  }

}


#Internet Gateway
resource "aws_internet_gateway" "internet_gw" {
  vpc_id = aws_vpc.main.id
  tags   = merge(var.tags, { env = "${var.suffix_name}-igw" })

}

#Public Subnets
resource "aws_subnet" "public_subnets" {
  for_each                = { for idx, az in local.azs : az => local.public_subnets[idx] }
  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = true
  tags                    = merge(var.tags, { env = "${var.suffix_name}-public-sub" })

}


#Private Subnets
resource "aws_subnet" "private_subnets" {
  for_each          = { for idx, az in local.azs : az => local.private_subnets[idx] }
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = each.key
  tags              = merge(var.tags, { env = "${var.suffix_name}-private-sub" })
}


#Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc"
  tags   = merge(var.tags, { env = "${var.suffix_name}-eip" })
}

#NAT Gateway
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = values(aws_subnet.public_subnets)[0].id
  depends_on    = [aws_internet_gateway.internet_gw]
  tags          = merge(var.tags, { env = "${var.suffix_name}-ngw" })
}

#Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gw.id
  }

  tags = merge(var.tags, { env = "${var.suffix_name}-pbrt" })

}


#Private Route Table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = merge(var.tags, { env = "${var.suffix_name}-prvrt" })

}

#Public Route Table Associations
resource "aws_route_table_association" "public_rta" {
  for_each       = aws_subnet.public_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_rt.id
}


#Private Route Table Associations
resource "aws_route_table_association" "private_rta" {
  for_each       = aws_subnet.private_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_rt.id
}

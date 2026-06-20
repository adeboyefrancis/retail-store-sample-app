## Local Scratch Pad for logics & dynamic functions 
data "aws_availability_zones" "availablity_zone" {
  state = "available"
}


locals {
  # Using slice functions - https://developer.hashicorp.com/terraform/language/functions
  # using slice function  
  azs = slice(data.aws_availability_zones.availablity_zone.names, 0, 3)
  # using cidrsubnet function
  public_subnets  = [for k, az in local.azs : cidrsubnet(var.vpc_cidr, var.subnet_newbits, k)]
  private_subnets = [for k, az in local.azs : cidrsubnet(var.vpc_cidr, var.subnet_newbits, k + 10)]
}

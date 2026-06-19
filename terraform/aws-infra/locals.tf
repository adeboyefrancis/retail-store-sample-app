## Local Scratch Pad for logics & dynamic functions 
data "aws_availability_zones" "availablity_zone" {
    state = "available"  
}


locals {
  # Using slice functions - https://developer.hashicorp.com/terraform/language/functions
  # using slice function  
  azs = slice(data.aws_availability_zones.avaliablity_zone.names, 0, 3)
  # using cidrsubnet function
  public_subnets = [for i, az in locals.azs: cidrsubnet(var.vpc_cidr, var.subnet_newbits, i)]
  private_subnets = [for i, az in locals.azs: cidrsubnet(var.vpc_cidr, var.subnet_newbits, i+10)]
}

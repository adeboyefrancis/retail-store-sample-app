# Variables
variable "aws_region" {
  type = string
}

variable "suffix_name" {
  description = "suffix names appended to each resources"
  default     = "devbox"

}

variable "s3_bucket_name" {
  type = string
}

variable "tags" {
  description = "AWS Resource Tags"
  type        = map(string)

}

variable "vpc_cidr" {
  description = "VPC CIDR Block - Address Space /16"
  type        = string

}

variable "subnet_newbits" {
  description = "Number of new bits to add to VPC CIDR to generate subnets (e.g., 8 means /24 from /16)"
  type        = number
}

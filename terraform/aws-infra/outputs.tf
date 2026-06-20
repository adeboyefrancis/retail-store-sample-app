# Outputs
output "s3_bucket_name" {
  value = aws_s3_bucket.s3_bucket_name.bucket

}

output "s3_bucket_arn" {
  value = aws_s3_bucket.s3_bucket_name.arn

}


output "public_subnets_id" {
  value = [for s in aws_subnet.public_subnets : s.id]

}

output "private_subnets_id" {
  value = [for s in aws_subnet.private_subnets : s.id]

}

output "public_subnets_map" {
  value = { for az, subnet in aws_subnet.public_subnets : az => subnet.id }

}

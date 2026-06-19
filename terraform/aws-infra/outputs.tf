# Outputs
output "s3_bucket_name" {
  value = aws_s3_bucket.s3_bucket_name.bucket

}

output "s3_bucket_arn" {
  value = aws_s3_bucket.s3_bucket_name.arn

}

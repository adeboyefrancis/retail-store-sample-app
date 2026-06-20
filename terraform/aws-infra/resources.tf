## Demo Resources

# Resouruce Block: Random String
resource "random_string" "suffix" {
  length  = 4
  upper   = false
  special = false
}

resource "aws_s3_bucket" "s3_bucket_name" {
  bucket = "${var.s3_bucket_name}-${random_string.suffix.result}"
  tags   = var.tags

}

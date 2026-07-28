## Remote Backend S3 Bucket for Terraform State

# Resouruce Block: Random String
resource "random_string" "suffix" {
  length  = 4
  upper   = false
  special = false
}


# Resource Block: S3 Bucket for Remote Backend + Lifecycle
resource "aws_s3_bucket" "s3_bucket_name" {
  bucket = "${var.s3_bucket_name}-${random_string.suffix.result}-${var.aws_region}"
  tags   = var.tags

  lifecycle {
    prevent_destroy = false
  }

}

# Resource Block: S3 Bucket Versioning

resource "aws_s3_bucket_versioning" "s3_versioning" {
  bucket = aws_s3_bucket.s3_bucket_name.id
  versioning_configuration {
    status = "Enabled"

  }
}


# Resource Block: S3 Server Side Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "s3_encryption" {
  bucket = aws_s3_bucket.s3_bucket_name.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }

}


# Resource Block: S3 Public Access Block
resource "aws_s3_bucket_public_access_block" "s3_public_access" {
  bucket = aws_s3_bucket.s3_bucket_name.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

}


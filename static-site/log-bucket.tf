resource "aws_s3_bucket" "log-bucket" {
  bucket = var.log_bucket
}

resource "aws_s3_bucket_versioning" "log-bucket" {
  bucket = aws_s3_bucket.log-bucket.id
  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "log-bucket" {
  bucket = aws_s3_bucket.log-bucket.bucket

  rule {
    id = "delete-after-30-days"

    status = "Enabled"

    noncurrent_version_expiration {
      noncurrent_days = 30
    }
  }
}

resource "aws_s3_bucket_ownership_controls" "log-bucket" {
  bucket = aws_s3_bucket.log-bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

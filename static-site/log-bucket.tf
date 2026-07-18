# trivy:ignore:AWS-0132
# trivy:ignore:AWS-0320
# trivy:ignore:AWS-0089
resource "aws_s3_bucket" "log-bucket" {
  bucket = var.log_bucket
}

resource "aws_s3_bucket_versioning" "log-bucket" {
  bucket = aws_s3_bucket.log-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "log-bucket" {
  bucket = aws_s3_bucket.log-bucket.bucket

  rule {
    id = "expire-logs-after-30-days"

    status = "Enabled"

    expiration {
      days = 30
    }

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

resource "aws_s3_bucket_public_access_block" "log-bucket" {
  bucket = aws_s3_bucket.log-bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

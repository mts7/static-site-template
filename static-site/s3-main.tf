resource "aws_s3_bucket" "static-site" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_ownership_controls" "static-site" {
  bucket = aws_s3_bucket.static-site.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_versioning" "static-site" {
  bucket = aws_s3_bucket.static-site.id
  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_cors_configuration" "static-site" {
  bucket = aws_s3_bucket.static-site.id
  cors_rule {
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
  }
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.static-site.arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.static-site-distribution.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "static-site" {
  bucket = aws_s3_bucket.static-site.id
  policy = data.aws_iam_policy_document.s3_policy.json

  depends_on = [
    data.aws_iam_policy_document.s3_policy
  ]
}

resource "aws_cloudfront_origin_access_control" "static-site" {
  name                              = "${var.bucket_name}-oac"
  description                       = "OAC for ${var.bucket_name}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_s3_bucket_public_access_block" "static-site" {
  bucket = aws_s3_bucket.static-site.id

  block_public_acls   = true
  block_public_policy = true
}

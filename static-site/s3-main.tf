resource "aws_s3_bucket" "static-site" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_acl" "static-site" {
  bucket = aws_s3_bucket.static-site.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "static-site" {
  bucket = aws_s3_bucket.static-site.id
  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_website_configuration" "static-site" {
  bucket = aws_s3_bucket.static-site.id

  index_document {
    suffix = "index.html"
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
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn]
    }
  }

  depends_on = [
    aws_cloudfront_origin_access_identity.origin_access_identity
  ]
}

resource "aws_s3_bucket_policy" "static-site" {
  bucket = aws_s3_bucket.static-site.id
  policy = data.aws_iam_policy_document.s3_policy.json

  depends_on = [
    data.aws_iam_policy_document.s3_policy
  ]
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "OAI for ${var.bucket_name}"
}

resource "aws_s3_bucket_public_access_block" "static-site" {
  bucket = aws_s3_bucket.static-site.id

  block_public_acls   = true
  block_public_policy = true
}

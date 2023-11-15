terraform {
  required_version = ">= 1.5.0"

  backend "s3" {
    bucket = "TODO:enter-bucket-name-here-backend-terraform-state"
    key     = "networking/terraform.tfstate"
    region  = "TODO:enter-region-here"
    encrypt = true
  }
}

import {
  to = aws_s3_bucket.terraform_state
  id = "pick-first-player.mts7.com-backend-terraform-state"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket        = "${var.backend_bucket_prefix}-backend-terraform-state"
  force_destroy = false

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.terraform_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

output "bucket_name_terraform_state" {
  value = aws_s3_bucket.terraform_state.id
}

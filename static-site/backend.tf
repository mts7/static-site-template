terraform {
  backend "s3" {
    bucket = "TODO:enter-bucket-name-here-backend-terraform-state"
    key    = "default-infrastructure"
    region = "TODO:enter-region-here"
  }
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "${var.bucket_name}-backend-terraform-state"
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

output "bucket_name_terraform_state" {
  value = aws_s3_bucket.terraform_state.id
}

provider "aws" {
  region = var.region
}

resource "aws_acm_certificate" "default" {
  provider                  = aws
  domain_name               = var.domain
  subject_alternative_names = ["*.${var.domain}"]
  validation_method         = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

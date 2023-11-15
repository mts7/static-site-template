resource "aws_cloudfront_distribution" "static-site-distribution" {
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  origin {
    domain_name = aws_s3_bucket.static-site.bucket_regional_domain_name
    origin_id   = aws_s3_bucket_website_configuration.static-site.website_endpoint

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }

  aliases = [var.app_domain]
  tags    = { "project" : var.app_domain }

  logging_config {
    bucket          = "${var.log_bucket}.s3.amazonaws.com"
    include_cookies = false
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US"]
    }
  }

  default_cache_behavior {
    target_origin_id = aws_s3_bucket_website_configuration.static-site.website_endpoint

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 7200
    max_ttl                = 86400
  }

  custom_error_response {
    error_caching_min_ttl = 10
    error_code            = 403
    response_code         = 200
    response_page_path    = "/index.html"
  }

  custom_error_response {
    error_caching_min_ttl = 10
    error_code            = 404
    response_code         = 200
    response_page_path    = "/index.html"
  }

  viewer_certificate {
    acm_certificate_arn            = aws_acm_certificate.default.arn
    cloudfront_default_certificate = false
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1.2_2021"
  }

  depends_on = [
    aws_s3_bucket.static-site
  ]
}

resource "aws_cloudfront_function" "rewrite-html-extension" {
  name    = "${local.resource_name_prefix}-rewrite-html-extension"
  runtime = "cloudfront-js-2.0"
  comment = "Appends .html to extensionless URIs and index.html to directory URIs, matching Next.js static export output"
  publish = true
  code    = file("${path.module}/cloudfront-functions/rewrite-html-extension.js")
}

resource "aws_cloudfront_cache_policy" "static-site" {
  name    = "${local.resource_name_prefix}-cache-policy"
  comment = "Caching for ${var.bucket_name}: no query strings/cookies, static-export TTLs"

  min_ttl     = 0
  default_ttl = 86400
  max_ttl     = 31536000

  parameters_in_cache_key_and_forwarded_to_origin {
    enable_accept_encoding_gzip   = true
    enable_accept_encoding_brotli = true

    cookies_config {
      cookie_behavior = "none"
    }

    headers_config {
      header_behavior = "none"
    }

    query_strings_config {
      query_string_behavior = "none"
    }
  }
}

data "aws_cloudfront_response_headers_policy" "security-headers" {
  name = "Managed-SecurityHeadersPolicy"
}

# trivy:ignore:AWS-0011
resource "aws_cloudfront_distribution" "static-site-distribution" {
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  price_class         = var.price_class
  http_version        = "http2and3"

  origin {
    domain_name              = aws_s3_bucket.static-site.bucket_regional_domain_name
    origin_id                = "S3-${var.bucket_name}"
    origin_access_control_id = aws_cloudfront_origin_access_control.static-site.id

    s3_origin_config {
      origin_access_identity = ""
    }
  }

  aliases = [var.app_domain]

  logging_config {
    bucket          = "${var.log_bucket}.s3.amazonaws.com"
    include_cookies = false
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  default_cache_behavior {
    target_origin_id = "S3-${var.bucket_name}"

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true

    cache_policy_id            = aws_cloudfront_cache_policy.static-site.id
    response_headers_policy_id = data.aws_cloudfront_response_headers_policy.security-headers.id

    viewer_protocol_policy = "redirect-to-https"

    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.rewrite-html-extension.arn
    }
  }

  custom_error_response {
    error_caching_min_ttl = 10
    error_code            = 403
    response_code         = 404
    response_page_path    = "/404.html"
  }

  custom_error_response {
    error_caching_min_ttl = 10
    error_code            = 404
    response_code         = 404
    response_page_path    = "/404.html"
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

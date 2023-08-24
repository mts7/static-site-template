output "bucket_name" {
  value = aws_s3_bucket.static-site.id
}

output "bucket_website_endpoint" {
  value = aws_s3_bucket_website_configuration.static-site.website_endpoint
}

output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.static-site-distribution.domain_name
}

output "cloudfront_distribution" {
  value = aws_cloudfront_distribution.static-site-distribution.id
}

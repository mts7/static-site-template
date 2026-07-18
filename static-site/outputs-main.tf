output "bucket_name" {
  value = aws_s3_bucket.static-site.id
}

output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.static-site-distribution.domain_name
}

output "cloudfront_distribution" {
  value = aws_cloudfront_distribution.static-site-distribution.id
}

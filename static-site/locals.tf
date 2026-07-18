locals {
  # CloudFront resource names (functions, OAC, cache policies) don't allow dots,
  # but bucket_name is domain-shaped (e.g. "app.example.com").
  resource_name_prefix = replace(var.bucket_name, ".", "-")
}

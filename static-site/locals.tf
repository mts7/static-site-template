locals {
  resource_name_prefix = replace(var.bucket_name, ".", "-")
}

variable "domain" {
  default = "example.com"
}

variable "app_domain" {
  default = "app.example.com"
}

variable "bucket_name" {
  default = "app.example.com"
}

variable "backend_bucket_prefix" {
  default = "app.example.com"
}

variable "log_bucket" {
  default = "app.example.com-logs"
}

variable "region" {
  default = "us-east-1"
}

variable "price_class" {
  description = "CloudFront price class controlling which edge locations serve the distribution."
  default     = "PriceClass_100"
}

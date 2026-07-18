variable "domain" {
  type    = string
  default = "example.com"
}

variable "app_domain" {
  type    = string
  default = "app.example.com"
}

variable "bucket_name" {
  type    = string
  default = "app.example.com"
}

variable "backend_bucket_prefix" {
  type    = string
  default = "app.example.com"
}

variable "log_bucket" {
  type    = string
  default = "app.example.com-logs"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "price_class" {
  type        = string
  description = "CloudFront price class controlling which edge locations serve the distribution."
  default     = "PriceClass_100"
}

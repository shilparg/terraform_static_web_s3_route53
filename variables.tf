variable "bucket_name" {
  type        = string
  description = "Name of the S3 bucket"
}

variable "region" {
  type        = string
  description = "AWS region to deploy resources"
}

variable "environment" {
  type        = string
  description = "Deployment environment (e.g., dev, prod)"
  default     = "dev"
}

variable "domain_name" {
  type        = string
  description = "Fully qualified domain name"
}

variable "zone_name" {
  type        = string
  description = "Route 53 hosted zone name"
}

variable "enable_dns" {
  type        = bool
  description = "Toggle Route 53 DNS record creation"
  default     = true
}

variable "enable_iam" {
  type        = bool
  description = "Toggle IAM role and policy creation"
  default     = true
}
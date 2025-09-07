locals {
  is_dev  = var.environment == "dev"
  is_prod = var.environment == "prod"

  features = {
    s3  = true
    iam = var.enable_iam
    dns = var.enable_dns
  }
}
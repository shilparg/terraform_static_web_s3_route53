provider "aws" {
  region = var.region
}

module "s3_static_site" {
  source      = "./s3"
  bucket_name = var.bucket_name
  environment = var.environment
}

module "iam_role" {
  source      = "./iam"
  count       = local.features["iam"] ? 1 : 0
  environment = var.environment
}

module "dns_record" {
  source      = "./route53"
  count       = local.features["dns"] ? 1 : 0
  domain_name = var.domain_name
  zone_name   = var.zone_name
  environment = var.environment

  # Pass S3 values from s3 module
  website_domain     = module.s3_static_site.website_domain
  hosted_zone_id     = module.s3_static_site.hosted_zone_id
}
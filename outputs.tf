output "bucket_name" {
  value = module.s3_static_site.bucket_name
}

output "website_domain" {
  value = module.s3_static_site.website_domain
}

output "route53_record" {
  value = local.features["dns"] ? module.dns_record[0].record_name : null
}

output "iam_role_name" {
  value = local.features["iam"] ? module.iam_role[0].role_name : null
}
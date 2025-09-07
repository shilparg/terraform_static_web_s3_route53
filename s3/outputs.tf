output "bucket_name" {
  value = aws_s3_bucket.shilpas3_site.id
}

output "website_domain" {
  value = aws_s3_bucket_website_configuration.site_config.website_domain
}

output "hosted_zone_id" {
  value = aws_s3_bucket.shilpas3_site.hosted_zone_id
}
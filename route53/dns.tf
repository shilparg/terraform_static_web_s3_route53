data "aws_route53_zone" "sandbox" {
  name         = var.zone_name
  private_zone = false
}

resource "aws_route53_record" "shilpas3" {
  zone_id = data.aws_route53_zone.sandbox.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = var.website_domain
    zone_id                = var.hosted_zone_id
    evaluate_target_health = false
  }
}
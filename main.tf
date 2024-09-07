resource "aws_cognito_user_pool_domain" "main" {
  domain          = var.dns
  certificate_arn = aws_acm_certificate.cert.arn
  user_pool_id    = aws_cognito_user_pool.main.id
}

resource "aws_cognito_user_pool" "main" {
  name = var.name
}

resource "aws_route53_record" "main" {
  zone_id = var.dns_zone
  name    = var.dns
  type    = "A"

  alias {
    name                   = aws_cognito_user_pool_domain.main.cloudfront_distribution_arn
    zone_id                = "Z2FDTNDATAQYW2"
    evaluate_target_health = false
  }
}

resource "aws_acm_certificate" "cert" {
  domain_name       = var.dns
  validation_method = "DNS"
  provider          = aws.acm

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert_validation" {
  name    = element(tolist(aws_acm_certificate.cert.domain_validation_options), 0).resource_record_name
  type    = element(tolist(aws_acm_certificate.cert.domain_validation_options), 0).resource_record_type
  zone_id = var.dns_zone
  records = [element(tolist(aws_acm_certificate.cert.domain_validation_options), 0).resource_record_value]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "cert" {
  provider                = aws.acm
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = concat(
    [aws_route53_record.cert_validation.fqdn],
    [for i,o in tolist(aws_acm_certificate.cert.domain_validation_options): substr(lookup(o, "resource_record_name"), 0, length(lookup(o, "resource_record_name")) - 1)  if (i > 0 && (lookup(o, "domain_name") != element(tolist(aws_acm_certificate.cert.domain_validation_options), 0).domain_name))]
  )
}

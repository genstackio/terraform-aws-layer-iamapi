resource "aws_cognito_user_pool_domain" "main" {
  domain          = var.dns
  certificate_arn = aws_acm_certificate.cert.arn
  user_pool_id    = aws_cognito_user_pool.main.id
}

resource "aws_cognito_user_pool" "main" {
  name = var.name
  dynamic "lambda_config" {
    for_each = local.has_lambdas ? {y: true} : {}
    content {
      create_auth_challenge          = local.lambda_create_auth_challenge_arn
      pre_authentication             = local.lambda_pre_authentication_arn
      post_authentication            = local.lambda_post_authentication_arn
      custom_message                 = local.lambda_custom_message_arn
      define_auth_challenge          = local.lambda_define_auth_challenge_arn
      post_confirmation              = local.lambda_post_confirmation_arn
      pre_sign_up                    = local.lambda_pre_sign_up_arn
      pre_token_generation           = local.lambda_pre_token_generation_arn
      user_migration                 = local.lambda_user_migration_arn
      verify_auth_challenge_response = local.lambda_verify_auth_challenge_response_arn
    }
  }
}

resource "aws_lambda_permission" "post_confirmation_cognito_lambda_invoke_permission" {
  for_each = local.lambdas
  statement_id  = "AllowExecutionFromCognito"
  action        = "lambda:InvokeFunction"
  function_name = lookup(each.value, "arn", null)
  principal     = "cognito-idp.amazonaws.com"
  source_arn    = aws_cognito_user_pool.main.arn
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

resource "aws_cognito_user_pool_client" "client" {
  for_each = {for k in var.clients: k => {name = k}}
  name = each.value.name
  user_pool_id = aws_cognito_user_pool.main.id
}

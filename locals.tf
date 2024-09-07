locals {
  // pre_authentication
  lambda_pre_authentication = lookup(var.lambdas, "pre_authentication", null) != null ? var.lambdas["pre_authentication"] : null
  lambda_pre_authentication_arn = local.lambda_pre_authentication != null ? lookup(local.lambda_pre_authentication, "arn", null) : null
  // post_authentication
  lambda_post_authentication = lookup(var.lambdas, "post_authentication", null) != null ? var.lambdas["post_authentication"] : null
  lambda_post_authentication_arn = local.lambda_post_authentication != null ? lookup(local.lambda_post_authentication, "arn", null) : null
  // create_auth_challenge
  lambda_create_auth_challenge = lookup(var.lambdas, "create_auth_challenge", null) != null ? var.lambdas["create_auth_challenge"] : null
  lambda_create_auth_challenge_arn = local.lambda_create_auth_challenge != null ? lookup(local.lambda_create_auth_challenge, "arn", null) : null
  // custom_message
  lambda_custom_message = lookup(var.lambdas, "custom_message", null) != null ? var.lambdas["custom_message"] : null
  lambda_custom_message_arn = local.lambda_custom_message != null ? lookup(local.lambda_custom_message, "arn", null) : null
  // define_auth_challenge
  lambda_define_auth_challenge = lookup(var.lambdas, "define_auth_challenge", null) != null ? var.lambdas["define_auth_challenge"] : null
  lambda_define_auth_challenge_arn = local.lambda_define_auth_challenge != null ? lookup(local.lambda_define_auth_challenge, "arn", null) : null
  // post_confirmation
  lambda_post_confirmation = lookup(var.lambdas, "post_confirmation", null) != null ? var.lambdas["post_confirmation"] : null
  lambda_post_confirmation_arn = local.lambda_post_confirmation != null ? lookup(local.lambda_post_confirmation, "arn", null) : null
  // pre_sign_up
  lambda_pre_sign_up = lookup(var.lambdas, "pre_sign_up", null) != null ? var.lambdas["pre_sign_up"] : null
  lambda_pre_sign_up_arn = local.lambda_pre_sign_up != null ? lookup(local.lambda_pre_sign_up, "arn", null) : null
  // pre_token_generation
  lambda_pre_token_generation = lookup(var.lambdas, "pre_token_generation", null) != null ? var.lambdas["pre_token_generation"] : null
  lambda_pre_token_generation_arn = local.lambda_pre_token_generation != null ? lookup(local.lambda_pre_token_generation, "arn", null) : null
  // user_migration
  lambda_user_migration = lookup(var.lambdas, "user_migration", null) != null ? var.lambdas["user_migration"] : null
  lambda_user_migration_arn = local.lambda_user_migration != null ? lookup(local.lambda_user_migration, "arn", null) : null
  // verify_auth_challenge_response
  lambda_verify_auth_challenge_response = lookup(var.lambdas, "verify_auth_challenge_response", null) != null ? var.lambdas["verify_auth_challenge_response"] : null
  lambda_verify_auth_challenge_response_arn = local.lambda_verify_auth_challenge_response != null ? lookup(local.lambda_verify_auth_challenge_response, "arn", null) : null

  // lambdas
  lambdas = merge(
    {},
    null != local.lambda_pre_authentication ? { pre_authentication = local.lambda_pre_authentication } : {},
    null != local.lambda_post_authentication ? { post_authentication = local.lambda_post_authentication } : {},
    null != local.lambda_create_auth_challenge ? { create_auth_challenge = local.lambda_create_auth_challenge } : {},
    null != local.lambda_custom_message ? { custom_message = local.lambda_custom_message } : {},
    null != local.lambda_define_auth_challenge ? { define_auth_challenge = local.lambda_define_auth_challenge } : {},
    null != local.lambda_post_confirmation ? { post_confirmation = local.lambda_post_confirmation } : {},
    null != local.lambda_pre_sign_up ? { pre_sign_up = local.lambda_pre_sign_up } : {},
    null != local.lambda_pre_token_generation ? { pre_token_generation = local.lambda_pre_token_generation } : {},
    null != local.lambda_user_migration ? { user_migration = local.lambda_user_migration } : {},
    null != local.lambda_verify_auth_challenge_response ? { verify_auth_challenge_response = local.lambda_verify_auth_challenge_response } : {},
  )

  has_lambdas = length(local.lambdas) > 0
}

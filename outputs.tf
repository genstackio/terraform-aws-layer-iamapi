output "user_pools" {
  value = {
    users = {
      arn = aws_cognito_user_pool.main.arn
      name = aws_cognito_user_pool.main.name
      endpoint = "https://${var.dns}"
      internal_endpoint = aws_cognito_user_pool.main.endpoint
      id = aws_cognito_user_pool.main.id
      clients = {for k,v in aws_cognito_user_pool_client.client: k => {name = v.name, id = v.id}}
    }
  }
}

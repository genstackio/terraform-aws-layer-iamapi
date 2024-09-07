output "user_pools" {
  value = {
    users = {
      arn = aws_cognito_user_pool.main.arn
      name = aws_cognito_user_pool.main.name
      endpoint = aws_cognito_user_pool.main.endpoint
      id = aws_cognito_user_pool.main.id
    }
  }
}

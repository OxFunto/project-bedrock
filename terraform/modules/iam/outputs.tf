output "lambda_role_arn" {
  value = aws_iam_role.lambda.arn
}

output "dev_user_arn" {
  value = aws_iam_user.dev.arn
}

output "dev_access_key_id" {
  value = aws_iam_access_key.dev.id
}

output "dev_secret_access_key" {
  value     = aws_iam_access_key.dev.secret
  sensitive = true
}

output "dev_console_password" {
  value     = aws_iam_user_login_profile.dev.password
  sensitive = true
}

output "alb_controller_role_arn" {
  value = aws_iam_role.alb_controller.arn
}

output "carts_dynamodb_role_arn" {
  value = aws_iam_role.carts_dynamodb.arn
}

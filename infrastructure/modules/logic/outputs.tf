# Outputs exposed by the logic module for use by the environment root
# module (infrastructure/environments/prod/main.tf).
#

# Consumed by the backend CI/CD workflow: required by
# `aws lambda update-function-code --function-name ...` to deploy
# new Python code.
output "get_visitor_count_function_name" {
  value = aws_lambda_function.get_visitor_count.function_name
}

# The API-Gateway-specific ARN format (NOT the plain function
# ARN below). Kept for completeness/future use - not currently
# referenced outside this module, since the integration resource
# references the Lambda resource directly rather than through
# this output.
output "get_visitor_count_invoke_arn" {
  value = aws_lambda_function.get_visitor_count.invoke_arn  # Needed by API Gateway in the next step
}

# Same purpose as above in "get_visitor_count_function_name", for the write-only function.
output "increment_visitor_count_function_name" {
  value = aws_lambda_function.increment_visitor_count.function_name
}

# Same purpose as above in "get_visitor_count_invoke_arn", for the write-only function.
output "increment_visitor_count_invoke_arn" {
  value = aws_lambda_function.increment_visitor_count.invoke_arn  # Needed by API Gateway in the next step
}

# The live API Gateway base URL. Consumed by: main.js (hardcoded
# from this value), Playwright smoke tests, and Postman/manual
# testing.
output "api_endpoint" {
  value = aws_apigatewayv2_api.visitor_count_api.api_endpoint   # The base URL - e.g. https://xxxx.execute-api.eu-central-1.amazonaws.com
}

# Consumed by modules/cicd: scopes the GitHub Actions role's IAM
# management permissions (iam:PutRolePolicy, iam:PassRole, etc.)
# to THIS execution role only - not IAM roles in general.
output "get_visitor_count_role_arn" {
    value = aws_iam_role.get_visitor_count_role.arn
}

# Same purpose as above in "get_visitor_count_role_arn", for the write-only function.
output "increment_visitor_count_role_arn" {
    value = aws_iam_role.increment_visitor_count_role.arn
}

# Different from api_endpoint above - this is the IAM-style ARN
# format, NOT a public URL. Consumed by modules/cicd: scopes the
# GitHub Actions role's apigateway:* permissions to THIS API only.
output "api_gateway_execution_arn" {
    value = aws_apigatewayv2_api.visitor_count_api.execution_arn
}

# The PLAIN function ARN (different format from invoke_arn above).
# Consumed by modules/cicd: scopes the GitHub Actions role's
# lambda:* permissions to THIS function only.
output "get_visitor_count_function_arn" {
    value = aws_lambda_function.get_visitor_count.arn
}

#Same purpose as above in "get_visitor_count_function_arn", for the write-only function.
output "increment_visitor_count_function_arn" {
    value = aws_lambda_function.increment_visitor_count.arn
}

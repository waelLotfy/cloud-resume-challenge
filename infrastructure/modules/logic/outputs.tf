# Outputs exposed by the logic module for use by the environment root
# module (infrastructure/environments/prod/main.tf).
#

output "get_visitor_count_function_name" {
  value = aws_lambda_function.get_visitor_count.function_name
}

output "get_visitor_count_invoke_arn" {
  value = aws_lambda_function.get_visitor_count.invoke_arn  # Needed by API Gateway in the next step
}

output "increment_visitor_count_function_name" {
  value = aws_lambda_function.increment_visitor_count.function_name
}

output "increment_visitor_count_invoke_arn" {
  value = aws_lambda_function.increment_visitor_count.invoke_arn  # Needed by API Gateway in the next step
}

output "api_endpoint" {
  value = aws_apigatewayv2_api.visitor_count_api.api_endpoint   # The base URL - e.g. https://xxxx.execute-api.eu-central-1.amazonaws.com
}
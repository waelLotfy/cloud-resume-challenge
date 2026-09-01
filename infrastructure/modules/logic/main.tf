# Logic Tier Module
#
# Provisions the API/compute resources for the resume backend:
#   - API Gateway (HTTP or REST API)
#   - Lambda function(s)
#   - IAM execution role(s) for Lambda
#
# This module does not reference other tiers directly (e.g. it does not
# hardcode the DynamoDB table name/ARN from the data module). Any values
# needed from other tiers are passed in as input variables by
# infrastructure/environments/prod/main.tf.
#
# No VPC configuration is used for the Lambda functions — this project
# communicates with AWS managed services over public/managed endpoints
# using IAM auth, by design.
#
# NOTE: This is a placeholder scaffold. Resource arguments must be
# completed once requirements (docs/requirements/) and the architecture
# (docs/architecture/architecture-overview.md) are finalized.

# TODO: aws_iam_role for Lambda execution
# resource "aws_iam_role" "lambda_execution" {
# }

# TODO: aws_iam_role_policy / aws_iam_role_policy_attachment (least privilege)
# resource "aws_iam_role_policy" "lambda_execution" {
# }

# TODO: aws_lambda_function
# resource "aws_lambda_function" "api" {
# }

# TODO: aws_apigatewayv2_api / aws_api_gateway_rest_api
# resource "aws_apigatewayv2_api" "api" {
# }

# TODO: aws_apigatewayv2_integration + aws_apigatewayv2_route wiring API Gateway to Lambda
# resource "aws_apigatewayv2_integration" "lambda" {
# }

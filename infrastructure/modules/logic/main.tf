terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.36.0"
    }
  }
}
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

# ============================================================
# Package each Lambda's Python code into a zip file.
# archive_file is a data source (reads/computes something), not a
# resource (creates something in AWS) - it runs locally to build
# the zip Terraform will then upload to Lambda.
# ============================================================

data "archive_file" "get_visitor_count_zip" {
  type        = "zip"                                                               # The archive_file data source can create a zip or tar file from a directory of files, so this is format lambda expects.
  source_dir  = "${path.module}/../../../backend/functions/get_visitor_count"     # The directory containing the Lambda function's code handler.py. This is relative to the module's main.tf file.
  output_path = "${path.module}/../../../backend/functions/get_visitor_count.zip" # The path where the zip file will be written. This is relative to the module's main.tf file.

  # Pin file modes so Windows and Linux produce the same zip (and the same hash).
  output_file_mode = "0666"

  # Keep local-only build artifacts out of the package.
  excludes = ["**/__pycache__/**", "**/*.pyc"]
}

data "archive_file" "increment_visitor_count_zip" {
  type        = "zip"                                                                     # The archive_file data source can create a zip or tar file from a directory of files, so this is format lambda expects.
  source_dir  = "${path.module}/../../../backend/functions/increment_visitor_count"     # The directory containing the Lambda function's code handler.py. This is relative to the module's main.tf file.
  output_path = "${path.module}/../../../backend/functions/increment_visitor_count.zip" # The path where the zip file will be written. This is relative to the module's main.tf file.

  # Pin file modes so Windows and Linux produce the same zip (and the same hash).
  output_file_mode = "0666"

  # Keep local-only build artifacts out of the package.
  excludes = ["**/__pycache__/**", "**/*.pyc"]
}

# ============================================================
# Trust policy - WHO is allowed to assume these roles.
# Identical for both functions: only the Lambda service itself may
# use these roles. This grants NO permissions by itself.
# ============================================================
# Terraform's aws_iam_policy_document data source generates valid IAM JSON and helps prevent manual JSON mistakes.
# Important concept: IAM roles have two parts: a trust policy (who can assume the role) and a permissions policy (what actions the role can perform). The trust policy is defined here, and the permissions policy is defined later for each Lambda function.
# Trust policy (assume_role_policy) — answers "WHO is allowed to use this role?" For a Lambda function, the answer is always the same: "the Lambda service itself" (lambda.amazonaws.com). This grants zero permissions by itself — it's purely "AWS Lambda is allowed to act as this role."
data "aws_iam_policy_document" "lambda_trust_policy" {
  statement {
    effect = "Allow"                          # The Lambda service itself is allowed to assume this role, so allow (not Deny) this trust relationship..
    actions = ["sts:AssumeRole"]              # The action being trusted: assuming the role.

    principals {
      type = "Service"                        # The principal (who is allowed to assume the role) (trusted entry) is a service, not a user or account.
      identifiers = ["lambda.amazonaws.com"]  # The identifier for the Lambda service.
    }

  }
}


# ============================================================
# GetVisitorCount - IAM role and its READ-ONLY permissions
# ============================================================
resource "aws_iam_role" "get_visitor_count_role" {
  name               = "get-visitor-count-lambda-role"                               # The real AWS name of the IAM role to create. This is the name that will appear in the AWS console.
  assume_role_policy = data.aws_iam_policy_document.lambda_trust_policy.json  #
  tags = var.tags
}

# Permissions policy — answers "once assumed, WHAT can this role actually do?" This is where your dynamodb:GetItem vs dynamodb:UpdateItem split actually lives.
data "aws_iam_policy_document" "get_visitor_count_permissions" {
  statement {
    effect = "Allow"                 # Allow this action, not Deny it.
    actions = [ "dynamodb:GetItem"]  # The Lambda function "get_visitor_count" will only read the visitor count from DynamoDB, so only allow the GetItem action - nothing else.
    resources = [var.table_arn]      # The ARN of the DynamoDB table to which this permission applies.
  }
}

resource "aws_iam_role_policy" "get_visitor_count_policy" {
  name   = "get-visitor-count-dynamodb-read"       # The real AWS name of this inline IAM policy to create. This is the name that will appear in the AWS console.
  role   = aws_iam_role.get_visitor_count_role.id  # Attach it to the GET role.
  policy = data.aws_iam_policy_document.get_visitor_count_permissions.json  # The JSON policy document.
}

# Baseline CloudWatch logging permission (AWS-managed, logging-only scope)
resource "aws_iam_role_policy_attachment" "get_visitor_count_logs" {
  role       = aws_iam_role.get_visitor_count_role.name                           # The IAM role used by the Lambda function.
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# ============================================================
# IncrementVisitorCount - IAM role and its WRITE-ONLY permissions
# ============================================================
resource "aws_iam_role" "increment_visitor_count_role" {
  name = "increment-visitor-count-lambda-role"   # The real AWS name of the IAM role to create. This is the name that will appear in the AWS console.
  assume_role_policy = data.aws_iam_policy_document.lambda_trust_policy.json #Same trust policy reused as the GET role, because it's also a Lambda function.
  tags = var.tags
}

data "aws_iam_policy_document" "increment_visitor_count_permissions" {
  statement {
    effect = "Allow"                    # Allow this action, not Deny it.
    actions = [ "dynamodb:UpdateItem"]  # The Lambda function "increment_visitor_count" will only write the visitor count to DynamoDB - cannot read , cannot delete, so only allow the UpdateItem action - nothing else.
    resources = [var.table_arn]         # The ARN of the DynamoDB table to which this permission applies.
  }
}

resource "aws_iam_role_policy" "increment_visitor_count_policy" {
  name   = "increment-visitor-count-dynamodb-write"                               # The real AWS name of this inline IAM policy to create. This is the name that will appear in the AWS console.
  role   = aws_iam_role.increment_visitor_count_role.id                           # Attach it to the UPDATE role.
  policy = data.aws_iam_policy_document.increment_visitor_count_permissions.json  # The JSON policy document.
}

# Baseline CloudWatch logging permission (AWS-managed, logging-only scope)
resource "aws_iam_role_policy_attachment" "increment_visitor_count_logs" {
  role = aws_iam_role.increment_visitor_count_role.name                     # The IAM role used by the Lambda function.
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# ============================================================
# The two Lambda functions themselves
# ============================================================

resource "aws_lambda_function" "get_visitor_count" {
  function_name = "get-visitor-count"              # The real AWS name of the Lambda function to create. This is the name that will appear in the AWS console.
  role = aws_iam_role.get_visitor_count_role.arn   # The IAM role that this Lambda function will assume when it runs. Its scoped, read-only permissions are defined above.
  handler = "handler.lambda_handler"               # The entry point for the Lambda function/file AWS should call. This is the name of the Python file (without .py) and the function within that file.
  runtime = "python3.12"                           # The Python runtime version to use for this Lambda function.
  filename = data.archive_file.get_visitor_count_zip.output_path # The path to the zip file containing the Lambda function's code to deploy, built by the archive_file data source above.
  source_code_hash = data.archive_file.get_visitor_count_zip.output_base64sha256 # The SHA256 hash of the zip file, used by Terraform to detect code changes and trigger updates.

  environment {
    variables = {
      TABLE_NAME = var.table_name  # Pass the DynamoDB table name to the Lambda function (python code) as an environment variable os.environ["TABLE_NAME"].
    }
  }
  tags = var.tags
}

resource "aws_lambda_function" "increment_visitor_count" {
  function_name = "increment-visitor-count"              # The real AWS name of the Lambda function to create. This is the name that will appear in the AWS console.
  role          = aws_iam_role.increment_visitor_count_role.arn
  handler       = "handler.lambda_handler"               # The entry point for the Lambda function/file AWS should call. This is the name of the Python file (without .py) and the function within that file.
  runtime = "python3.12"                           # The Python runtime version to use for this Lambda function.
  filename = data.archive_file.increment_visitor_count_zip.output_path # The path to the zip file containing the Lambda function's code to deploy, built by the archive_file data source above.
  source_code_hash = data.archive_file.increment_visitor_count_zip.output_base64sha256 # The SHA256 hash of the zip file, used by Terraform to detect code changes and trigger updates.

  environment {
    variables = {
      TABLE_NAME = var.table_name  # Pass the DynamoDB table name to the Lambda function (python code) as an environment variable os.environ["TABLE_NAME"].
    }
  }
  tags = var.tags
}

#One aws_apigatewayv2_api (HTTP API, the modern lightweight option — simpler than the older REST API type for
#this use case), with two routes: GET /visitorCount and POST /visitorCount/increment, each with its own
#aws_apigatewayv2_integration wiring to the matching Lambda.
#Main Steps:
#1-Create the API Gateway resource (aws_apigatewayv2_api)
#2-Create the two routes (aws_apigatewayv2_route) (HTTP method + path) for the two Lambda functions
#3-Create the two integrations (aws_apigatewayv2_integration) for the two Lambda functions with the API Gateway using the "AWS_PROXY" integration type.
#4-Payload format: For AWS_PROXY integration, the Lambda function receives the full request and must return a response in the expected format (statusCode, headers, body).
#5-Stage: Create a stage (aws_apigatewayv2_stage) to deploy the API Gateway, and set auto-deploy to true for automatic deployment on changes. This makes the API Gateway live and accessible via its invoke URL and gives the base path that gets prepended to every route.
#6- target = "integration/${id}" in the aws_apigatewayv2_route resource to link the route to the integration.

# ============================================================
# API Gateway (HTTP API) - the public entry point for both routes
# ============================================================
resource "aws_apigatewayv2_api" "visitor_count_api" {
  name          = "visitor-count-api" # Real AWS name for this API
  protocol_type = "HTTP"              # HTTP API (not the older REST API type)
  tags          = var.tags
}

# ------------------------------------------------------------
# Integration + route: GET /visitorCount -> GetVisitorCount Lambda
# ------------------------------------------------------------
resource "aws_apigatewayv2_integration" "get_visitor_count_integration" {
  api_id           = aws_apigatewayv2_api.visitor_count_api.id    # Which API this belongs to
  integration_type = "AWS_PROXY"                                  # Hand the whole request to Lambda
  integration_uri  = aws_lambda_function.get_visitor_count.invoke_arn    # Which Lambda to call
  payload_format_version = "2.0"                                  # Use the modern payload format for Lambda proxy integration. Current, simpler event format
}

resource "aws_apigatewayv2_route" "get_visitor_count_route" {
  api_id    = aws_apigatewayv2_api.visitor_count_api.id
  route_key = "GET /visitorCount" ## Exact method + path clients will call
  target    = "integrations/${aws_apigatewayv2_integration.get_visitor_count_integration.id}"
}

# ------------------------------------------------------------
# Integration + route: POST /visitorCount/increment -> IncrementVisitorCount Lambda
# ------------------------------------------------------------
resource "aws_apigatewayv2_integration" "increment_visitor_count_integration" {
  api_id           = aws_apigatewayv2_api.visitor_count_api.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.increment_visitor_count.invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "increment_visitor_count_route" {
  api_id    = aws_apigatewayv2_api.visitor_count_api.id
  route_key = "POST /visitorCount/increment"
  target    = "integrations/${aws_apigatewayv2_integration.increment_visitor_count_integration.id}"
}

# ------------------------------------------------------------
# Stage - makes the API actually reachable at a real URL.
# "$default" is API Gateway's special stage name meaning
# "no extra path prefix" - the URL is just <api-url>/visitorCount,
# not <api-url>/prod/visitorCount.
# ------------------------------------------------------------
resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.visitor_count_api.id
  name        = "$default" # Special stage name meaning "no extra path prefix"
  auto_deploy = true       # Automatically deploy changes to the API without manual deployment steps. Every change to routes/integrations goes live automatically.

  tags = var.tags
}

# ============================================================
# Resource-based permissions: allow API Gateway to INVOKE each
# Lambda. This is separate from the execution role permissions
# above - those control what the Lambda can DO once running;
# this controls WHO is allowed to trigger it in the first place.
# ============================================================
resource "aws_lambda_permission" "allow_apigw_get_visitor_count" {
  statement_id = "AllowAPIGatewayInvokeGet" # Unique identifier/label for this permission statement/entry. Must be unique per Lambda function.
  action        = "lambda:InvokeFunction"   # The action being allowed: invoking the Lambda function.
  function_name = aws_lambda_function.get_visitor_count.function_name # The Lambda function to which this permission applies.
  principal     = "apigateway.amazonaws.com" # The principal (who is allowed(trusted) to invoke the Lambda) is API Gateway service.
  # Restrict this permission to ONLY this specific API Gateway,
  # not "any API Gateway in the account" - same scoping pattern
  # as the CloudFront SourceArn condition on the S3 bucket policy.
  source_arn = "${aws_apigatewayv2_api.visitor_count_api.execution_arn}/*/*" # The ARN of the API Gateway that is allowed to invoke this Lambda function. The /*/* means "any route and any method" under this API.
}

resource "aws_lambda_permission" "allow_apigw_increment_visitor_count" {
  statement_id = "AllowAPIGatewayInvokeIncrement" # Unique identifier/label for this permission statement/entry. Must be unique per Lambda function.
  action        = "lambda:InvokeFunction"          # The action being allowed: invoking the Lambda function.
  function_name = aws_lambda_function.increment_visitor_count.function_name # The Lambda function to which this permission applies.
  principal     = "apigateway.amazonaws.com" # The principal (who is allowed(trusted) to invoke the Lambda) is API Gateway service.
  source_arn = "${aws_apigatewayv2_api.visitor_count_api.execution_arn}/*/*" # The ARN of the API Gateway that is allowed to invoke this Lambda function. The /*/* means "any route and any method" under this API.
}

# Input variables for the logic module (API Gateway, Lambda, IAM).
#
# Placeholder scaffold — populate once requirements/architecture are final.

# TODO: variable "function_name" { type = string }
# TODO: variable "lambda_source_dir" { type = string }
variable "table_name" {
  description = "Name of the DynamoDB table, passed to both Lambdas as an environment variable."
  type = string
}  # passed in from the data module's output via the root module

variable "table_arn" {
  description = "ARN of the DynamoDB table, used to scope each Lambda's IAM permissions to this table only."
  type = string
}
variable "tags" {
  description = "Tags applied to the IAM roles and Lambda functions created by the logic module."
  type = map(string)
  default = {}
}

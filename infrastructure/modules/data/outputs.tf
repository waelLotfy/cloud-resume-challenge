# Outputs exposed by the data module for use by the environment root
# module (infrastructure/environments/prod/main.tf). The logic module
# consumes these only indirectly, via variables passed in by the root
# module — never by referencing this module directly.

# Consumed by modules/logic: passed to both Lambdas as the
# TABLE_NAME environment variable, so handler.py never hardcodes it.
output "table_name" {
  description = "Name of the DynamoDB table storing the visitor count."
  value = aws_dynamodb_table.visitor_count.name
}

# Consumed by modules/logic: scopes each Lambda's IAM policy to
# THIS table only (GetItem-only / UpdateItem-only).
# Also consumed by modules/cicd: scopes the GitHub Actions role's
# DynamoDB permissions to this table only.
output "table_arn" {
  description = "ARN of the DynamoDB table storing the visitor count."
  value = aws_dynamodb_table.visitor_count.arn # It is needed for the granular IAM policies on your two Lambda functions — each function's policy will say "allow this action, but only on this specific table_arn," not "on any DynamoDB table."
}

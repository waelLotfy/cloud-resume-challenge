# Outputs exposed by the data module for use by the environment root
# module (infrastructure/environments/prod/main.tf). The logic module
# consumes these only indirectly, via variables passed in by the root
# module — never by referencing this module directly.


output "table_name" {
  description = "Name of the DynamoDB table storing the visitor count."
  value = aws_dynamodb_table.visitor_count.name
}
output "table_arn" {
  description = "ARN of the DynamoDB table storing the visitor count."
  value = aws_dynamodb_table.visitor_count.arn # It is needed for the granular IAM policies on your two Lambda functions — each function's policy will say "allow this action, but only on this specific table_arn," not "on any DynamoDB table."
}

# Data Tier Module
#
# Provisions the persistence resources for the resume backend:
#   - DynamoDB table(s)
#
# This module does not reference other tiers directly. Any identifiers
# needed by other tiers (e.g. table name/ARN for the logic module's IAM
# policy) are exposed via outputs.tf and wired explicitly by
# infrastructure/environments/prod/main.tf.

# DynamoDB table for storing visitor count
resource "aws_dynamodb_table" "visitor_count" {
  name         = var.table_name
  billing_mode = var.billing_mode
  hash_key = "id"

  attribute {
    name = "id"
    type = "S"
  }
  tags         = var.tags
}

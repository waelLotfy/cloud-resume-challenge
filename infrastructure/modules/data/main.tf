# Data Tier Module
#
# Provisions the persistence resources for the resume backend:
#   - DynamoDB table(s)
#
# This module does not reference other tiers directly. Any identifiers
# needed by other tiers (e.g. table name/ARN for the logic module's IAM
# policy) are exposed via outputs.tf and wired explicitly by
# infrastructure/environments/prod/main.tf.
#
# NOTE: This is a placeholder scaffold. Resource arguments must be
# completed once requirements (docs/requirements/) and the architecture
# (docs/architecture/architecture-overview.md) are finalized.

# TODO: aws_dynamodb_table
# resource "aws_dynamodb_table" "table" {
# }

# Remote state backend configuration for the "prod" environment.
#
# NOTE: This is a placeholder scaffold. Backend configuration (e.g. S3
# bucket + DynamoDB lock table for remote state) must be completed once
# the state-storage strategy is decided.

# TODO: terraform {
#   backend "s3" {
#     bucket         = "<TBD>"
#     key            = "prod/terraform.tfstate"
#     region         = "<TBD>"
#     dynamodb_table = "<TBD>"
#     encrypt        = true
#   }
# }

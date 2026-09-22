# Terraform / provider configuration for the "prod" environment.
#
# No VPC is configured anywhere in this project — all AWS services are
# accessed via public/managed endpoints with IAM auth, by design.
#
# NOTE: This is a placeholder scaffold. Provider/version constraints must
# be completed once the Terraform/AWS provider versions are decided.

# TODO: terraform {
#   required_version = ">= <TBD>"
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> <TBD>"
#     }
#   }
# }
# ---------------------------------------------------------
# AWS provider configuration
# This tells Terraform which cloud and which region to use.
# This MUST live only in the root module.
# ---------------------------------------------------------
provider "aws" {
   region = var.aws_region
   profile = var.aws_profile
}

# The ACM certificate for CloudFront must be requested in us-east-1
# regardless of the region used for other resources.
# TODO: provider "aws" {
#   alias  = "us_east_1"
#   region = "us-east-1"
# }

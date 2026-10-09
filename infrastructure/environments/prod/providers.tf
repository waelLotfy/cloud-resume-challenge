# Terraform / provider configuration for the "prod" environment.
#
# No VPC is configured anywhere in this project — all AWS services are
# accessed via public/managed endpoints with IAM auth, by design.
#
terraform {
   required_providers {
      # Our existing aws provider entry stays exactly as it is
      aws = {
         source = "hashicorp/aws"  # Where Terraform downloads the AWS plugin from
         version = "6.36.0"        # Exact pin, matching your original setup
      }

      # The archive provider, needed by the archive_file data source
      archive = {
         source = "hashicorp/archive" # Where Terraform downloads the archive plugin from
         version = "~> 2.4"            # Any 2.x version from 2.4 up, but never 3.0+
      }

      tls = {
         source = "hashicorp/tls"     # Where Terraform downloads the TLS plugin from
         version = "~> 4.0"            # Any 4.x version, but never 5.0+
      }
   }
}
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

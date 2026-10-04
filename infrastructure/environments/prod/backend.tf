# Remote state backend configuration for the "prod" environment.
#
# Backend configuration (e.g. S3 # bucket for remote state)

terraform {
  backend "s3" {
  bucket         = "wael-crc-terraform-state"
  key            = "prod/terraform.tfstate"   # Path within the bucket for this environment's state
  region         = "eu-central-1"
  profile        = "cloud-resume"   # Backend blocks can't use variables - must be hardcoded here
  use_lockfile   = true                       # Native S3 locking - no separate DynamoDB table needed
  }
}

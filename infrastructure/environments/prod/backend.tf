# Remote state backend configuration for the "prod" environment.
#
# Backend configuration (e.g. S3 # bucket for remote state)

terraform {
  backend "s3" {
    bucket = "wael-crc-terraform-state"
    key    = "prod/terraform.tfstate" # Path within the bucket for this environment's state
    region = "eu-central-1"
    #profile        = "cloud-resume"   # Backend blocks can't use variables - must be hardcoded here
    # profile intentionally omitted here - supplied separately at
    # `terraform init` time, since it differs between local use
    # (a named AWS CLI profile) and CI (ambient OIDC credentials,
    # no profile at all).
    use_lockfile = true # Native S3 locking - no separate DynamoDB table needed
  }
}
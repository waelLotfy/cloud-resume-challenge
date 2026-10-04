# ============================================================
# Bootstrap: creates the S3 bucket that stores Terraform state
# for environments/prod. This configuration's OWN state stays
# local, since the bucket it creates cannot be used to store the
# state of its own creation - this is a one-time, rarely-changed
# exception to the project's general "no local state" rule.
# ============================================================

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.36.0"
    }
  }
}

provider "aws" {
    region  = var.aws_region
    profile = var.aws_profile
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = var.state_bucket_name
  tags   = var.tags
}

# Encryption at rest - SSE-S3 (AWS-managed keys). Addresses the
# risk that state files can contain sensitive values (ARNs,
# resource IDs, and depending on the resources involved,
# connection details or secrets).
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_encryption" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Versioning - if the state file is ever overwritten with something
# unexpectedly wrong, a previous version remains recoverable.
resource "aws_s3_bucket_versioning" "terraform_state_versioning" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Block all public access - this bucket should never be reachable
# by anyone outside explicitly granted IAM principals.
# Block all public access - this bucket should never be reachable
# by anyone outside explicitly granted IAM principals.
resource "aws_s3_bucket_public_access_block" "terraform_state_block" {
  bucket = aws_s3_bucket.terraform_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# IAM restriction - explicitly scope access to only the principals
# that should ever read or write this state: your own IAM user/role,
# and (once created) the GitHub Actions OIDC role. Anyone else in
# the account, even with broad S3 permissions elsewhere, is denied
# access to THIS specific bucket.
data "aws_iam_policy_document" "terraform_state_access" {
  statement {
    sid     = "AllowStateAccessToAuthorizedPrincipals"
    effect  = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:ListBucket"
    ]
    resources = [
      aws_s3_bucket.terraform_state.arn,
      "${aws_s3_bucket.terraform_state.arn}/*"
    ]
    principals {
      type        = "AWS"
      identifiers = var.authorized_principal_arns # Your IAM user now; + the GitHub OIDC role once it exists
    }
  }
}

resource "aws_s3_bucket_policy" "terraform_state_policy" {
  bucket = aws_s3_bucket.terraform_state.id
  policy = data.aws_iam_policy_document.terraform_state_access.json

}
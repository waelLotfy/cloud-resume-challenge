terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.36.0"
    }
  }
}
# ============================================================
# Fetch GitHub's current TLS certificate thumbprint - required
# by AWS to verify that OIDC tokens are genuinely signed by
# GitHub's identity provider, not forged.
# ============================================================
 data "tls_certificate" "github" {
   url = "https://token.actions.githubusercontent.com"
 }

# ============================================================
# Register GitHub's OIDC provider as a trusted identity source.
# Note: an AWS account can only have ONE OIDC provider per issuer
# URL. If this project ever shares an account with another
# GitHub-connected project, this resource would already exist
# and should be imported rather than recreated.
# ============================================================
resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com" # The issuer URL for GitHub's OIDC provider.This is GitHub's OIDC service.
  client_id_list = ["sts.amazonaws.com"]              # The only client ID that AWS supports for OIDC providers. STS is the AWS service that issues temporary credentials when GitHub assumes your deployment role.
  thumbprint_list = [data.tls_certificate.github.certificates[0].sha1_fingerprint] # GitHub's current TLS certificate thumbprint, fetched above

  tags = var.tags

}

# ============================================================
# Trust policy: WHO can assume this role. Restricted to tokens
# whose claims prove they came from this exact repository and
# branch - not "any GitHub Actions workflow anywhere."
# ============================================================
data "aws_iam_policy_document" "github_actions_trust" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated" # The principal type is "Federated" for OIDC providers.
      identifiers = [aws_iam_openid_connect_provider.github.arn] # The ARN of the OIDC provider we just created. This tells AWS that tokens issued by this provider are allowed to assume the role.
    }

    # The audience claim - always "sts.amazonaws.com" for this use case.
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    # The subject claim - restricts this role to ONLY this repo,
    # and ONLY the main branch. StringLike (not StringEquals) allows
    # the wildcard-free exact match here, but also supports patterns
    # like pull_request events if extended later.
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${var.github_repo}:ref:refs/heads/${var.github_branch}"]
    }
  }
}

resource "aws_iam_role" "github_actions" {
  name               = "github-actions-cloud-resume-deploy"
  assume_role_policy = data.aws_iam_policy_document.github_actions_trust.json
  tags               = var.tags
}

# ============================================================
# Permissions policy - service-scoped, not per-action.
# Broader than the Lambda execution roles elsewhere in this
# project, deliberately: this role only ever runs reviewed
# Terraform code, gated behind manual approval - a different
# risk profile than code reachable by public internet traffic.
# ============================================================
data "aws_iam_policy_document" "github_actions_permissions" {
  # Terraform state bucket access.
  statement {
    sid     = "StateBucketAccess"
    effect  = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:ListBucket",
      "s3:DeleteObject", # required to release the lock file
    ]
    resources = [
      var.state_bucket_arn,
      "${var.state_bucket_arn}/*",
    ]
  }

  # The resume content bucket - read/write for both Terraform and
  # the frontend deploy step's `aws s3 sync`.
  statement {
    sid     = "ResumeBucketAccess"
    effect  = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:ListBucket"
    ]
    resources = [
      var.resume_bucket_arn,
      "${var.resume_bucket_arn}/*",
    ]
  }

  # CloudFront - manage the distribution, and invalidate its cache
  # after a frontend deploy.
  statement {
    sid     = "CloudFrontAccess"
    effect  = "Allow"
    actions = [
      "cloudfront:GetDistribution",
      "cloudfront:UpdateDistribution",
      "cloudfront:CreateInvalidation",
      "cloudfront:GetInvalidation",
    ]
    resources = [var.cloudfront_distribution_arn]
  }

  # DynamoDB table management.
  statement {
    sid     = "DynamoDBTableAccess"
    effect  = "Allow"
    actions = [
      "dynamodb:*" ]
    resources = [var.dynamodb_table_arn]
  }

  # Lambda function management, scoped to this project's two functions.
  statement {
      sid     = "LambdaFunctionAccess"
      effect  = "Allow"
      actions = [
      "lambda:*" ]
      resources = var.lambda_function_arns
  }

  # API Gateway management, scoped to this project's one API.
  statement {
      sid     = "APIGatewayAccess"
      effect  = "Allow"
      actions = [
      "apigateway:*" ]
      resources = ["${var.api_gateway_execution_arn}/*"]
  }

  # IAM: Terraform needs to manage the Lambda execution roles
  # THEMSELVES as resources (create/update/delete), scoped to only
  # role names this project actually uses - not IAM in general.
    statement {
        sid     = "ManageLambdaExecutionRoles"
        effect  = "Allow"
        actions = [
        "iam:CreateRole",
        "iam:DeleteRole",
        "iam:GetRole",
        "iam:AttachRolePolicy",
        "iam:DetachRolePolicy",
        "iam:PutRolePolicy",
        "iam:DeleteRolePolicy",
        "iam:GetRolePolicy",
        "iam:TagRole",]
        resources = var.lambda_execution_role_arns
    }

    # PassRole: required specifically because creating/updating a
    # Lambda function with an execution role requires explicit
    # permission to hand that role to the Lambda SERVICE - this is
    # separate from managing the role itself, above.
    statement {
        sid     = "PassLambdaExecutionRoles"
        effect  = "Allow"
        actions = [
        "iam:PassRole"]
        resources = var.lambda_execution_role_arns

        condition {
          test     = "StringEquals"
          variable = "iam:PassedToService"
          values = ["lambda.amazonaws.com"]
        }
    }
}

resource "aws_iam_role_policy" "github_actions_permissions" {
  name  = "github-actions-deploy-permissions"
  role   = aws_iam_role.github_actions.id
  policy = data.aws_iam_policy_document.github_actions_permissions.json
}

# ============================================================
# NEW: trust policy for the plan-only role. The subject claim
# shape for a pull_request event is DIFFERENT from a push event -
# there is no branch reference, since a PR can come from any
# branch. This is a SEPARATE trust policy, not a modification of
# the existing one, specifically so the deploy role (which has
# real write access) can never be assumed by a PR-triggered run.
# ============================================================
data "aws_iam_policy_document" "github_actions_plan_trust" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn] # Reuses the SAME provider - only one OIDC provider per issuer is allowed per account
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    # The pull_request subject shape - no branch, unlike the push-based role.
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${var.github_repo}:pull_request"]
    }
  }
}

resource "aws_iam_role" "github_actions_plan" {
  name = "github-actions-cloud-resume-plan"
  assume_role_policy = data.aws_iam_policy_document.github_actions_plan_trust.json
  tags = var.tags
}

# AWS-managed, strictly read-only across the whole account. Broad
# in scope, but contains NO write, delete, or mutate actions of
# any kind - chosen deliberately over a hand-enumerated action
# list, which would be fragile against future resource types and
# still carry real risk if it ever included even one write action
# by mistake. Since this role is assumable by untrusted PR code,
# "cannot mutate anything, full stop" is the property that matters.
resource "aws_iam_role_policy_attachment" "github_actions_plan_read_only" {
  role       = aws_iam_role.github_actions_plan.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

# The one necessary exception to "read-only": terraform plan still
# acquires and releases the S3 native lock during its run. Scoped
# to ONLY the lock file object, not the real state file's content -
# this role can never overwrite or delete actual state.
data "aws_iam_policy_document" "github_actions_plan_lock_access" {
  statement {
    sid     = "StateLockFileAccess"
    effect  = "Allow"
    actions = [
      "s3:PutObject",
      "s3:DeleteObject",
    ]
    resources = ["${var.state_bucket_arn}/${var.state_lock_key}"]
  }
}

resource "aws_iam_role_policy" "github_actions_plan_lock_access" {
  name = "github-actions-plan-lock-access"
  role   = aws_iam_role.github_actions_plan.id
  policy = data.aws_iam_policy_document.github_actions_plan_lock_access.json
}

# Temporary workflow test version 2

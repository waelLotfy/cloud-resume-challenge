# Outputs exposed by the presentation module for use by the environment
# root module (infrastructure/environments/prod/main.tf). Other modules
# must not consume these directly.
#


# ---------------------------------------------------------
# Expose the bucket's ID so the root module or other modules
# can reference this bucket later (e.g., CloudFront origin).
# It is as if giving the bucket a "serial number".
# ---------------------------------------------------------
output "bucket_id" {
  # The bucket's own name/ID. Consumed by scripts/CI for `aws s3 sync`
  # targets, and by anything referencing the bucket by name rather
  # than ARN.
  value = aws_s3_bucket.resume_site.id
}

# ---------------------------------------------------------
# Expose the bucket's ARN (Amazon Resource Name).
# This is the bucket's "full legal identity" in AWS.
# Many AWS services require the ARN for permissions.
# ---------------------------------------------------------
#output "bucket_arn" {
# Historical/general-purpose ARN output - kept for backward
# compatibility with anything already referencing it.
# NOTE: if this already serves the same purpose as
# resume_bucket_arn below, keep only one - don't carry both.
#  value = aws_s3_bucket.resume_site.arn
#}

# Consumed by the frontend CI/CD workflow: required by
# `aws cloudfront create-invalidation --distribution-id ...`
# to bust the cache after deploying new site files.
output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.resume_cdn.id
}

# The live *.cloudfront.net URL. Consumed by: you, to open the
# site directly; later, the frontend CI/CD workflow if it needs
# to reference the URL; eventually Route 53 once DNS is set up.
output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.resume_cdn.domain_name
}

# Consumed by modules/cicd: scopes the GitHub Actions role's S3
# permissions to THIS bucket only, for the frontend deploy step's
# `aws s3 sync`.
output "resume_bucket_arn" {
  value = aws_s3_bucket.resume_site.arn
}

# Consumed by modules/cicd: scopes the GitHub Actions role's
# CloudFront permissions (specifically CreateInvalidation after
# a frontend deploy) to THIS distribution only.
output "cloudfront_distribution_arn" {
  value = aws_cloudfront_distribution.resume_cdn.arn
}
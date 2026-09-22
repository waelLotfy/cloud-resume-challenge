terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.36.0"
    }
  }
}
# Presentation Tier Module
#
# Provisions the static-hosting resources for the resume website:
#   - S3 bucket (origin for static assets)
#   - CloudFront distribution (CDN)
#   - ACM certificate (TLS for the custom domain)
#
# This module does not reference other tiers directly. All cross-tier
# wiring happens in infrastructure/environments/prod/main.tf.
#
# NOTE: This is a placeholder scaffold. Resource arguments must be
# completed once requirements (docs/requirements/) and the architecture
# (docs/architecture/architecture-overview.md) are finalized.

# aws_s3_bucket for static website assets
resource "aws_s3_bucket" "resume_site" {
  # The bucket name is NOT hardcoded.
  # It comes from the module input variable "bucket_name",
  # which the root module provides (prod, dev, staging, etc.)
  bucket = var.bucket_name
}

# --------------------------------------------------------------------
# Block ALL public access to the bucket (the security guard at the door)
# --------------------------------------------------------------------
resource "aws_s3_bucket_public_access_block" "resume_site_block" {
  # Attach this public-access-block to the bucket we just created.
  # It is as if assigning the security guard to the storage room.
  bucket                  = aws_s3_bucket.resume_site.id

  # Prevent anyone from making the bucket public using ACLs.
  # ACLs are an old permission system — we disable them completely.
  block_public_acls = true

  # Prevent bucket policies that try to make the bucket public.
  # Even if someone writes a policy that exposes the bucket,
  # this setting blocks it.
  block_public_policy = true

  # Ignore any ACLs that attempt to make objects public.
  # If someone tries to add a public ACL, Terraform/AWS will ignore it.
  ignore_public_acls = true

  # Do not allow this bucket to EVER become public.
  # This is the strongest protection — the bucket stays private forever.
  restrict_public_buckets = true

}

# TODO: aws_cloudfront_origin_access_control / origin access identity
# resource "aws_cloudfront_origin_access_control" "site" {
# }

# TODO: aws_cloudfront_distribution fronting the S3 bucket
# resource "aws_cloudfront_distribution" "site" {
# }

# TODO: aws_acm_certificate (validated via DNS, must be in us-east-1 for CloudFront)
# resource "aws_acm_certificate" "site" {
# }

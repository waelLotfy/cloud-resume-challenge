# The IAM role GitHub Actions assumes via OIDC. Consumed by: the
# GitHub Actions workflow YAML itself, passed to
# aws-actions/configure-aws-credentials as `role-to-assume`.
# Also consumed by: infrastructure/bootstrap's
# authorized_principal_arns, once added there, so this role can
# also read/write the Terraform state bucket.
output "github_actions_role_arn" {
  value       = aws_iam_role.github_actions.arn
}

output "github_actions_plan_role_arn" {
  # Consumed by the PR-triggered plan workflow ONLY - never the
  # deploy workflow. Read-only; cannot modify any AWS resource.
  value = aws_iam_role.github_actions_plan.arn
}

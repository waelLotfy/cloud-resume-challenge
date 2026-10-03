# Configuration Drift Policy

This document describes how configuration drift is detected and handled in this
project, and what is adopted vs. deliberately skipped from the Cloud Resume
Challenge's "Blueprint Drift" Solutions Architect mod.

## What is configuration drift, in this project's context?

Drift is any gap between what `infrastructure/` (Terraform) declares and what
actually exists in AWS - caused by a manual console change, a bypassed CI/CD
run, or a forgotten out-of-band edit. Since Terraform is this project's single
source of truth for every AWS resource, any such gap is unintended and should
be caught early, not discovered the next time someone runs `terraform apply`
and gets a surprising diff.

## What happens when drift is detected?

- **On a pull request that modifies `infrastructure/`:** a GitHub Actions
  workflow runs `terraform plan` and posts the output as a comment on the PR.
  Any planned change - expected or not - is visible to the reviewer before
  merge. The workflow does not apply anything; it only reports.
- **On a daily schedule, independent of any PR:** the same `terraform plan`
  check runs against the current state of `main`. This catches drift
  introduced by any means other than a PR - a manual console tweak, a change
  made directly via the AWS CLI, or an expired/rotated credential side effect.
  If this scheduled run shows a non-empty plan (any `~`, `+`, or `-` action)
  when nothing was intentionally changed, that is drift, and it should be
  investigated before the next real `apply` runs and potentially
  reverts or masks it.
- **`terraform apply` against prod only runs after manual approval** via a
  GitHub Environment protection rule - a human must review and approve the
  run, whether it was triggered by a merged PR or otherwise. There is no path
  where `apply` runs against prod unattended.

## Who approves changes?

Wael (project owner) reviews and approves every `apply` run via the GitHub
Environment approval gate. There is currently no team or second reviewer -
this is a personal project - but the approval step exists regardless, so the
habit and the pipeline shape match how a real team would operate.

## What's allowed manually vs. what must go through CI?

- **Nothing is made or changed manually in the AWS Console for resources
  Terraform manages** (S3, CloudFront, DynamoDB, Lambda, API Gateway, IAM
  roles/policies). Every change goes through a Terraform code change, reviewed
  via PR, applied via the pipeline with manual approval.
- **Read-only console use is always fine** - browsing resources to verify
  state, reading logs in CloudWatch, checking metrics. The rule is about
  *changing* things outside Terraform, not looking at them.
- **The one-time exception, already closed:** the very first manual
  `aws s3 sync` run (Chunk 1) and the Lambda console "Test" invocations
  (Chunk 2) were manual actions taken deliberately to verify the pipeline
  *before* CI/CD existed. Neither changed infrastructure - they invoked
  already-deployed resources or synced content, which is exactly the kind of
  action CI/CD now automates going forward.

## Adopted from the "Blueprint Drift" mod

- `terraform plan` check in GitHub Actions, triggered on every PR touching
  `infrastructure/`
- Plan output posted as a PR comment
- Daily scheduled `terraform plan` check, independent of PRs
- GitHub Environment protection requiring manual approval before `apply`
  against prod
- This document

## Deliberately skipped, and why

- **`cfn-drift-detection`** - CloudFormation-specific tooling; not applicable,
  since this project uses Terraform exclusively.
- **Slack / email notifications on drift** - adds an external service
  dependency (webhook setup, secret management) disproportionate to a
  personal project; a PR comment and the Actions run log already surface the
  same information where it's already being checked.
- **AWS Config + Steampipe dashboards** - AWS Config carries an ongoing
  per-resource recording cost and real setup overhead, and is built for
  auditing drift across large, multi-account environments. For a single
  AWS account where Terraform is already the sole source of truth, it is
  disproportionate. The book itself labels the Steampipe piece "Bonus."

# GitHub Actions to AWS Authentication via OIDC

## Purpose

This document describes how GitHub Actions workflows authenticate to AWS
without storing any long-lived credentials, and defines the core GitHub
Actions concepts used throughout the CI/CD pipeline for this project.

## Background: the problem with static credentials

A conventional approach to granting a CI pipeline access to a cloud account
is to generate a long-lived access key and secret, and store them as a CI
secret. This approach has a structural weakness: the credential is valid
indefinitely (until manually rotated) and reusable from anywhere. If it is
ever exposed - through a misconfigured log, a compromised dependency, or a
workflow misconfiguration - it remains a usable, standing credential until
someone notices and revokes it.

OpenID Connect (OIDC) federation removes this class of risk by removing the
stored credential entirely. No access key exists in the repository, in
GitHub's secret store, or on disk at any point. Each workflow run instead
authenticates using a token that is generated fresh for that run and expires
shortly afterward.

## The trust relationship

Three parties participate in this exchange: GitHub's OIDC identity provider,
the AWS account, and the individual workflow run.

**One-time configuration, established in advance:**

1. AWS is configured to trust GitHub's OIDC provider as a valid identity
   source (an OIDC identity provider resource in IAM).
2. An IAM role is created with a trust policy scoped to a specific
   repository and branch. The trust policy does not grant access to GitHub
   Actions in general - it grants access only to tokens whose claims match
   an exact repository and branch (for example,
   `repo:<org>/<repo>:ref:refs/heads/main`).

**On every workflow run:**

1. GitHub generates a signed identity token (a JSON Web Token) containing
   claims that identify the originating repository, branch, and workflow.
2. The workflow presents this token to AWS Security Token Service via
   `AssumeRoleWithWebIdentity`.
3. AWS verifies the token's signature against GitHub's public keys, and
   checks that its claims satisfy the trust policy's conditions.
4. If both checks pass, AWS issues temporary credentials scoped to the
   permissions attached to that IAM role. These credentials are valid only
   for the duration of the run and are discarded afterward.

The permissions available during a workflow run are bounded entirely by the
IAM role's own policy, following the same least-privilege principle applied
elsewhere in this project's IAM design: a role should grant only the
permissions its specific task requires, and nothing more.

## GitHub Actions concepts used in this pipeline

**Workflow file**
A YAML file located under `.github/workflows/`. Each file defines one
independent pipeline.

**Trigger (`on:`)**
Defines what causes a workflow to execute - for example, a push to a given
branch. Triggers can be restricted with `paths:` filters so that a workflow
only runs when files under a specific directory have changed, allowing a
single repository to maintain effectively independent pipelines for
different areas of the codebase.

**`permissions: id-token: write`**
Required for any job that authenticates via OIDC. By default, a job has no
permission to request an OIDC token; this must be explicitly declared, or
the authentication exchange described above cannot occur.

**Job, steps, and `runs-on`**
A job is an ordered sequence of steps executed on a freshly provisioned
virtual machine (`runs-on: ubuntu-latest`). Every job begins with a clean,
stateless environment - nothing persists from one run to the next.

**`actions/checkout`**
The standard first step in most jobs. Without it, the runner has no access
to the repository's files.

**`aws-actions/configure-aws-credentials`**
The AWS-maintained action that performs the OIDC token exchange described
above, given the target IAM role's ARN. Every subsequent step in the job can
then call AWS using the resulting temporary credentials.

**GitHub Environments and required reviewers**
A named environment (for example, `prod`) configured with a protection rule
requiring manual approval before a job referencing that environment may
proceed. This provides a built-in human-approval gate ahead of any action
that affects production infrastructure, without requiring any external
approval tooling.

## Scope

This document covers authentication and the GitHub Actions primitives used
to implement it. Pipeline-specific logic (build, test, deploy sequencing,
and drift detection) is documented separately.

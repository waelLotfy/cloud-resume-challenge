# Architecture Overview

Three-tier serverless architecture (Presentation / Logic / Data), with GitHub 
Actions handling CI/CD via OIDC-federated IAM roles.

<img width="949" height="1113" alt="ArchitecturalDesign" src="https://github.com/user-attachments/assets/fd752620-c3a7-4102-899a-cd85e69d349d" />


## V-Model Position

This document is the **Architecture** stage artifact of the V-Model SDLC,
sitting between Requirements (`docs/requirements/`) and Implementation
(`infrastructure/`, `frontend/`, `backend/`). Every architectural
component below must trace back to one or more functional/non-functional
requirements once those are written.

## Style

Three-tier serverless architecture on AWS, with no VPC — all services
communicate over AWS public/managed service endpoints and are secured via
IAM auth rather than network isolation. This is a deliberate architectural
choice, not an omission, and is recorded in
[`docs/decisions/`](../decisions/README.md).

## Tiers

### 1. Presentation Tier

- **Purpose:** Serves the static resume website to end users.
- **AWS Services:** Amazon S3 (static asset storage), Amazon CloudFront
  (CDN/edge distribution), AWS Certificate Manager (TLS certificate),
  Amazon Route 53 (DNS).
- **Terraform Module:** [`infrastructure/modules/presentation`](../../infrastructure/modules/presentation)
- **Related Requirements:** _TBD_

### 2. Logic Tier

- **Purpose:** Exposes an API that mediates between the presentation tier
  and the data tier.
- **AWS Services:** Amazon API Gateway, AWS Lambda, IAM execution roles
  for Lambda.
- **Terraform Module:** [`infrastructure/modules/logic`](../../infrastructure/modules/logic)
- **Related Requirements:** _TBD_

### 3. Data Tier

- **Purpose:** Persists application state (e.g. visitor counter).
- **AWS Services:** Amazon DynamoDB.
- **Terraform Module:** [`infrastructure/modules/data`](../../infrastructure/modules/data)
- **Related Requirements:** _TBD_

### Cross-Cutting Concerns

- **IAM:** Least-privilege roles/policies scoped per module; no shared
  broad-permission roles.
- **Observability:** Amazon CloudWatch (logs, metrics, alarms).
- **CI/CD:** GitHub Actions, authenticating to AWS via OIDC-federated IAM
  roles — no long-lived AWS credentials stored in source or secrets.

## Explicit Non-Goals

- No VPC, subnets, NAT gateways, or private networking of any kind.
- No long-lived IAM access keys/secrets in GitHub Actions.

## Module Boundaries

Modules under `infrastructure/modules/` do not reference each other
directly. Each module exposes inputs (`variables.tf`) and outputs
(`outputs.tf`) only; wiring between tiers happens explicitly in
[`infrastructure/environments/prod/main.tf`](../../infrastructure/environments/prod/main.tf).


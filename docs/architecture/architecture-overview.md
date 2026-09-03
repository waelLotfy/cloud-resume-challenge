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
- **Related Requirements:** [FR1](../requirements/functional-requirements.md#fr1-public-resume-access), [FR2](../requirements/functional-requirements.md#fr2-resume-written-in-html), [FR3](../requirements/functional-requirements.md#fr3-resume-styled-with-css), [FR4](../requirements/functional-requirements.md#fr4-static-website-hosting-on-s3), [FR5](../requirements/functional-requirements.md#fr5-https-for-the-static-website), [FR6](../requirements/functional-requirements.md#fr6-cloudfront-cdn-distribution), [FR7](../requirements/functional-requirements.md#fr7-custom-dns-domain-name), [FR8](../requirements/functional-requirements.md#fr8-domain-pointed-to-cloudfront), [FR9](../requirements/functional-requirements.md#fr9-route-53-as-dns-provider), [FR10](../requirements/functional-requirements.md#fr10-visitor-counter-display), [FR11](../requirements/functional-requirements.md#fr11-visitor-counter-implemented-in-javascript), [NFR1](../requirements/non-functional-requirements.md#nfr1-high-availability)

### 2. Logic Tier

- **Purpose:** Exposes an API that mediates between the presentation tier
  and the data tier.
- **AWS Services:** Amazon API Gateway, AWS Lambda, IAM execution roles
  for Lambda.
- **Terraform Module:** [`infrastructure/modules/logic`](../../infrastructure/modules/logic)
- **Related Requirements:** [FR14](../requirements/functional-requirements.md#fr14-api-gateway-and-lambda-mediate-data-access), [FR15](../requirements/functional-requirements.md#fr15-lambda-function-code-in-python), [FR16](../requirements/functional-requirements.md#fr16-automated-tests-for-lambda-code), [NFR7](../requirements/non-functional-requirements.md#nfr7-automated-backend-testing)

### 3. Data Tier

- **Purpose:** Persists application state (e.g. visitor counter).
- **AWS Services:** Amazon DynamoDB.
- **Terraform Module:** [`infrastructure/modules/data`](../../infrastructure/modules/data)
- **Related Requirements:** [FR12](../requirements/functional-requirements.md#fr12-dynamodb-stores-visitor-count)

### Cross-Cutting Concerns

- **IAM:** Least-privilege roles/policies scoped per module; no shared
  broad-permission roles.
- **Observability:** Amazon CloudWatch (logs, metrics, alarms).
- **CI/CD:** GitHub Actions, authenticating to AWS via OIDC-federated IAM
  roles — no long-lived AWS credentials stored in source or secrets.
- **Related Requirements:** [FR13](../requirements/functional-requirements.md#fr13-no-direct-client-to-dynamodb-communication), [FR17](../requirements/functional-requirements.md#fr17-infrastructure-as-code-for-api-resources), [FR18](../requirements/functional-requirements.md#fr18-terraform-as-the-iac-tool), [FR19](../requirements/functional-requirements.md#fr19-automated-cicd-for-updates), [FR20](../requirements/functional-requirements.md#fr20-backend-github-repository), [FR21](../requirements/functional-requirements.md#fr21-cicd-for-backend-code), [FR22](../requirements/functional-requirements.md#fr22-frontend-github-repository), [FR23](../requirements/functional-requirements.md#fr23-cicd-for-frontend-code), [FR24](../requirements/functional-requirements.md#fr24-automatic-cloudfront-cache-invalidation), [FR25](../requirements/functional-requirements.md#fr25-logging-to-cloudwatch), [NFR2](../requirements/non-functional-requirements.md#nfr2-free-tier-cost-constraint), [NFR3](../requirements/non-functional-requirements.md#nfr3-no-public-write-access-to-data), [NFR4](../requirements/non-functional-requirements.md#nfr4-no-credentials-in-source-control), [NFR5](../requirements/non-functional-requirements.md#nfr5-infrastructure-as-code), [NFR6](../requirements/non-functional-requirements.md#nfr6-gated-cicd-auto-deploy), [NFR8](../requirements/non-functional-requirements.md#nfr8-oidc-federated-cicd-authentication), [NFR9](../requirements/non-functional-requirements.md#nfr9-billing-alarm)

## Explicit Non-Goals

- No VPC, subnets, NAT gateways, or private networking of any kind.
- No long-lived IAM access keys/secrets in GitHub Actions.

## Module Boundaries

Modules under `infrastructure/modules/` do not reference each other
directly. Each module exposes inputs (`variables.tf`) and outputs
(`outputs.tf`) only; wiring between tiers happens explicitly in
[`infrastructure/environments/prod/main.tf`](../../infrastructure/environments/prod/main.tf).

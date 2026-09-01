# cloud-resume-challenge-private
This project is part of my journey in cloud engineering. After earing my AWS Solutions Architect Associate certification, I decided to apply my knowledge for building a fully serverless resume website using S3, Cloudfront, Lambda, DynamoDB, API Gateway, Route 53 and GitHub actions.

## Approach: V-Model SDLC

This project is built following a V-Model SDLC — Requirements →
Architecture → Implementation → Testing → Deployment → Documentation —
with full traceability from requirements through to tests, implemented
using GitHub-native tooling (Issues, PRs, commit conventions). See
[`docs/traceability/README.md`](./docs/traceability/README.md) for
details.

## Architecture

A three-tier serverless architecture on AWS, with **no VPC** — all
services communicate over AWS public/managed endpoints secured with IAM
auth, by design:

- **Presentation tier:** S3, CloudFront, ACM, Route 53
- **Logic tier:** API Gateway, Lambda, IAM execution roles
- **Data tier:** DynamoDB
- **Cross-cutting:** IAM, CloudWatch, CI/CD (GitHub Actions with OIDC —
  no long-lived AWS credentials in source)

See [`docs/architecture/architecture-overview.md`](./docs/architecture/architecture-overview.md)
for details.

## Repository Structure

| Directory | Purpose | V-Model Stage |
|-----------|---------|----------------|
| [`docs/`](./docs) | Requirements, architecture, ADRs, traceability | Requirements / Architecture |
| [`infrastructure/`](./infrastructure) | Terraform modules (presentation, logic, data) and environments | Architecture / Implementation |
| [`frontend/`](./frontend) | Static resume website (presentation tier) | Implementation |
| [`backend/`](./backend) | Lambda function source (logic tier) | Implementation |
| [`tests/`](./tests) | Unit, integration, and acceptance tests | Testing |
| [`.github/workflows/`](./.github/workflows) | CI/CD pipelines (GitHub Actions) | Deployment |
| [`scripts/`](./scripts) | Local dev / maintenance helper scripts | Cross-cutting |

## Status

This repository currently contains a project **scaffold** only —
directory structure and placeholder files establishing conventions and
traceability boundaries. No functional or non-functional requirements
have been authored yet; see [`docs/requirements/`](./docs/requirements)
for the templates to be filled in next.

## Contributing

See [`CONTRIBUTING.md`](./CONTRIBUTING.md) for the commit message
convention and requirement-traceability process.

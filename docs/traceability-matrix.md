# Requirements Traceability Matrix

This document provides end-to-end traceability for all requirements of the
Cloud Resume Challenge project across the V-Model SDLC:
`Requirement (FR / NFR)` → `Architecture` → `Implementation` → `Acceptance Criteria` → `Test Reference` → `Issue` → `Status`.

## V-Model Traceability Overview

In accordance with the project's V-Model lifecycle (see
[`docs/architecture/architecture-overview.md`](./architecture/architecture-overview.md)):
- **Left side (Decomposition):** Requirements ([`functional-requirements.md`](./requirements/functional-requirements.md)
  and [`non-functional-requirements.md`](./requirements/non-functional-requirements.md))
  define the system specifications and map directly to architectural tiers and
  implementation modules.
- **Right side (Integration & Verification):** Implementation artifacts map to
  acceptance criteria ([`acceptance-criteria.md`](./requirements/acceptance-criteria.md))
  and automated test suites under `tests/` or CI/CD workflow checks.
- **Unified Matrix:** Both Functional Requirements (FR1–FR25) and Non-Functional
  Requirements (NFR1–NFR9) are unified in a single matrix below to ensure symmetric
  rigor and to capture shared acceptance criteria (such as `AC-FR21-1` and `AC-FR23-1`
  shared across FRs and NFRs).

## Traceability Matrix

| ID | Type | Title | Tier/Component or Category | Related Architecture | Implementation | Acceptance Criteria | Test Reference | Tracked by (Issue) | Status |
|---|---|---|---|---|---|---|---|---|---|
| FR1 | Functional | Public resume access | Presentation | [Presentation Tier](architecture/architecture-overview.md#1-presentation-tier) | `infrastructure/modules/presentation`, `frontend/src` | [AC-FR4-1](requirements/acceptance-criteria.md#ac-fr4-1-public-site-returns-resume) | `tests/e2e/test_site_availability.py` | _TBD_ | Not started |
| FR2 | Functional | Resume written in HTML | Presentation | [Presentation Tier](architecture/architecture-overview.md#1-presentation-tier) | `frontend/src/index.html` | Self-evident — no dedicated AC | Gap — no AC/test defined | _TBD_ | Not started |
| FR3 | Functional | Resume styled with CSS | Presentation | [Presentation Tier](architecture/architecture-overview.md#1-presentation-tier) | `frontend/src/css/styles.css` | Self-evident — no dedicated AC | Gap — no AC/test defined | _TBD_ | Not started |
| FR4 | Functional | Static website hosting on S3 | Presentation | [Presentation Tier](architecture/architecture-overview.md#1-presentation-tier) | `infrastructure/modules/presentation` | [AC-FR4-1](requirements/acceptance-criteria.md#ac-fr4-1-public-site-returns-resume) | `tests/e2e/test_site_availability.py` | _TBD_ | Not started |
| FR5 | Functional | HTTPS for the static website | Presentation | [Presentation Tier](architecture/architecture-overview.md#1-presentation-tier) | `infrastructure/modules/presentation` | [AC-FR5-1](requirements/acceptance-criteria.md#ac-fr5-1-http-redirects-to-https), [AC-FR5-2](requirements/acceptance-criteria.md#ac-fr5-2-valid-tls-certificate) | `tests/e2e/test_https_redirect.py` (AC-FR5-1), Gap — test reference TBD (AC-FR5-2) | _TBD_ | Not started |
| FR6 | Functional | CloudFront CDN distribution | Presentation | [Presentation Tier](architecture/architecture-overview.md#1-presentation-tier) | `infrastructure/modules/presentation` | [AC-FR8-1](requirements/acceptance-criteria.md#ac-fr8-1-custom-domain-served-via-cloudfront) | `tests/e2e/test_cloudfront_routing.py` | _TBD_ | Not started |
| FR7 | Functional | Custom DNS domain name | Presentation | [Presentation Tier](architecture/architecture-overview.md#1-presentation-tier) | `infrastructure/modules/presentation` | [AC-FR7-1](requirements/acceptance-criteria.md#ac-fr7-1-custom-domain-resolves-to-cloudfront) | `tests/integration/test_dns_resolution.py` | _TBD_ | Not started |
| FR8 | Functional | Domain pointed to CloudFront | Presentation | [Presentation Tier](architecture/architecture-overview.md#1-presentation-tier) | `infrastructure/modules/presentation` | [AC-FR8-1](requirements/acceptance-criteria.md#ac-fr8-1-custom-domain-served-via-cloudfront) | `tests/e2e/test_cloudfront_routing.py` | _TBD_ | Not started |
| FR9 | Functional | Route 53 as DNS provider | Presentation | [Presentation Tier](architecture/architecture-overview.md#1-presentation-tier) | `infrastructure/modules/presentation` | Self-evident — no dedicated AC | Gap — no AC/test defined | _TBD_ | Not started |
| FR10 | Functional | Visitor counter display | Presentation | [Presentation Tier](architecture/architecture-overview.md#1-presentation-tier) | `frontend/src/js/main.js`, `frontend/src/index.html` | [AC-FR10-1](requirements/acceptance-criteria.md#ac-fr10-1-visitor-counter-displays-on-load), [AC-FR10-2](requirements/acceptance-criteria.md#ac-fr10-2-visitor-counter-increments-on-refresh) | `tests/e2e/test_visitor_counter_display.py` | _TBD_ | Not started |
| FR11 | Functional | Visitor counter implemented in JavaScript | Presentation | [Presentation Tier](architecture/architecture-overview.md#1-presentation-tier) | `frontend/src/js/main.js` | Self-evident — no dedicated AC | Gap — no AC/test defined | _TBD_ | Not started |
| FR12 | Functional | DynamoDB stores visitor count | Data | [Data Tier](architecture/architecture-overview.md#3-data-tier) | `infrastructure/modules/data` | [AC-FR12-14-1](requirements/acceptance-criteria.md#ac-fr12-14-1-api-returns-and-increments-visitor-count), [AC-FR12-14-2](requirements/acceptance-criteria.md#ac-fr12-14-2-lambda-handler-logic-mocked) | `tests/integration/test_visitor_counter_api.py`, `tests/unit/test_lambda_handler.py` | _TBD_ | Not started |
| FR13 | Functional | No direct client-to-DynamoDB communication | Cross-cutting | [Cross-Cutting Concerns](architecture/architecture-overview.md#cross-cutting-concerns) | `frontend/src/js/main.js`, `infrastructure/modules/presentation` | Self-evident — no dedicated AC | Gap — no AC/test defined | _TBD_ | Not started |
| FR14 | Functional | API Gateway and Lambda mediate data access | Logic | [Logic Tier](architecture/architecture-overview.md#2-logic-tier) | `infrastructure/modules/logic` | [AC-FR12-14-1](requirements/acceptance-criteria.md#ac-fr12-14-1-api-returns-and-increments-visitor-count) | `tests/integration/test_visitor_counter_api.py` | _TBD_ | Not started |
| FR15 | Functional | Lambda function code in Python | Logic | [Logic Tier](architecture/architecture-overview.md#2-logic-tier) | `backend/functions/get_visitor_count/handler.py` | Self-evident — no dedicated AC | Gap — no AC/test defined | _TBD_ | Not started |
| FR16 | Functional | Automated tests for Lambda code | Logic | [Logic Tier](architecture/architecture-overview.md#2-logic-tier) | `tests/unit/test_get_visitor_count.py` | Self-evident — no dedicated AC | Gap — no AC/test defined | _TBD_ | Not started |
| FR17 | Functional | Infrastructure as Code for API resources | Cross-cutting | [Cross-Cutting Concerns](architecture/architecture-overview.md#cross-cutting-concerns) | `infrastructure/modules/logic`, `infrastructure/modules/data` | Self-evident — no dedicated AC | Gap — no AC/test defined | _TBD_ | Not started |
| FR18 | Functional | Terraform as the IaC tool | Cross-cutting | [Cross-Cutting Concerns](architecture/architecture-overview.md#cross-cutting-concerns) | `infrastructure/` | Self-evident — no dedicated AC | Gap — no AC/test defined | _TBD_ | Not started |
| FR19 | Functional | Automated CI/CD for updates | Cross-cutting | [Cross-Cutting Concerns](architecture/architecture-overview.md#cross-cutting-concerns) | `.github/workflows/ci.yml`, `.github/workflows/deploy.yml` | Self-evident — no dedicated AC | Gap — no AC/test defined | _TBD_ | Not started |
| FR20 | Functional | Backend GitHub repository | Cross-cutting | [Cross-Cutting Concerns](architecture/architecture-overview.md#cross-cutting-concerns) | `backend/`, `.github/workflows/ci.yml` | Self-evident — no dedicated AC | Gap — no AC/test defined | _TBD_ | Not started |
| FR21 | Functional | CI/CD for backend code | Cross-cutting | [Cross-Cutting Concerns](architecture/architecture-overview.md#cross-cutting-concerns) | `.github/workflows/ci.yml`, `.github/workflows/deploy.yml` | [AC-FR21-1](requirements/acceptance-criteria.md#ac-fr21-1-backend-cicd-pipeline-succeeds) | `.github/workflows/backend-deploy.yml` | _TBD_ | Not started |
| FR22 | Functional | Frontend GitHub repository | Cross-cutting | [Cross-Cutting Concerns](architecture/architecture-overview.md#cross-cutting-concerns) | `frontend/`, `.github/workflows/ci.yml` | Self-evident — no dedicated AC | Gap — no AC/test defined | _TBD_ | Not started |
| FR23 | Functional | CI/CD for frontend code | Cross-cutting | [Cross-Cutting Concerns](architecture/architecture-overview.md#cross-cutting-concerns) | `.github/workflows/ci.yml`, `.github/workflows/deploy.yml` | [AC-FR23-1](requirements/acceptance-criteria.md#ac-fr23-1-frontend-cicd-pipeline-succeeds) | `.github/workflows/frontend-deploy.yml` | _TBD_ | Not started |
| FR24 | Functional | Automatic CloudFront cache invalidation | Cross-cutting | [Cross-Cutting Concerns](architecture/architecture-overview.md#cross-cutting-concerns) | `.github/workflows/deploy.yml` | [AC-FR24-1](requirements/acceptance-criteria.md#ac-fr24-1-cloudfront-cache-invalidation-triggered) | `.github/workflows/frontend-deploy.yml` | _TBD_ | Not started |
| FR25 | Functional | Logging to CloudWatch | Cross-cutting | [Cross-Cutting Concerns](architecture/architecture-overview.md#cross-cutting-concerns) | `infrastructure/modules/logic` | [AC-FR25-1](requirements/acceptance-criteria.md#ac-fr25-1-lambda-invocation-logged-to-cloudwatch) | `tests/integration/test_cloudwatch_logging.py` | _TBD_ | Not started |
| NFR1 | Non-Functional | High availability | Availability | [Presentation Tier](architecture/architecture-overview.md#1-presentation-tier) | `infrastructure/modules/presentation` | Self-evident — no dedicated AC | Gap — no AC/test defined | _TBD_ | Not started |
| NFR2 | Non-Functional | Free Tier cost constraint | Cost | [Cross-Cutting Concerns](architecture/architecture-overview.md#cross-cutting-concerns) | `infrastructure/environments/prod`, `infrastructure/modules/` | [AC-NFR2-1](requirements/acceptance-criteria.md#ac-nfr2-1-free-tier-cost-maintained) | Gap — test reference TBD (AC-NFR2-1) | _TBD_ | Not started |
| NFR3 | Non-Functional | No public write access to data | Security | [Cross-Cutting Concerns](architecture/architecture-overview.md#cross-cutting-concerns) | `infrastructure/modules/presentation`, `infrastructure/modules/logic`, `infrastructure/modules/data` | Self-evident — no dedicated AC | Gap — no AC/test defined | _TBD_ | Not started |
| NFR4 | Non-Functional | No credentials in source control | Security | [Cross-Cutting Concerns](architecture/architecture-overview.md#cross-cutting-concerns) | `.gitignore`, `.github/workflows/deploy.yml` | Self-evident — no dedicated AC | Gap — no AC/test defined | _TBD_ | Not started |
| NFR5 | Non-Functional | Infrastructure as Code | Maintainability | [Cross-Cutting Concerns](architecture/architecture-overview.md#cross-cutting-concerns) | `infrastructure/` | Self-evident — no dedicated AC | Gap — no AC/test defined | _TBD_ | Not started |
| NFR6 | Non-Functional | Gated CI/CD auto-deploy | Maintainability | [Cross-Cutting Concerns](architecture/architecture-overview.md#cross-cutting-concerns) | `.github/workflows/ci.yml`, `.github/workflows/deploy.yml` | [AC-FR21-1](requirements/acceptance-criteria.md#ac-fr21-1-backend-cicd-pipeline-succeeds), [AC-FR23-1](requirements/acceptance-criteria.md#ac-fr23-1-frontend-cicd-pipeline-succeeds) | `.github/workflows/backend-deploy.yml`, `.github/workflows/frontend-deploy.yml` | _TBD_ | Not started |
| NFR7 | Non-Functional | Automated backend testing | Maintainability | [Logic Tier](architecture/architecture-overview.md#2-logic-tier) | `tests/unit/`, `tests/integration/`, `.github/workflows/ci.yml` | [AC-FR12-14-2](requirements/acceptance-criteria.md#ac-fr12-14-2-lambda-handler-logic-mocked), [AC-FR21-1](requirements/acceptance-criteria.md#ac-fr21-1-backend-cicd-pipeline-succeeds) | `tests/unit/test_lambda_handler.py`, `.github/workflows/backend-deploy.yml` | _TBD_ | Not started |
| NFR8 | Non-Functional | OIDC-federated CI/CD authentication | Security | [Cross-Cutting Concerns](architecture/architecture-overview.md#cross-cutting-concerns) | `.github/workflows/deploy.yml`, `infrastructure/` | Self-evident — no dedicated AC | Gap — no AC/test defined | _TBD_ | Not started |
| NFR9 | Non-Functional | Billing alarm | Cost | [Cross-Cutting Concerns](architecture/architecture-overview.md#cross-cutting-concerns) | Not yet implemented | Gap — no dedicated AC | Gap — no AC/test defined | _TBD_ | Not started |

## Gap Analysis

The matrix explicitly identifies the following open gaps to be addressed during subsequent implementation and testing phases:

1. **Requirements with No Dedicated Acceptance Criteria / Test (`Gap — no AC/test defined`):**
   - Functional: FR2, FR3, FR9, FR11, FR13, FR15, FR16, FR17, FR18, FR19, FR20, FR22.
   - Non-Functional: NFR1, NFR3, NFR4, NFR5, NFR8, NFR9.
   - *Action:* When these requirements undergo implementation or formal verification, define dedicated acceptance criteria in `acceptance-criteria.md` or automated validation checks. Specifically, NFR9 (billing alarm) requires infrastructure definition for CloudWatch alarms and a verification test.

2. **Acceptance Criteria with TBD Test References (`Gap — test reference TBD`):**
   - `AC-FR5-2` (Valid TLS certificate — manual inspection / TLS validation script).
   - `AC-NFR2-1` (Free Tier cost maintained — cost monitoring / inspection).
   - *Action:* Provide concrete automated test scripts or verification procedures under `tests/` or CI workflows.

3. **Implementation Artifacts Pending:**
   - Terraform modules (`infrastructure/modules/*`), frontend code (`frontend/src/*`), backend Lambda handler (`backend/functions/*`), and test suites (`tests/*`) are currently scaffolded with placeholder definitions.
   - NFR9 (Billing alarm) infrastructure resources have not yet been scaffolded in Terraform.

## Maintenance

To maintain traceability integrity across the project lifecycle:

1. **Adding/Updating Requirements:**
   - When a new requirement (`FR<N>` or `NFR<N>`) is added to `docs/requirements/functional-requirements.md` or `docs/requirements/non-functional-requirements.md`, add a corresponding row in this matrix.
   - Keep the `ID`, `Type`, `Title`, `Tier/Component or Category`, `Related Architecture`, and `Acceptance Criteria` columns synchronized.

2. **Linking GitHub Issues:**
   - When GitHub Issues are created for requirements, update `Tracked by (Issue)` with `#<issue-number>` in this matrix, as well as the individual requirement sections and registers in the requirement documents.

3. **Adding Tests:**
   - When test files are implemented under `tests/` or workflows under `.github/workflows/`, update the `Test Reference` column in this matrix and in `acceptance-criteria.md`. Replace any `Gap — ...` entries once concrete tests exist.

4. **Automated Verification:**
   - Run `python3 scripts/check_traceability.py` (or execute the traceability CI check workflow) to verify that all requirement IDs are accounted for in this matrix and all referenced files exist in the repository.

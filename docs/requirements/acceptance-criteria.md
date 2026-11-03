# Acceptance Criteria

**Purpose:** Acceptance criteria define the observable, testable conditions that must be met to consider a requirement complete. Not every requirement in [`functional-requirements.md`](./functional-requirements.md)
and [`non-functional-requirements.md`](./non-functional-requirements.md) requires a dedicated acceptance criterion — only those where verification is ambiguous or non-trivial. Requirements that are self-evidently binary, or already enforced by tooling/CI, are considered verified by their own statement and are not duplicated here.

## Acceptance Criteria Template

Only requirements with non-trivial or ambiguous verification get an entry here. Format:

### AC-<Requirement ID>: <Short title>
- **Requirement:** <FR<N> | NFR<N>>
- **Criterion:** <single pass/fail condition>
- **Verification:** <Unit test | Integration test | Manual inspection>
- **Test Reference:** <path under tests/ once implemented>

---

## Acceptance Criteria

### AC-FR4-1: Public site returns resume
- **Requirement:** FR1, FR4
- **Criterion:** Visiting the S3 website endpoint URL returns the resume HTML with a 200 status
- **Verification:** E2E test
- **Test Reference:** `tests/e2e/test_site_availability.py`

### AC-FR5-1: HTTP redirects to HTTPS
- **Requirement:** FR5
- **Criterion:** Visiting the site over http:// redirects to https://
- **Verification:** E2E test
- **Test Reference:** `tests/e2e/test_https_redirect.py`

### AC-FR5-2: Valid TLS certificate
- **Requirement:** FR5
- **Criterion:** Browser shows a valid padlock/certificate for the site
- **Verification:** Manual inspection
- **Test Reference:** _(TBD)_

### AC-FR7-1: Custom domain resolves to CloudFront
- **Requirement:** FR7
- **Criterion:** DNS lookup of the custom domain returns a valid record resolving to the CloudFront distribution
- **Verification:** DNS/Network validation
- **Test Reference:** `tests/integration/test_dns_resolution.py`

### AC-FR8-1: Custom domain served via CloudFront
- **Requirement:** FR6, FR8
- **Criterion:** GET request to the custom domain returns HTTP 200 and response headers confirm the response was served via CloudFront
- **Verification:** E2E test
- **Test Reference:** `tests/e2e/test_cloudfront_routing.py`

### AC-FR10-1: Visitor counter displays on load
- **Requirement:** FR10
- **Criterion:** Counter shows a number on page load
- **Verification:** E2E test
- **Test Reference:** `tests/e2e/test_visitor_counter_display.py`

### AC-FR10-2: Visitor counter increments on refresh
- **Requirement:** FR10
- **Criterion:** Refreshing the page increments the number by 1
- **Verification:** E2E test
- **Test Reference:** `tests/e2e/test_visitor_counter_display.py`

### AC-FR12-14-1: API returns and increments visitor count
- **Requirement:** FR12, FR14
- **Criterion:** GET request to the API endpoint returns a numeric count field, and the DynamoDB item value has incremented by 1 from its prior state
- **Verification:** Integration test
- **Test Reference:** `tests/integration/test_visitor_counter_api.py`

### AC-FR12-14-2: Lambda handler logic (mocked)
- **Requirement:** FR12, FR14
- **Criterion:** Given a mocked DynamoDB client, invoking the Lambda handler calls `update_item` with the correct key/increment expression and returns the expected count
- **Verification:** Unit test
- **Test Reference:** `tests/unit/test_lambda_handler.py`

### AC-FR21-1: Backend CI/CD pipeline succeeds
- **Requirement:** FR21
- **Criterion:** A push to the main branch that changes the deployed infrastructure or the Lambda code results in a GitHub Actions run in which the plan job, the apply job (after manual approval), and the smoke-test job all complete successfully. A push that produces no planned changes ends after the plan job, with the apply and smoke-test jobs skipped.
- **Verification:** Pipeline/CI validation
- **Test Reference:** CI workflow run status (`.github/workflows/backend-deploy.yml`)

### AC-FR23-1: Frontend CI/CD pipeline succeeds
- **Requirement:** FR23
- **Criterion:** A push to the frontend repository's main branch results in the S3 bucket object's ETag/last-modified value changing to reflect the new content
- **Verification:** Pipeline/CI validation
- **Test Reference:** CI workflow run status (`.github/workflows/frontend-deploy.yml`)

### AC-FR24-1: CloudFront cache invalidation triggered
- **Requirement:** FR24
- **Criterion:** Following a completed frontend deployment, the CI/CD workflow logs show a successful CloudFront `create-invalidation` API call
- **Verification:** Pipeline/CI validation
- **Test Reference:** CI workflow log inspection (`.github/workflows/frontend-deploy.yml`)

### AC-FR25-1: Lambda invocation logged to CloudWatch
- **Requirement:** FR25
- **Criterion:** Following a Lambda invocation via the API, the corresponding CloudWatch log group contains a log entry with the invocation timestamp and request details
- **Verification:** Integration test
- **Test Reference:** `tests/integration/test_cloudwatch_logging.py`

### AC-NFR2-1: Free tier cost maintained
- **Requirement:** NFR2
- **Criterion:** AWS Cost Explorer shows $0 or near-$0 charges after 1 week of testing
- **Verification:** Manual inspection
- **Test Reference:** _(TBD)_

### AC-NFR6-1: Backend deploy is approved and verified
- **Requirement:** NFR6
- **Criterion:** A backend deployment run pauses at the production environment's approval step before applying, shows the planned changes in the run summary, and ends with a successful post-deployment smoke-test job.
- **Verification:** Pipeline/CI validation
- **Test Reference:** CI workflow run status (`.github/workflows/backend-deploy.yml`)

### AC-NFR6-2: Frontend deploys automatically and is verified
- **Requirement:** NFR6
- **Criterion:** A push to the main branch that changes files under `frontend/` results in a workflow run that syncs the site to S3, invalidates the CloudFront cache, and passes a post-deployment check that the live site returns HTTP 200 with the expected page content.
- **Verification:** Pipeline/CI validation
- **Test Reference:** CI workflow run status (frontend deploy workflow, planned; add the file name when it exists)

---

## Acceptance Criteria Register

| ID | Requirement | Criterion | Verification | Test Reference |
|----|-------------|-----------|---------------|-----------------|
| AC-FR4-1 | FR1, FR4 | S3 endpoint returns resume HTML, 200 status | E2E test | `tests/e2e/test_site_availability.py` |
| AC-FR5-1 | FR5 | HTTP redirects to HTTPS | E2E test | `tests/e2e/test_https_redirect.py` |
| AC-FR5-2 | FR5 | Valid TLS certificate shown | Manual inspection | _(TBD)_ |
| AC-FR7-1 | FR7 | Domain resolves to CloudFront | DNS/Network validation | `tests/integration/test_dns_resolution.py` |
| AC-FR8-1 | FR6, FR8 | Domain served via CloudFront | E2E test | `tests/e2e/test_cloudfront_routing.py` |
| AC-FR10-1 | FR10 | Counter shows number on load | E2E test | `tests/e2e/test_visitor_counter_display.py` |
| AC-FR10-2 | FR10 | Counter increments by 1 on refresh | E2E test | `tests/e2e/test_visitor_counter_display.py` |
| AC-FR12-14-1 | FR12, FR14 | API returns/increments count in DynamoDB | Integration test | `tests/integration/test_visitor_counter_api.py` |
| AC-FR12-14-2 | FR12, FR14 | Lambda handler logic (mocked DynamoDB) | Unit test | `tests/unit/test_lambda_handler.py` |
| AC-FR21-1 | FR21 | Backend CI/CD pipeline succeeds | Pipeline/CI validation | `.github/workflows/backend-deploy.yml` |
| AC-FR23-1 | FR23 | Frontend CI/CD pipeline succeeds | Pipeline/CI validation | `.github/workflows/frontend-deploy.yml` |
| AC-FR24-1 | FR24 | Cache invalidation call succeeds | Pipeline/CI validation | `.github/workflows/frontend-deploy.yml` |
| AC-FR25-1 | FR25 | Lambda invocation logged to CloudWatch | Integration test | `tests/integration/test_cloudwatch_logging.py` |
| AC-NFR2-1 | NFR2 | $0/near-$0 cost after 1 week | Manual inspection | _(TBD)_ |
| AC-NFR6-1 | NFR6 | Backend deployment is approved and verified | Pipeline/CI validation | `.github/workflows/backend-deploy.yml` |
| AC-NFR6-2 | NFR6 | Frontend deployment is automatic and verified | Pipeline/CI validation | `.github/workflows/frontend-deploy.yml` |
---
_Acceptance criteria are written selectively — not every requirement needs one. This table is populated as ambiguous or non-trivial requirements are identified._

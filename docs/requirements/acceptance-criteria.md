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

### AC-FR4-1: S3 static website returns resume
- **Requirement:** FR4
- **Criterion:** Visiting the S3 website endpoint URL returns the resume HTML with a 200 status
- **Verification:** Manual inspection
- **Test Reference:** _(TBD)_

### AC-FR5-1: HTTP redirects to HTTPS
- **Requirement:** FR5
- **Criterion:** Visiting the site over http:// redirects to https://
- **Verification:** Manual inspection
- **Test Reference:** _(TBD)_

### AC-FR5-2: Valid TLS certificate
- **Requirement:** FR5
- **Criterion:** Browser shows a valid padlock/certificate for the site
- **Verification:** Manual inspection
- **Test Reference:** _(TBD)_

### AC-FR10-1: Visitor counter displays on load
- **Requirement:** FR10
- **Criterion:** Counter shows a number on page load
- **Verification:** Manual inspection
- **Test Reference:** _(TBD)_

### AC-FR10-2: Visitor counter increments on refresh
- **Requirement:** FR10
- **Criterion:** Refreshing the page increments the number by 1
- **Verification:** Integration test
- **Test Reference:** _(TBD)_

### AC-NFR2-1: Free tier cost maintained
- **Requirement:** NFR2
- **Criterion:** AWS Cost Explorer shows $0 or near-$0 charges after 1 week of testing
- **Verification:** Manual inspection
- **Test Reference:** _(TBD)_

---

## Acceptance Criteria Register

| ID | Requirement | Criterion | Verification | Test Reference |
|----|-------------|-----------|---------------|-----------------|
| AC-FR4-1 | FR4 | S3 endpoint returns resume HTML, 200 status | Manual inspection | _(TBD)_ |
| AC-FR5-1 | FR5 | HTTP redirects to HTTPS | Manual inspection | _(TBD)_ |
| AC-FR5-2 | FR5 | Valid TLS certificate shown | Manual inspection | _(TBD)_ |
| AC-FR10-1 | FR10 | Counter shows number on load | Manual inspection | _(TBD)_ |
| AC-FR10-2 | FR10 | Counter increments by 1 on refresh | Integration test | _(TBD)_ |
| AC-NFR2-1 | NFR2 | $0/near-$0 cost after 1 week | Manual inspection | _(TBD)_ |

---
_Acceptance criteria are written selectively — not every requirement needs one. This table is populated as ambiguous or non-trivial requirements are identified._

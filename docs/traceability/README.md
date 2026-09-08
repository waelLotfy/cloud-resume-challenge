# Traceability

This document describes the requirements-to-implementation traceability approach
for the Cloud Resume Challenge project. For the unified traceability matrix, see
[`docs/traceability-matrix.md`](../traceability-matrix.md).

## Approach

Requirements-to-implementation traceability for this project is maintained through
both a unified Requirements Traceability Matrix ([`docs/traceability-matrix.md`](../traceability-matrix.md))
and GitHub-native features (Issues, Pull Requests, and commit message conventions).
This ensures full visibility across the V-Model SDLC:
`Requirement (FR/NFR)` → `Architecture` → `Implementation` → `Acceptance Criteria` → `Test` → `Issue`.

Each functional (`FRn`) and non-functional (`NFRn`) requirement is defined in
[`docs/requirements/`](../requirements/) and can be tracked using GitHub Issues created via
[`.github/ISSUE_TEMPLATE/requirement.md`](../../.github/ISSUE_TEMPLATE/requirement.md).

## How Traceability Links Work

1. **Requirement → Traceability Matrix:** All functional and non-functional requirements
   are tracked in [`docs/traceability-matrix.md`](../traceability-matrix.md).
2. **Requirement → Issue:** Each requirement document
   (`docs/requirements/functional-requirements.md`,
   `docs/requirements/non-functional-requirements.md`) and the matrix reference the
   GitHub Issue number tracking its implementation (`Tracked by #<issue-number>`).
3. **Issue → Commit/PR:** Commits and pull requests reference the issue
   they address using the commit message convention documented in
   [`CONTRIBUTING.md`](../../CONTRIBUTING.md) (e.g.
   `feat(lambda): implement visitor counter (#12)`), and PRs use closing
   keywords (`Closes #12`) so GitHub automatically links and closes
   issues on merge.
4. **Issue / Matrix → Test:** Acceptance criteria
   (`docs/requirements/acceptance-criteria.md`) and the traceability matrix
   reference the test file(s) under `tests/` or CI workflows that verify them.

## Status

The Requirements Traceability Matrix is available at
[`docs/traceability-matrix.md`](../traceability-matrix.md). Requirements FR1–FR25
and NFR1–NFR9 have been mapped to Architecture, Implementation paths, Acceptance
Criteria, and Tests, with open verification gaps explicitly flagged.


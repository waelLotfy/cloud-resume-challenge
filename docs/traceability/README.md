# Traceability

> **Status:** Placeholder. Traceability is implemented via GitHub-native
> features, not a hand-maintained traceability matrix file.

## Approach

Requirements-to-implementation traceability for this project is built
using GitHub Issues, Pull Requests, and commit message conventions rather
than a separately maintained spreadsheet or matrix document. This keeps
traceability data close to the code and automatically updated as work
progresses.

Once real requirement content exists, each functional (`FRn`) and
non-functional (`NFRn`) requirement will get a corresponding GitHub Issue,
created via the issue templates in
[`.github/ISSUE_TEMPLATE/`](../../.github/ISSUE_TEMPLATE):

- [`requirement.md`](../../.github/ISSUE_TEMPLATE/requirement.md) — for
  filing a single functional or non-functional requirement as a trackable
  issue.

## How Traceability Links Work

1. **Requirement → Issue:** Each requirement document
   (`docs/requirements/functional-requirements.md`,
   `docs/requirements/non-functional-requirements.md`) references the
   GitHub Issue number tracking its implementation (`Tracked by
   #<issue-number>`).
2. **Issue → Commit/PR:** Commits and pull requests reference the issue
   they address using the commit message convention documented in
   [`CONTRIBUTING.md`](../../CONTRIBUTING.md) (e.g.
   `feat(lambda): implement visitor counter (#12)`), and PRs use closing
   keywords (`Closes #12`) so GitHub automatically links and closes
   issues on merge.
3. **Issue → Test:** Acceptance criteria
   (`docs/requirements/acceptance-criteria.md`) reference the test file(s)
   under `tests/` that verify them.

This yields a full chain: `Requirement (FRn/NFRn)` → `GitHub Issue` →
`Commit/PR` → `Test`, all navigable natively within GitHub, without a
manually maintained traceability matrix file.

## Status

No GitHub Issues have been created yet — requirement content does not yet
exist. Issues will be created (via Copilot Agent or manually) once
`docs/requirements/` is populated with real FR/NFR content.

#!/usr/bin/env python3
"""Parse functional/non-functional requirement docs and create one GitHub
Issue per requirement (idempotently).

Usage:
    python scripts/create_requirement_issues.py [--dry-run]

Environment variables:
    GITHUB_TOKEN   Token with `issues: write` permission on GITHUB_REPOSITORY.
    GITHUB_REPOSITORY  "owner/repo" (automatically set inside GitHub Actions).

This script is safe to re-run: it searches for an existing open or closed
issue whose title starts with the requirement ID (e.g. "FR1:") before
creating a new one.
"""
from __future__ import annotations

import argparse
import json
import os
import re
import sys
import urllib.error
import urllib.parse
import urllib.request
from dataclasses import dataclass, field
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
REQUIREMENTS_DIR = REPO_ROOT / "docs" / "requirements"

FUNCTIONAL_FILE = REQUIREMENTS_DIR / "functional-requirements.md"
NON_FUNCTIONAL_FILE = REQUIREMENTS_DIR / "non-functional-requirements.md"

EXPECTED_FR_COUNT = 25
EXPECTED_NFR_COUNT = 9

# Matches lines like:
#   - **FR1 (Resume Content):** The website shall display ...
#   - **NFR8(Security):** The CI/CD pipeline shall ...
REQUIREMENT_LINE_RE = re.compile(
    r"^-\s*\*\*(?P<id>FR\d+|NFR\d+)\s*(?:\((?P<category>[^)]*)\))?\s*:\*\*\s*(?P<body>.+)$"
)


@dataclass
class Requirement:
    req_id: str
    category: str
    body: str
    source_file: str
    labels: list = field(default_factory=list)

    @property
    def title(self) -> str:
        return f"{self.req_id}: {self.category}" if self.category else self.req_id

    @property
    def issue_body(self) -> str:
        return (
            f"{self.body}\n\n"
            f"---\n"
            f"Source: `{self.source_file}` (requirement `{self.req_id}`)"
        )


def parse_requirements(path: Path, label: str) -> list:
    if not path.exists():
        raise FileNotFoundError(f"Requirements file not found: {path}")

    requirements = []
    for line in path.read_text(encoding="utf-8").splitlines():
        match = REQUIREMENT_LINE_RE.match(line.strip())
        if not match:
            continue
        req_id = match.group("id")
        category = (match.group("category") or "").strip()
        body = match.group("body").strip()
        requirements.append(
            Requirement(
                req_id=req_id,
                category=category,
                body=body,
                source_file=str(path.relative_to(REPO_ROOT)),
                labels=["requirement", label],
            )
        )
    return requirements


def load_all_requirements() -> list:
    frs = parse_requirements(FUNCTIONAL_FILE, "functional-requirement")
    nfrs = parse_requirements(NON_FUNCTIONAL_FILE, "non-functional-requirement")

    if len(frs) != EXPECTED_FR_COUNT:
        raise ValueError(
            f"Expected {EXPECTED_FR_COUNT} functional requirements, found {len(frs)}"
        )
    if len(nfrs) != EXPECTED_NFR_COUNT:
        raise ValueError(
            f"Expected {EXPECTED_NFR_COUNT} non-functional requirements, found {len(nfrs)}"
        )

    return frs + nfrs


class GitHubClient:
    def __init__(self, repo: str, token: str):
        self.repo = repo
        self.token = token
        self.api_base = f"https://api.github.com/repos/{repo}"

    def _headers(self) -> dict:
        return {
            "Authorization": "Bearer " + self.token,
            "Accept": "application/vnd.github+json",
            "X-GitHub-Api-Version": "2022-11-28",
        }

    def _request(self, method: str, url: str, payload: dict = None):
        data = json.dumps(payload).encode("utf-8") if payload is not None else None
        req = urllib.request.Request(url, data=data, method=method)
        for key, value in self._headers().items():
            req.add_header(key, value)
        try:
            with urllib.request.urlopen(req) as resp:
                return json.loads(resp.read().decode("utf-8"))
        except urllib.error.HTTPError as exc:
            body = exc.read().decode("utf-8")
            raise RuntimeError(f"GitHub API error {exc.code} for {method} {url}: {body}") from exc

    def find_issue_by_title_prefix(self, title_prefix: str):
        query = f'repo:{self.repo} in:title "{title_prefix}" type:issue'
        url = f"https://api.github.com/search/issues?q={urllib.parse.quote(query)}"
        data = self._request("GET", url)
        for item in data.get("items", []):
            if item["title"].startswith(title_prefix):
                return item
        return None

    def create_issue(self, title: str, body: str, labels: list):
        return self._request(
            "POST",
            f"{self.api_base}/issues",
            {"title": title, "body": body, "labels": labels},
        )


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--dry-run",
        action="store_true",
        default=os.environ.get("DRY_RUN", "").lower() in ("1", "true", "yes"),
        help="Print what would be created without calling the GitHub API.",
    )
    args = parser.parse_args()

    try:
        requirements = load_all_requirements()
    except (FileNotFoundError, ValueError) as exc:
        print(f"ERROR: {exc}", file=sys.stderr)
        return 1

    print(f"Parsed {len(requirements)} requirements "
          f"({EXPECTED_FR_COUNT} FR + {EXPECTED_NFR_COUNT} NFR).")

    mapping = []

    if args.dry_run:
        for req in requirements:
            print(f"[dry-run] Would ensure issue exists: {req.title!r} labels={req.labels}")
            mapping.append({"id": req.req_id, "title": req.title, "issue": None})
        _write_mapping(mapping)
        return 0

    token = os.environ.get("GITHUB_TOKEN")
    repo = os.environ.get("GITHUB_REPOSITORY")
    if not token or not repo:
        print(
            "ERROR: GITHUB_TOKEN and GITHUB_REPOSITORY environment variables are required "
            "for non-dry-run mode.",
            file=sys.stderr,
        )
        return 1

    client = GitHubClient(repo=repo, token=token)

    for req in requirements:
        existing = client.find_issue_by_title_prefix(f"{req.req_id}:")
        if existing:
            print(f"SKIP  {req.title!r} -> already exists as #{existing['number']}")
            mapping.append(
                {"id": req.req_id, "title": req.title, "issue": existing["number"], "url": existing["html_url"]}
            )
            continue

        issue = client.create_issue(req.title, req.issue_body, req.labels)
        print(f"CREATE {req.title!r} -> #{issue['number']}")
        mapping.append(
            {"id": req.req_id, "title": req.title, "issue": issue["number"], "url": issue["html_url"]}
        )

    _write_mapping(mapping)
    return 0


def _write_mapping(mapping: list) -> None:
    out_path = REPO_ROOT / "requirement-issue-mapping.json"
    out_path.write_text(json.dumps(mapping, indent=2) + "\n", encoding="utf-8")
    print(f"Wrote mapping for {len(mapping)} requirements to {out_path}")


if __name__ == "__main__":
    sys.exit(main())

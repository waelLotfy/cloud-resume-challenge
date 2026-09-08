#!/usr/bin/env python3
"""Traceability Matrix Consistency and Verification Checker.

Validates that:
1. All functional requirements (FR1–FR25) in docs/requirements/functional-requirements.md
   exist as rows in docs/traceability-matrix.md.
2. All non-functional requirements (NFR1–NFR9) in docs/requirements/non-functional-requirements.md
   exist as rows in docs/traceability-matrix.md.
3. The traceability matrix follows the expected column schema (10 columns).
4. Scans test reference paths and reports gaps / missing test files.
"""

from __future__ import annotations

import re
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
DOCS_DIR = REPO_ROOT / "docs"
FR_FILE = DOCS_DIR / "requirements" / "functional-requirements.md"
NFR_FILE = DOCS_DIR / "requirements" / "non-functional-requirements.md"
AC_FILE = DOCS_DIR / "requirements" / "acceptance-criteria.md"
MATRIX_FILE = DOCS_DIR / "traceability-matrix.md"

EXPECTED_COLUMNS = [
    "ID",
    "Type",
    "Title",
    "Tier/Component or Category",
    "Related Architecture",
    "Implementation",
    "Acceptance Criteria",
    "Test Reference",
    "Tracked by (Issue)",
    "Status",
]


def extract_section_ids(file_path: Path, prefix: str) -> list[str]:
    """Extract requirement IDs (e.g. FR1, NFR1) from header patterns."""
    if not file_path.is_file():
        raise FileNotFoundError(f"Missing requirements file: {file_path}")

    content = file_path.read_text(encoding="utf-8")
    pattern = rf"^###\s+({prefix}\d+):"
    matches = re.findall(pattern, content, flags=re.MULTILINE)
    return matches


def parse_traceability_matrix(matrix_path: Path) -> tuple[list[str], dict[str, dict[str, str]]]:
    """Parse the markdown table in docs/traceability-matrix.md."""
    if not matrix_path.is_file():
        raise FileNotFoundError(f"Missing matrix file: {matrix_path}")

    content = matrix_path.read_text(encoding="utf-8")
    table_lines = [
        line.strip()
        for line in content.splitlines()
        if line.strip().startswith("|") and not line.strip().startswith("|---")
    ]

    if not table_lines:
        raise ValueError("No table found in traceability matrix file.")

    header_line = table_lines[0]
    headers = [col.strip() for col in header_line.split("|")[1:-1]]

    rows: dict[str, dict[str, str]] = {}
    for line in table_lines[1:]:
        cols = [col.strip() for col in line.split("|")[1:-1]]
        if len(cols) != len(headers):
            continue
        row_dict = dict(zip(headers, cols))
        req_id = row_dict.get("ID", "")
        if req_id and (req_id.startswith("FR") or req_id.startswith("NFR")):
            rows[req_id] = row_dict

    return headers, rows


def check_traceability() -> int:
    """Run all validation checks and return exit code (0 for success)."""
    errors: list[str] = []
    warnings: list[str] = []

    print("Checking Requirements Traceability Matrix consistency...")

    # 1. Extract IDs from requirements documents
    fr_ids = extract_section_ids(FR_FILE, "FR")
    nfr_ids = extract_section_ids(NFR_FILE, "NFR")
    all_doc_ids = fr_ids + nfr_ids

    print(f"Found {len(fr_ids)} FRs in {FR_FILE.relative_to(REPO_ROOT)}")
    print(f"Found {len(nfr_ids)} NFRs in {NFR_FILE.relative_to(REPO_ROOT)}")

    # 2. Parse matrix table
    headers, matrix_rows = parse_traceability_matrix(MATRIX_FILE)
    print(f"Found {len(matrix_rows)} requirement rows in {MATRIX_FILE.relative_to(REPO_ROOT)}")

    # Check headers
    if headers != EXPECTED_COLUMNS:
        errors.append(
            f"Matrix header mismatch.\nExpected: {EXPECTED_COLUMNS}\nFound:    {headers}"
        )

    # Check for missing requirements in matrix
    for req_id in all_doc_ids:
        if req_id not in matrix_rows:
            errors.append(f"Requirement {req_id} is defined in requirements docs but missing in traceability matrix.")

    # Check for extra/unknown requirement IDs in matrix
    for matrix_id in matrix_rows:
        if matrix_id not in all_doc_ids:
            errors.append(f"Requirement {matrix_id} exists in matrix but is not defined in requirements docs.")

    # 3. Check test file existence and report gaps
    print("\nAuditing test references...")
    test_path_pattern = re.compile(r"[`'](tests/[^`']+|\.github/workflows/[^`']+)['`]")

    for req_id, row in sorted(matrix_rows.items(), key=lambda x: (x[0][:3], int(x[0][3:]) if x[0][3:].isdigit() else 0)):
        test_ref = row.get("Test Reference", "")
        matches = test_path_pattern.findall(test_ref)

        for rel_path in matches:
            full_path = REPO_ROOT / rel_path
            if not full_path.exists():
                warnings.append(f"[{req_id}] Referenced test/workflow file does not exist yet: {rel_path}")

    # Summary
    print("\n" + "=" * 60)
    print("TRACEABILITY CHECK SUMMARY")
    print("=" * 60)

    if errors:
        print(f"❌ {len(errors)} ERROR(S) FOUND:")
        for err in errors:
            print(f"  - {err}")
    else:
        print("✅ All FRs and NFRs are fully synchronized with the traceability matrix.")
        print(f"✅ Schema columns verified ({len(headers)} columns).")

    if warnings:
        print(f"\n⚠️  {len(warnings)} NOTICES / OPEN GAPS (Pending implementation):")
        for warn in warnings:
            print(f"  - {warn}")

    print("=" * 60)
    return 1 if errors else 0


if __name__ == "__main__":
    sys.exit(check_traceability())

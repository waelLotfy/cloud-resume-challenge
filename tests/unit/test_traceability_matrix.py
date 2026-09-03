"""Unit test for requirements traceability matrix consistency.

Ensures that all functional and non-functional requirements are present
in docs/traceability-matrix.md with valid columns and mappings.
"""

from __future__ import annotations

import unittest
from pathlib import Path

from scripts.check_traceability import (
    EXPECTED_COLUMNS,
    FR_FILE,
    MATRIX_FILE,
    NFR_FILE,
    extract_section_ids,
    parse_traceability_matrix,
)


class TestTraceabilityMatrix(unittest.TestCase):
    """Test suite for traceability matrix validation."""

    def test_requirements_files_exist(self) -> None:
        """Verify that all requirement source files exist."""
        self.assertTrue(FR_FILE.is_file(), f"Missing {FR_FILE}")
        self.assertTrue(NFR_FILE.is_file(), f"Missing {NFR_FILE}")
        self.assertTrue(MATRIX_FILE.is_file(), f"Missing {MATRIX_FILE}")

    def test_matrix_headers(self) -> None:
        """Verify matrix column headers match expected schema."""
        headers, _ = parse_traceability_matrix(MATRIX_FILE)
        self.assertEqual(headers, EXPECTED_COLUMNS)

    def test_all_frs_present_in_matrix(self) -> None:
        """Verify all functional requirements from FR doc are in the matrix."""
        fr_ids = extract_section_ids(FR_FILE, "FR")
        _, matrix_rows = parse_traceability_matrix(MATRIX_FILE)

        self.assertEqual(len(fr_ids), 25, "Expected 25 functional requirements (FR1-FR25)")
        for fr_id in fr_ids:
            self.assertIn(fr_id, matrix_rows, f"Missing {fr_id} in matrix")
            row = matrix_rows[fr_id]
            self.assertEqual(row["Type"], "Functional")
            self.assertEqual(row["Status"], "Not started")
            self.assertEqual(row["Tracked by (Issue)"], "_TBD_")

    def test_all_nfrs_present_in_matrix(self) -> None:
        """Verify all non-functional requirements from NFR doc are in the matrix."""
        nfr_ids = extract_section_ids(NFR_FILE, "NFR")
        _, matrix_rows = parse_traceability_matrix(MATRIX_FILE)

        self.assertEqual(len(nfr_ids), 9, "Expected 9 non-functional requirements (NFR1-NFR9)")
        for nfr_id in nfr_ids:
            self.assertIn(nfr_id, matrix_rows, f"Missing {nfr_id} in matrix")
            row = matrix_rows[nfr_id]
            self.assertEqual(row["Type"], "Non-Functional")
            self.assertEqual(row["Status"], "Not started")
            self.assertEqual(row["Tracked by (Issue)"], "_TBD_")


if __name__ == "__main__":
    unittest.main()

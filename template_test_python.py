#!/usr/bin/env python3

import unittest
import polars as pl
from polars.testing import assert_frame_equal
from template_python import pipeline

INPUT_COLUMNS={
    "genome": str,
    }

OUTPUT_COLUMNS={
    "genome": str,
    "output": int,
    }

class Tests(unittest.TestCase):
    def assertDataFrameEqual(self, a, b):
        assert_frame_equal(a, b, check_dtype=False, check_row_order=False)

    def test_template_python(self):
        input = pl.DataFrame([
            ["genome1"],
        ], schema=INPUT_COLUMNS)

        expected_output = pl.DataFrame([
            ["genome1", 1],
        ], schema=OUTPUT_COLUMNS)

        observed_output = pipeline(input)
        self.assertDataFrameEqual(expected_output, observed_output)


if __name__ == '__main__':
    unittest.main()

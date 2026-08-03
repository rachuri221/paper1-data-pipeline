"""
analysis/07_scf_extraction.py

Extracts Tables 1, 2, and 5 from the Federal Reserve's "Changes in U.S.
Family Finances from 2019 to 2022" SCF Bulletin (scf23.pdf) programmatically
-- not hand-typed. These three tables are text-based (not gridded PDF
tables), so pdfplumber's extract_tables() only picks up the header rows;
the data rows are parsed here with a regex that looks for a run of numeric-
or-"n.a." tokens at the end of each line, with the leading text treated as
the row label. Section header lines (e.g. "Age of reference person (years)")
and standard-error rows (e.g. "(1.1) (1.2) n.a. ...") are detected and
skipped rather than misparsed as data.

This is used in this project purely as a BENCHMARKING dataset (SCF is
national-population aggregate statistics, not respondent microdata) --
see docs/analytical_decisions.md for why it isn't pooled into the NFCS
regression models.

Outputs:
  data/cleaned/scf_table1_income.csv
  data/cleaned/scf_table2_networth.csv
  data/cleaned/scf_table5_debt_burden.csv
  outputs/tables/scf_extraction_log.csv   (which page each table came from,
                                            row counts, for auditability)
"""

import os
import re
import sys
import pdfplumber
import pandas as pd

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import utils

SCF_PDF_PATH = os.path.join(utils.RAW_DIR, "SCF", "scf23.pdf")

# Normalize the various dash/minus characters the Fed's PDF uses
# (hyphen-minus, Unicode minus sign, en dash) to a plain ASCII "-" before
# parsing, so a single regex handles all of them.
DASH_CHARS = ["\u2212", "\u2013", "\u2014"]  # minus sign, en dash, em dash


def normalize_dashes(text: str) -> str:
    for ch in DASH_CHARS:
        text = text.replace(ch, "-")
    return text


NUMERIC_TOKEN = r"(-?[\d,]+\.?\d*|n\.a\.)"


def _row_pattern(n_numeric_cols: int) -> re.Pattern:
    return re.compile(
        r"^(?P<label>.*?)\s+" + r"\s+".join([NUMERIC_TOKEN] * n_numeric_cols) + r"\s*$"
    )


def _is_continuation_fragment(label: str) -> bool:
    """Heuristic for 'this label is the tail end of a line-wrapped row, not
    a real standalone label' -- e.g. 'than 40 percent' or '(past year)'.
    Real row labels in this bulletin start with an uppercase letter."""
    if not label:
        return True
    return label[0].islower() or label[0] == "("


def parse_numeric_table(page_text: str, n_numeric_cols: int) -> list:
    """
    Parse a text-based Fed bulletin table into rows of
    [label, val_1, val_2, ..., val_n].

    Two complications in these bulletin tables, both handled here:

    1. Standard-error rows (e.g. "(1.1) (1.2) n.a. (1.9) (4.2) n.a.") have
       every value wrapped in parentheses, so they never match
       NUMERIC_TOKEN at all and are skipped automatically -- no special
       case needed.

    2. A handful of row labels wrap across two physical lines (e.g.
       "Fraction with payment-to-income ratio greater" / "than 40 percent
       10.4 8.2 ..."). If parsed line-by-line naively, the label truncates
       to just the second line's leftover text ("than 40 percent"). This
       function carries a one-line lookback buffer and merges it with the
       current line when the current line's own label looks like a
       continuation fragment (starts lowercase or with "(") rather than a
       real label.
    """
    text = normalize_dashes(page_text)
    pattern = _row_pattern(n_numeric_cols)
    rows = []
    pending = ""

    for raw_line in text.split("\n"):
        line = raw_line.strip()
        if not line:
            continue

        bare_match = pattern.match(line)
        merged_match = pattern.match(f"{pending} {line}".strip()) if pending else None

        if bare_match and not (
            _is_continuation_fragment(bare_match.group("label")) and merged_match
        ):
            m = bare_match
        elif merged_match:
            m = merged_match
        elif bare_match:
            m = bare_match
        else:
            # No numeric row match at all -- either a section header (e.g.
            # "Age of reference person (years)") or the first half of a
            # wrapped label. Either way, stash it as a lookback candidate;
            # it gets discarded automatically next iteration if the
            # following line turns out to be an independent full match.
            pending = line
            continue

        label = m.group("label").strip()
        if not label:
            pending = ""
            continue
        values = [m.group(i) for i in range(2, 2 + n_numeric_cols)]
        rows.append([label] + values)
        pending = ""

    return rows


def clean_numeric_value(v: str):
    if v == "n.a.":
        return None
    return float(v.replace(",", ""))


def extract_table(pdf: pdfplumber.PDF, page_index: int, n_numeric_cols: int,
                   column_names: list) -> pd.DataFrame:
    page_text = pdf.pages[page_index].extract_text() or ""
    rows = parse_numeric_table(page_text, n_numeric_cols)
    df = pd.DataFrame(rows, columns=["Family characteristic"] + column_names)
    for col in column_names:
        df[col] = df[col].apply(clean_numeric_value)
    return df


def find_table_page(pdf: pdfplumber.PDF, table_prefix: str) -> int:
    """Locate a table by its heading text (e.g. 'Table 5.') rather than a
    hardcoded page number, so this script keeps working if the bulletin's
    pagination changes in a future release."""
    for i, page in enumerate(pdf.pages):
        text = page.extract_text() or ""
        if table_prefix in text[:250]:
            return i
    raise ValueError(f"Could not locate a page starting with '{table_prefix}'")


if __name__ == "__main__":
    if not os.path.exists(SCF_PDF_PATH):
        raise FileNotFoundError(
            f"{SCF_PDF_PATH} not found. Download the SCF Bulletin PDF from "
            f"https://www.federalreserve.gov/publications/files/scf23.pdf "
            f"and place it at data/raw/SCF/scf23.pdf"
        )

    log_rows = []
    with pdfplumber.open(SCF_PDF_PATH) as pdf:
        # --- Table 1: Income ---
        p1 = find_table_page(pdf, "Table 1.")
        table1 = extract_table(
            pdf, p1, 6,
            ["Median_2019", "Median_2022", "Median_pct_change",
             "Mean_2019", "Mean_2022", "Mean_pct_change"]
        )
        out1 = os.path.join(utils.CLEANED_DIR, "scf_table1_income.csv")
        table1.to_csv(out1, index=False)
        log_rows.append({"table": "Table 1 (Income)", "source_page": p1 + 1, "n_rows": len(table1)})
        print(f"Table 1 (Income): {len(table1)} rows extracted from page {p1 + 1} -> {out1}")

        # --- Table 2: Net worth ---
        p2 = find_table_page(pdf, "Table 2.")
        table2 = extract_table(
            pdf, p2, 6,
            ["Median_2019", "Median_2022", "Median_pct_change",
             "Mean_2019", "Mean_2022", "Mean_pct_change"]
        )
        out2 = os.path.join(utils.CLEANED_DIR, "scf_table2_networth.csv")
        table2.to_csv(out2, index=False)
        log_rows.append({"table": "Table 2 (Net Worth)", "source_page": p2 + 1, "n_rows": len(table2)})
        print(f"Table 2 (Net Worth): {len(table2)} rows extracted from page {p2 + 1} -> {out2}")

        # --- Table 5: Debt burden ---
        p5 = find_table_page(pdf, "Table 5.")
        table5 = extract_table(pdf, p5, 5, ["y2010", "y2013", "y2016", "y2019", "y2022"])
        # Table 5's own column header ("Measure of debt burden or
        # interaction" / "with credit markets") wraps across two lines the
        # same way data rows do, and the intervening "2010 2013 2016 2019
        # 2022" year header gets caught by the same merge logic, producing
        # one spurious row. Drop it explicitly -- this is a known artifact
        # of this table's specific layout, not a general parsing concern.
        table5 = table5[table5["Family characteristic"] != "Measure of debt burden or interaction"]
        table5 = table5.reset_index(drop=True)
        out5 = os.path.join(utils.CLEANED_DIR, "scf_table5_debt_burden.csv")
        table5.to_csv(out5, index=False)
        log_rows.append({"table": "Table 5 (Debt Burden)", "source_page": p5 + 1, "n_rows": len(table5)})
        print(f"Table 5 (Debt Burden): {len(table5)} rows extracted from page {p5 + 1} -> {out5}")

    log_path = os.path.join(utils.TABLES_DIR, "scf_extraction_log.csv")
    pd.DataFrame(log_rows).to_csv(log_path, index=False)
    print(f"\nExtraction log -> {log_path}")

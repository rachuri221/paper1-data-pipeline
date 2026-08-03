"""
analysis/utils.py

Shared configuration and utility functions used across the pipeline:
  - file paths for each NFCS wave
  - variable cleaning / recoding
  - effect-size helpers (odds ratio -> Cohen's d, Cramer's V)
  - outcome/control variable definitions

Every other script in analysis/ imports from this module. Keeping the
recoding logic in one place means the 2024-only model, the pooled model,
and the descriptive stats are all guaranteed to use identical variable
definitions -- a single source of truth Lydia can point to if anyone
questions how a variable was constructed.
"""

import os
import numpy as np
import pandas as pd

# --------------------------------------------------------------------------
# Paths
# --------------------------------------------------------------------------

REPO_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
RAW_DIR = os.path.join(REPO_ROOT, "data", "raw")
CLEANED_DIR = os.path.join(REPO_ROOT, "data", "cleaned")
OUTPUTS_DIR = os.path.join(REPO_ROOT, "outputs")
FIGURES_DIR = os.path.join(OUTPUTS_DIR, "figures")
TABLES_DIR = os.path.join(OUTPUTS_DIR, "tables")
MODELS_DIR = os.path.join(OUTPUTS_DIR, "models")
DOCS_DIR = os.path.join(REPO_ROOT, "docs")

for d in (CLEANED_DIR, FIGURES_DIR, TABLES_DIR, MODELS_DIR, DOCS_DIR):
    os.makedirs(d, exist_ok=True)

# NFCS State-by-State (SxS) wave definitions.
# Source: FINRA Investor Education Foundation, https://www.usfinancialcapability.org/downloads.php
# Edit these paths if your local filenames differ after unzipping.
WAVE_PATHS = {
    2018: {
        "csv": os.path.join(RAW_DIR, "NFCS_2018_SxS", "NFCS 2018 State Data 190603.csv"),
        "income_col": "A8",        # 2018 uses an 8-category income variable
        "has_gender": False,        # gender item (A50A) not present in the 2018 questionnaire
    },
    2021: {
        "csv": os.path.join(RAW_DIR, "NFCS_2021_SxS", "NFCS 2021 State Data 220627.csv"),
        "income_col": "A8_2021",    # 2021/2024 use a finer 10-category income variable
        "has_gender": True,
    },
    2024: {
        "csv": os.path.join(RAW_DIR, "NFCS_2024_SxS", "NFCS 2024 State Data 250623.csv"),
        "income_col": "A8_2021",
        "has_gender": True,
    },
}

# --------------------------------------------------------------------------
# Variable dictionary (kept here as the single source of truth; mirrored in
# docs/variable_dictionary.md for human reading)
# --------------------------------------------------------------------------

OUTCOME_LABELS = {
    "overspends": "Spends more than income (past year)",
    "has_emergency_fund": "Has 3-month emergency fund",
    "pays_cc_full": "Always pays credit card in full",
    "revolves_cc_balance": "Carries interest-bearing CC balance",
    "overdraws_checking": "Overdraws checking account",
}

CONTROLS_WITH_GENDER = ["female", "nonwhite", "educ", "income_cat", "age_group"]
CONTROLS_NO_GENDER = ["nonwhite", "educ", "income_cat", "age_group"]  # used for pooled models (2018 lacks gender)

# --------------------------------------------------------------------------
# Cleaning / recoding
# --------------------------------------------------------------------------


def clean_numeric(series: pd.Series) -> pd.Series:
    """Coerce a (possibly string / blank-padded) NFCS column to numeric and
    null out the standard 'Don't know' (98) / 'Refused' (99) codes.

    NFCS CSV exports store skip-logic items as strings with blank cells for
    respondents who weren't asked the question (e.g. credit-card questions
    for people with no credit card). pd.to_numeric with errors='coerce'
    turns those blanks into NaN, which is the correct treatment -- they are
    genuinely missing for that respondent, not a valid response.
    """
    s = pd.to_numeric(series, errors="coerce")
    return s.where(~s.isin([98, 99]), np.nan)


def load_and_recode_wave(csv_path: str, income_col: str, has_gender: bool, wave: int,
                          log_rows: list | None = None) -> pd.DataFrame:
    """
    Load one NFCS State-by-State wave and recode it into the analytic
    variables used throughout this project.

    Parameters
    ----------
    csv_path : path to the raw NFCS "State Data" CSV for this wave
    income_col : 'A8' (2018) or 'A8_2021' (2021, 2024)
    has_gender : whether A50A exists in this wave (False for 2018)
    wave : survey year, stored as a column for pooling / fixed effects
    log_rows : optional list to append cleaning-log dict rows to (for
        docs/cleaning_log.md generation); pass the same list across waves
        to build a combined log.

    Returns
    -------
    DataFrame of recoded analytic variables, one row per respondent.
    """
    raw = pd.read_csv(csv_path, low_memory=False)
    n_raw = len(raw)
    out = pd.DataFrame(index=raw.index)

    def _log(varname, source_col, recoded):
        if log_rows is not None:
            log_rows.append({
                "wave": wave,
                "variable": varname,
                "source_column": source_col,
                "n_valid": int(recoded.notna().sum()),
                "n_missing": int(recoded.isna().sum()),
                "pct_missing": round(100 * recoded.isna().sum() / n_raw, 2),
            })

    # ---- Predictor: financial education exposure ----
    # M20: "Was financial education offered by a school/college/employer,
    #       and did you participate?"
    #   1 = offered, did not participate | 2 = offered, participated | 3 = not offered
    fin_ed = clean_numeric(raw["M20"]).map({1: 0, 2: 1, 3: 0})
    out["fin_ed_exposed"] = fin_ed
    _log("fin_ed_exposed", "M20", fin_ed)

    # ---- Demographics / controls ----
    age_group = clean_numeric(raw["A3Ar_w"])   # 1=18-24 ... 6=65+
    out["age_group"] = age_group
    out["young_adult"] = (age_group == 1).astype(int)
    _log("age_group", "A3Ar_w", age_group)

    if has_gender:
        female = clean_numeric(raw["A50A"]).map({1: 0, 2: 1})
    else:
        female = pd.Series(np.nan, index=raw.index)
    out["female"] = female
    _log("female", "A50A" if has_gender else "(not collected in 2018)", female)

    nonwhite = clean_numeric(raw["A4A_new_w"]).map({1: 0, 2: 1})
    out["nonwhite"] = nonwhite
    _log("nonwhite", "A4A_new_w", nonwhite)

    educ = clean_numeric(raw["A5_2015"])
    out["educ"] = educ
    _log("educ", "A5_2015", educ)

    income_cat = clean_numeric(raw[income_col])
    out["income_cat"] = income_cat
    _log("income_cat", income_col, income_cat)

    # ---- Outcomes ----
    overspends = clean_numeric(raw["J3"]).map({1: 0, 2: 1, 3: 0})
    out["overspends"] = overspends
    _log("overspends", "J3", overspends)

    has_ef = clean_numeric(raw["J5"]).map({1: 1, 2: 0})
    out["has_emergency_fund"] = has_ef
    _log("has_emergency_fund", "J5", has_ef)

    pays_full = clean_numeric(raw["F2_1"]).map({1: 1, 2: 0})
    out["pays_cc_full"] = pays_full
    _log("pays_cc_full", "F2_1", pays_full)

    revolves = clean_numeric(raw["F2_2"]).map({1: 1, 2: 0})
    out["revolves_cc_balance"] = revolves
    _log("revolves_cc_balance", "F2_2", revolves)

    overdraws = clean_numeric(raw["B4"]).map({1: 1, 2: 0})
    out["overdraws_checking"] = overdraws
    _log("overdraws_checking", "B4", overdraws)

    # ---- Weights ----
    out["wgt"] = raw["wgt_n2"] if "wgt_n2" in raw.columns else np.nan

    out["wave"] = wave
    return out.reset_index(drop=True)


# --------------------------------------------------------------------------
# Effect-size helpers
# --------------------------------------------------------------------------


def cohens_d_from_logit(coef: float) -> float:
    """Approximate Cohen's d from a logistic-regression coefficient via the
    standard logit-to-d transform: d = coef * sqrt(3) / pi.

    This treats the binary outcome as generated by an underlying continuous
    logistic latent variable (the standard approach for converting a
    log-odds effect to a standardized-mean-difference-like quantity). It is
    an approximation, not an exact value -- report it as such.
    """
    return coef * (np.sqrt(3) / np.pi)


def cramers_v_from_chi2(chi2: float, n: int, r: int, c: int) -> float:
    """Cramer's V effect size for a chi-square test of independence on an
    r x c contingency table."""
    k = min(r - 1, c - 1)
    if k <= 0 or n <= 0:
        return np.nan
    return np.sqrt(chi2 / (n * k))

"""
analysis/11_knowledge_score_models.py

Re-specifies the four behavioral-outcome models with a different predictor
and a different sample, per Lydia's brief:

  - Predictor: financial knowledge score (NFCS "Big Five" quiz: M6-M10),
    0-5 points, NOT financial-education exposure (M20).
  - Outcomes (binary, same as before): has_emergency_fund (J5),
    pays_cc_full (F2_1), overspends (J3), overdraws_checking (B4).
  - Datasets: NFCS 2018 and 2021, run SEPARATELY (not pooled) -- these are
    the two waves in the paper.
  - Samples, each run separately: (a) 18-24 AND underserved (household
    income < $35,000/year), (b) 18-24 all-income, for comparison.
  - Covariates: race, education, income, gender (gender only in 2021 --
    NOT collected in the 2018 questionnaire, same constraint documented in
    docs/analytical_decisions.md Sec 4 for the M20-based models).
  - Correction: Bonferroni across the 4 outcome tests within each
    wave x sample panel, alpha = 0.01 / 4 = .0025.

IMPORTANT SAMPLE-DEFINITION NOTE (flagged to Lydia's collaborator before
this was run -- see chat): NFCS has no household-size variable and only
banded (not continuous) income, so an exact "% of Federal Poverty Level"
cannot be computed. "Underserved" here is defined as household income
under $35,000/year (NFCS income bands 1-3, identical cutoffs in both
2018 and 2021), NOT a literal FPL percentage. This was chosen over an
approximate FPL proxy (household size assembled from living-arrangement +
dependent-children items) because that proxy is least reliable exactly
for 18-24-year-olds living with parents or roommates -- likely a large
share of this sample -- where "household income" is ambiguous. The
income-band cutoff is simpler, exactly computable from the actual
variable NFCS collects, and avoids introducing that bias. See
docs/analytical_decisions.md Sec 15 for the full reasoning.

Outputs:
  data/cleaned/nfcs_2018_knowledge.csv
  data/cleaned/nfcs_2021_knowledge.csv
  outputs/tables/knowledge_score_results.csv     (all 4 panels, one table)
  outputs/tables/knowledge_score_results_wide.csv (pivoted, easier to scan)
"""

import os
import sys
import warnings
import numpy as np
import pandas as pd
import statsmodels.formula.api as smf

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import utils

warnings.filterwarnings("ignore")

WAVE_RAW_PATHS = {
    2018: os.path.join(utils.RAW_DIR, "NFCS_2018_SxS", "NFCS 2018 State Data 190603.csv"),
    2021: os.path.join(utils.RAW_DIR, "NFCS_2021_SxS", "NFCS 2021 State Data 220627.csv"),
}
INCOME_COL = {2018: "A8", 2021: "A8_2021"}
HAS_GENDER = {2018: False, 2021: True}

# Correct answers to the NFCS "Big Five" financial knowledge items.
# Source: FINRA Investor Education Foundation NFCS codebook item text.
KNOWLEDGE_KEY = {
    "M6": 1,   # compound interest: "More than $102"
    "M7": 3,   # inflation: "Less than today"
    "M8": 2,   # bond prices vs. interest rates: "They will fall"
    "M9": 1,   # 15-yr vs 30-yr mortgage: "True"
    "M10": 2,  # single stock vs. mutual fund risk: "False"
}

UNDERSERVED_INCOME_BANDS = {1, 2, 3}  # "<$15k", "$15-25k", "$25-35k" -- identical in 2018 and 2021

N_TESTS = 4  # outcomes per panel, for Bonferroni
BONF_ALPHA = 0.01 / N_TESTS


def clean_numeric(series: pd.Series) -> pd.Series:
    s = pd.to_numeric(series, errors="coerce")
    return s.where(~s.isin([98, 99]), np.nan)


def build_knowledge_score(raw: pd.DataFrame) -> pd.Series:
    """0-5 score. 'Don't know' (98) is scored as INCORRECT (0 points for
    that item) -- standard convention in the financial-literacy literature,
    since not knowing the answer is substantively different from refusing
    to answer. 'Refused' (99) is treated as a true missing value for that
    item; if ANY item is refused, the respondent's total score is set to
    missing rather than computed from the remaining items, so the score
    always reflects exactly 5 answered items when non-missing."""
    item_scores = pd.DataFrame(index=raw.index)
    any_refused = pd.Series(False, index=raw.index)

    for item, correct_value in KNOWLEDGE_KEY.items():
        raw_vals = pd.to_numeric(raw[item], errors="coerce")
        refused = raw_vals == 99
        any_refused = any_refused | refused
        # Don't know (98) and any wrong answer both score 0; correct scores 1
        item_scores[item] = (raw_vals == correct_value).astype(int)

    score = item_scores.sum(axis=1)
    score = score.where(~any_refused, np.nan)
    return score


def load_and_recode(wave: int) -> pd.DataFrame:
    raw = pd.read_csv(WAVE_RAW_PATHS[wave], low_memory=False)
    out = pd.DataFrame(index=raw.index)

    out["knowledge_score"] = build_knowledge_score(raw)

    age_group = clean_numeric(raw["A3Ar_w"])
    out["age_group"] = age_group
    out["young_adult"] = (age_group == 1).astype(int)

    income_cat = clean_numeric(raw[INCOME_COL[wave]])
    out["income_cat"] = income_cat
    out["underserved"] = income_cat.isin(UNDERSERVED_INCOME_BANDS).astype(int)
    out.loc[income_cat.isna(), "underserved"] = np.nan

    if HAS_GENDER[wave]:
        out["female"] = clean_numeric(raw["A50A"]).map({1: 0, 2: 1})
    else:
        out["female"] = np.nan

    out["nonwhite"] = clean_numeric(raw["A4A_new_w"]).map({1: 0, 2: 1})
    out["educ"] = clean_numeric(raw["A5_2015"])

    out["overspends"] = clean_numeric(raw["J3"]).map({1: 0, 2: 1, 3: 0})
    out["has_emergency_fund"] = clean_numeric(raw["J5"]).map({1: 1, 2: 0})
    out["pays_cc_full"] = clean_numeric(raw["F2_1"]).map({1: 1, 2: 0})
    out["revolves_cc_balance"] = clean_numeric(raw["F2_2"]).map({1: 1, 2: 0})
    out["overdraws_checking"] = clean_numeric(raw["B4"]).map({1: 1, 2: 0})

    out["wave"] = wave
    return out


OUTCOME_ORDER = {
    "has_emergency_fund": "Has 3-month emergency fund",
    "pays_cc_full": "Always pays credit card in full",
    "overspends": "Spends more than income (past year)",
    "overdraws_checking": "Overdraws checking account",
}


def run_panel(df: pd.DataFrame, wave: int, sample_label: str, has_gender: bool) -> pd.DataFrame:
    controls = ["nonwhite", "educ", "income_cat"] + (["female"] if has_gender else [])
    knowledge_sd = df["knowledge_score"].std()

    results = []
    for outcome, label in OUTCOME_ORDER.items():
        sub = df.dropna(subset=[outcome, "knowledge_score"] + controls).copy()
        control_terms = " + ".join(controls)
        formula = f"{outcome} ~ knowledge_score + {control_terms}"
        n = len(sub)
        if n < 30 or sub[outcome].nunique() < 2:
            results.append({
                "Wave": wave, "Sample": sample_label, "Outcome": label, "N": n,
                "OR (per point)": np.nan, "OR_CI_low": np.nan, "OR_CI_high": np.nan,
                "p-value": np.nan, "Sig (uncorrected p<.05)": "N/A - insufficient N",
                f"Sig (Bonferroni p<{BONF_ALPHA:.4f})": "N/A - insufficient N",
            })
            continue
        m = smf.logit(formula, data=sub).fit(disp=0)
        coef, p = m.params["knowledge_score"], m.pvalues["knowledge_score"]
        OR = np.exp(coef)
        ci_low, ci_high = np.exp(m.conf_int().loc["knowledge_score"])
        results.append({
            "Wave": wave, "Sample": sample_label, "Outcome": label, "N": int(m.nobs),
            "OR (per point)": OR, "OR_CI_low": ci_low, "OR_CI_high": ci_high,
            "p-value": p,
            "Sig (uncorrected p<.05)": "Yes" if p < 0.05 else "No",
            f"Sig (Bonferroni p<{BONF_ALPHA:.4f})": "Yes" if p < BONF_ALPHA else "No",
        })

    out_df = pd.DataFrame(results)
    out_df["Knowledge score SD (this panel)"] = round(knowledge_sd, 3)
    out_df["Knowledge score mean (this panel)"] = round(df["knowledge_score"].mean(), 3)
    return out_df


if __name__ == "__main__":
    all_results = []

    for wave in [2018, 2021]:
        df = load_and_recode(wave)
        out_path = os.path.join(utils.CLEANED_DIR, f"nfcs_{wave}_knowledge.csv")
        df.to_csv(out_path, index=False)
        print(f"Cleaned {wave}: {len(df):,} rows -> {out_path}")

        young = df[df["young_adult"] == 1].copy()
        underserved = young[young["underserved"] == 1].copy()
        all_income = young.copy()

        print(f"  Wave {wave}: 18-24 N={len(young):,}, of which underserved (<$35k) N={len(underserved):,}")

        panel_underserved = run_panel(underserved, wave, "18-24, underserved (<$35k)", HAS_GENDER[wave])
        panel_all_income = run_panel(all_income, wave, "18-24, all income", HAS_GENDER[wave])
        all_results.append(panel_underserved)
        all_results.append(panel_all_income)

    final = pd.concat(all_results, ignore_index=True)
    cols_order = ["Wave", "Sample", "Outcome", "N", "OR (per point)", "OR_CI_low", "OR_CI_high",
                  "p-value", "Sig (uncorrected p<.05)", f"Sig (Bonferroni p<{BONF_ALPHA:.4f})",
                  "Knowledge score mean (this panel)", "Knowledge score SD (this panel)"]
    final = final[cols_order]

    long_path = os.path.join(utils.TABLES_DIR, "knowledge_score_results.csv")
    final.to_csv(long_path, index=False)
    print(f"\nFull results table -> {long_path}")
    print(final.to_string(index=False))

    wide = final.pivot_table(
        index=["Outcome"], columns=["Wave", "Sample"],
        values="OR (per point)", aggfunc="first"
    )
    wide_path = os.path.join(utils.TABLES_DIR, "knowledge_score_results_wide.csv")
    wide.to_csv(wide_path)
    print(f"\nWide (OR-only) table -> {wide_path}")

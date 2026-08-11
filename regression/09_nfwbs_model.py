"""
analysis/09_nfwbs_model.py

Cleans and analyzes the CFPB National Financial Well-Being Survey (NFWBS)
Public Use File (2016, N=6,394).

IMPORTANT SCOPE NOTE (see docs/analytical_decisions.md for full discussion):
NFWBS has NO item equivalent to NFCS's M20 ("was financial education
offered by a school/employer, did you participate"). It therefore CANNOT
support the same predictor as the NFCS models and is never pooled with
them. What it DOES have is FINSOC2_1 through FINSOC2_7, seven items asking
whether a parent engaged in specific financial-socialization behaviors
(discussed money, taught budgeting, gave an allowance, etc.) while the
respondent was growing up. This script uses a 0-7 sum of those items as a
predictor of INFORMAL financial socialization -- a related but distinct
construct from formal financial education, and the script and its outputs
say so explicitly rather than implying equivalence.

Outcomes modeled:
  - FWBscore: the CFPB's validated Financial Well-Being scale (continuous,
    IRT-based, range ~14-95) -- OLS regression
  - save_habit_top2: "putting money into savings is a habit for me" (top-2-
    box binary) -- logistic regression
  - pays_cc_often_always: "paid off credit card balance in full each
    month," often/always vs less (binary) -- logistic regression
  - ends_meet_difficulty: "somewhat" or "very difficult" covering monthly
    expenses (binary) -- logistic regression

Outputs:
  data/cleaned/nfwbs_cleaned.csv
  outputs/tables/nfwbs_descriptive_stats.csv
  outputs/tables/nfwbs_regression_results.csv
  outputs/figures/nfwbs_fwbscore_by_socialization.png
"""

import os
import sys
import warnings
import numpy as np
import pandas as pd
import statsmodels.formula.api as smf
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import seaborn as sns

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import utils

warnings.filterwarnings("ignore")
sns.set_theme(style="whitegrid", palette="deep")

NFWBS_PATH = os.path.join(utils.RAW_DIR, "NFWBS", "NFWBS_PUF_2016_data.csv")


def clean_nfwbs() -> pd.DataFrame:
    raw = pd.read_csv(NFWBS_PATH, low_memory=False)

    def clean(series):
        s = pd.to_numeric(series, errors="coerce")
        return s.where(s >= 0, np.nan)  # NFWBS uses -1 (Refused) etc as negative sentinel codes

    out = pd.DataFrame(index=raw.index)

    # --- Predictor: parental financial socialization (informal, NOT formal education) ---
    finsoc_items = [f"FINSOC2_{i}" for i in range(1, 8)]
    finsoc_clean = raw[finsoc_items].apply(clean)
    out["fin_socialization_score"] = finsoc_clean.sum(axis=1, skipna=False)  # 0-7, NaN if any item missing
    out["fin_socialization_high"] = (out["fin_socialization_score"] >= 5).astype("Int64")  # top-tercile-ish cut

    # --- Outcomes ---
    out["FWBscore"] = clean(raw["FWBscore"])  # continuous, validated scale

    savehabit = clean(raw["SAVEHABIT"])  # 1-6 scale, 5=Agree, 6=Strongly agree
    out["save_habit_top2"] = savehabit.isin([5, 6]).astype("Int64")
    out.loc[savehabit.isna(), "save_habit_top2"] = pd.NA

    manage1_3 = clean(raw["MANAGE1_3"])  # 1=N/A or never ... 5=Always
    out["pays_cc_often_always"] = manage1_3.isin([4, 5]).astype("Int64")
    out.loc[manage1_3.isna(), "pays_cc_often_always"] = pd.NA

    endsmeet = clean(raw["ENDSMEET"])  # 1=Not at all difficult, 2=Somewhat, 3=Very
    out["ends_meet_difficulty"] = endsmeet.isin([2, 3]).astype("Int64")
    out.loc[endsmeet.isna(), "ends_meet_difficulty"] = pd.NA

    # --- Controls ---
    out["agecat"] = clean(raw["agecat"])
    # agecat==1 is the youngest available GfK KnowledgePanel bracket. The
    # codebook confirms categories 6-8 correspond to ages 62+ (used for the
    # survey's age-62+ oversample); exact upper bound of category 1 is not
    # independently confirmed from the codebook text available at pipeline
    # build time. Treated the same way as NFCS's 18-24 bucket: a disclosed,
    # imperfectly-bounded proxy for "youngest adults," not a precise match
    # to any specific age range.
    out["young_bracket"] = (out["agecat"] == 1).astype(int)
    out["female"] = clean(raw["PPGENDER"]).map({1: 0, 2: 1})  # NFWBS panel coding: 1=Male, 2=Female
    out["educ"] = clean(raw["PPEDUC"])
    out["income"] = clean(raw["PPINCIMP"])
    out["nonwhite"] = clean(raw["PPETHM"]).apply(lambda x: 0 if x == 1 else (1 if pd.notna(x) else np.nan))
    out["weight"] = raw["finalwt"]

    return out


def descriptive_stats(df: pd.DataFrame) -> pd.DataFrame:
    rows = [
        ("N (full sample)", len(df)),
        ("N (young age bracket, agecat==1)", int((df["young_bracket"] == 1).sum())),
        ("Mean financial socialization score (0-7)", round(df["fin_socialization_score"].mean(), 2)),
        ("Mean FWBscore (financial well-being scale)", round(df["FWBscore"].mean(), 2)),
        ("% high financial socialization (score>=5)", round(100 * df["fin_socialization_high"].mean(), 1)),
        ("% save-habit top-2-box", round(100 * df["save_habit_top2"].mean(), 1)),
        ("% pays CC often/always", round(100 * df["pays_cc_often_always"].mean(), 1)),
        ("% difficulty making ends meet", round(100 * df["ends_meet_difficulty"].mean(), 1)),
    ]
    return pd.DataFrame(rows, columns=["Metric", "Value"])


def run_models(df: pd.DataFrame) -> pd.DataFrame:
    controls = ["female", "nonwhite", "educ", "income", "agecat"]
    results = []

    # OLS for the continuous FWB scale
    sub = df.dropna(subset=["FWBscore", "fin_socialization_score"] + controls).copy()
    ols = smf.ols("FWBscore ~ fin_socialization_score + female + nonwhite + educ + income + C(agecat)",
                   data=sub).fit()
    coef, se, p = ols.params["fin_socialization_score"], ols.bse["fin_socialization_score"], ols.pvalues["fin_socialization_score"]
    ci_low, ci_high = ols.conf_int().loc["fin_socialization_score"]
    results.append({
        "Outcome": "FWBscore (financial well-being scale, continuous)", "Model": "OLS", "N": int(ols.nobs),
        "Coefficient": coef, "SE": se, "CI_low": ci_low, "CI_high": ci_high, "p-value": p,
        "Sig (p<.05)": "Yes" if p < 0.05 else "No",
        "Interpretation": "+1 point on 0-7 socialization scale -> associated FWBscore change",
    })

    binary_outcomes = {
        "save_habit_top2": "Savings is a habit (top-2-box)",
        "pays_cc_often_always": "Pays CC in full, often/always",
        "ends_meet_difficulty": "Difficulty making ends meet",
    }
    for outcome, label in binary_outcomes.items():
        sub = df.dropna(subset=[outcome, "fin_socialization_score"] + controls).copy()
        sub[outcome] = sub[outcome].astype(int)
        m = smf.logit(f"{outcome} ~ fin_socialization_score + female + nonwhite + educ + income + C(agecat)",
                       data=sub).fit(disp=0)
        coef, p = m.params["fin_socialization_score"], m.pvalues["fin_socialization_score"]
        OR = np.exp(coef)
        ci_low, ci_high = np.exp(m.conf_int().loc["fin_socialization_score"])
        results.append({
            "Outcome": label, "Model": "Logistic (OR shown)", "N": int(m.nobs),
            "Coefficient": OR, "SE": np.nan, "CI_low": ci_low, "CI_high": ci_high, "p-value": p,
            "Sig (p<.05)": "Yes" if p < 0.05 else "No",
            "Interpretation": "Odds ratio per +1 point on 0-7 socialization scale",
        })

    return pd.DataFrame(results)


def plot_fwb_by_socialization(df: pd.DataFrame, out_path: str) -> None:
    sub = df.dropna(subset=["fin_socialization_score", "FWBscore"])
    fig, ax = plt.subplots(figsize=(7, 4.5))
    means = sub.groupby("fin_socialization_score")["FWBscore"].mean()
    counts = sub.groupby("fin_socialization_score")["FWBscore"].count()
    sns.barplot(x=means.index.astype(int), y=means.values, ax=ax, color="#1F4E79")
    for i, (score, n) in enumerate(counts.items()):
        ax.text(i, means.values[i] + 0.5, f"n={n}", ha="center", fontsize=8)
    ax.set_xlabel("Parental financial socialization score (0-7 items)")
    ax.set_ylabel("Mean FWBscore (financial well-being)")
    ax.set_title("Financial Well-Being by Parental Financial Socialization\n(NFWBS 2016, unadjusted means)")
    fig.tight_layout()
    fig.savefig(out_path, dpi=150)
    plt.close(fig)


if __name__ == "__main__":
    df = clean_nfwbs()
    cleaned_path = os.path.join(utils.CLEANED_DIR, "nfwbs_cleaned.csv")
    df.to_csv(cleaned_path, index=False)
    print(f"Cleaned NFWBS: {len(df):,} rows -> {cleaned_path}")

    desc_df = descriptive_stats(df)
    desc_path = os.path.join(utils.TABLES_DIR, "nfwbs_descriptive_stats.csv")
    desc_df.to_csv(desc_path, index=False)
    print("\n=== NFWBS Descriptive Stats ===")
    print(desc_df.to_string(index=False))

    results_df = run_models(df)
    results_path = os.path.join(utils.TABLES_DIR, "nfwbs_regression_results.csv")
    results_df.to_csv(results_path, index=False)
    print("\n=== NFWBS Regression Results (financial socialization -> outcomes) ===")
    print(results_df.to_string(index=False))

    fig_path = os.path.join(utils.FIGURES_DIR, "nfwbs_fwbscore_by_socialization.png")
    plot_fwb_by_socialization(df, fig_path)
    print(f"\nFigure -> {fig_path}")

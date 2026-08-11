"""
analysis/03_primary_model_2024.py

Primary model (full 2024 NFCS sample) and subgroup model (18-24 year olds,
Bonferroni-corrected), matching the lab's pre-registered significance
thresholds:
  - Primary analyses:  p < .05
  - Subgroup analyses: Bonferroni-corrected, alpha = 0.01 / n_tests

Each logistic-regression association is cross-checked with an independent,
non-model-based test: a chi-square test of independence (exposed vs. not,
by outcome) with Cramer's V as the effect size, via pingouin. This isn't
redundant — it's a robustness check that the regression result isn't an
artifact of the model specification (e.g. control-variable choice, link
function). If the chi-square test and the logistic regression disagree on
direction or significance, that discrepancy is exactly the kind of thing
that should be investigated before anything goes in a draft.

Outputs:
  outputs/tables/2024_primary_results.csv
  outputs/tables/2024_subgroup_results.csv
  outputs/tables/2024_chi_square_crossvalidation.csv
  outputs/figures/2024_primary_forest_plot.png
"""

import os
import sys
import warnings
import numpy as np
import pandas as pd
import statsmodels.formula.api as smf
import pingouin as pg
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import utils

warnings.filterwarnings("ignore")


def load_2024() -> pd.DataFrame:
    path = os.path.join(utils.CLEANED_DIR, "nfcs_2024_cleaned.csv")
    return pd.read_csv(path)


def run_primary(df: pd.DataFrame) -> pd.DataFrame:
    results = []
    for outcome, label in utils.OUTCOME_LABELS.items():
        sub = df.dropna(subset=[outcome, "fin_ed_exposed"] + utils.CONTROLS_WITH_GENDER).copy()
        formula = f"{outcome} ~ fin_ed_exposed + female + nonwhite + educ + income_cat + C(age_group)"
        model = smf.logit(formula, data=sub).fit(disp=0)
        coef = model.params["fin_ed_exposed"]
        se = model.bse["fin_ed_exposed"]
        p = model.pvalues["fin_ed_exposed"]
        OR = np.exp(coef)
        ci_low, ci_high = np.exp(model.conf_int().loc["fin_ed_exposed"])
        results.append({
            "Outcome": label, "N": int(model.nobs), "Coef(logit)": coef, "SE": se,
            "OR": OR, "OR_CI_low": ci_low, "OR_CI_high": ci_high,
            "Cohen's d (approx)": utils.cohens_d_from_logit(coef), "p-value": p,
            "Sig (p<.05)": "Yes" if p < 0.05 else "No",
        })
    return pd.DataFrame(results)


def run_subgroup(df: pd.DataFrame) -> pd.DataFrame:
    young = df[df["young_adult"] == 1].copy()
    n_tests = len(utils.OUTCOME_LABELS)
    bonf_alpha = 0.01 / n_tests
    bonf_col = f"Sig (Bonferroni p<{bonf_alpha:.5f})"

    controls = [c for c in utils.CONTROLS_WITH_GENDER if c != "age_group"]  # constant within subgroup
    results = []
    for outcome, label in utils.OUTCOME_LABELS.items():
        sub = young.dropna(subset=[outcome, "fin_ed_exposed"] + controls).copy()
        formula = f"{outcome} ~ fin_ed_exposed + female + nonwhite + educ + income_cat"
        model = smf.logit(formula, data=sub).fit(disp=0)
        coef, p = model.params["fin_ed_exposed"], model.pvalues["fin_ed_exposed"]
        OR = np.exp(coef)
        ci_low, ci_high = np.exp(model.conf_int().loc["fin_ed_exposed"])
        results.append({
            "Outcome": label, "N": int(model.nobs), "OR": OR,
            "OR_CI_low": ci_low, "OR_CI_high": ci_high,
            "Cohen's d (approx)": utils.cohens_d_from_logit(coef), "p-value": p,
            "Sig (uncorrected p<.05)": "Yes" if p < 0.05 else "No",
            bonf_col: "Yes" if p < bonf_alpha else "No",
        })
    return pd.DataFrame(results)


def run_chi_square_crossvalidation(df: pd.DataFrame) -> pd.DataFrame:
    """Independent cross-check of each outcome~exposure association using a
    chi-square test of independence (pingouin) rather than a regression
    model. No controls -- this deliberately tests the raw bivariate
    association as a sanity check against the adjusted regression result."""
    results = []
    for outcome, label in utils.OUTCOME_LABELS.items():
        sub = df.dropna(subset=[outcome, "fin_ed_exposed"]).copy()
        sub["fin_ed_exposed"] = sub["fin_ed_exposed"].astype(int)
        sub[outcome] = sub[outcome].astype(int)
        expected, observed, stats = pg.chi2_independence(
            data=sub, x="fin_ed_exposed", y=outcome
        )
        row = stats[stats["test"] == "pearson"].iloc[0]
        chi2, dof, p, cramer_v = row["chi2"], row["dof"], row["pval"], row["cramer"]
        results.append({
            "Outcome": label, "N": len(sub), "chi2": chi2, "dof": dof,
            "p-value": p, "Cramer's V": cramer_v,
            "Sig (p<.05)": "Yes" if p < 0.05 else "No",
        })
    return pd.DataFrame(results)


def plot_forest(primary_df: pd.DataFrame, out_path: str) -> None:
    """Forest plot of odds ratios with 95% CI for the primary 2024 model."""
    fig, ax = plt.subplots(figsize=(8, 5))
    y_pos = np.arange(len(primary_df))
    ax.errorbar(
        primary_df["OR"], y_pos,
        xerr=[primary_df["OR"] - primary_df["OR_CI_low"], primary_df["OR_CI_high"] - primary_df["OR"]],
        fmt="o", color="#1F4E79", ecolor="#1F4E79", elinewidth=2, capsize=4, markersize=7,
    )
    ax.axvline(1.0, color="gray", linestyle="--", linewidth=1)
    ax.set_yticks(y_pos)
    ax.set_yticklabels(primary_df["Outcome"])
    ax.invert_yaxis()
    ax.set_xlabel("Odds ratio (95% CI) — financial education exposure")
    ax.set_title("Primary Model (2024): Financial Education Exposure -> Behavioral Outcomes")
    fig.tight_layout()
    fig.savefig(out_path, dpi=150)
    plt.close(fig)


if __name__ == "__main__":
    df = load_2024()

    primary_df = run_primary(df)
    primary_df.to_csv(os.path.join(utils.TABLES_DIR, "2024_primary_results.csv"), index=False)
    print("=== Primary model (2024, full sample) ===")
    print(primary_df.to_string(index=False))

    subgroup_df = run_subgroup(df)
    subgroup_df.to_csv(os.path.join(utils.TABLES_DIR, "2024_subgroup_results.csv"), index=False)
    print("\n=== Subgroup model (2024, ages 18-24, Bonferroni-corrected) ===")
    print(subgroup_df.to_string(index=False))

    chi_df = run_chi_square_crossvalidation(df)
    chi_df.to_csv(os.path.join(utils.TABLES_DIR, "2024_chi_square_crossvalidation.csv"), index=False)
    print("\n=== Chi-square cross-validation (unadjusted bivariate association) ===")
    print(chi_df.to_string(index=False))

    fig_path = os.path.join(utils.FIGURES_DIR, "2024_primary_forest_plot.png")
    plot_forest(primary_df, fig_path)
    print(f"\nForest plot -> {fig_path}")

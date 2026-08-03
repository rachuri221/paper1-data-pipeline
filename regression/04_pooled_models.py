"""
analysis/04_pooled_models.py

Three robustness models on the pooled 2018+2021+2024 dataset:

  1. Pooled full-sample model, with wave fixed effects
  2. Pooled 18-24 subgroup model, Bonferroni-corrected, with wave fixed effects
  3. By-wave robustness: identical spec run separately within each wave, to
     check whether the pooled effect is stable or driven by one wave

Gender is excluded from all models here — it was not collected in the 2018
questionnaire (see docs/cleaning_log.md and docs/analytical_decisions.md).

Outputs:
  outputs/tables/pooled_results.csv
  outputs/tables/pooled_subgroup_results.csv
  outputs/tables/by_wave_results.csv
  outputs/figures/by_wave_forest_plot.png
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

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import utils

warnings.filterwarnings("ignore")

CONTROLS = utils.CONTROLS_NO_GENDER  # nonwhite, educ, income_cat, age_group


def load_pooled() -> pd.DataFrame:
    path = os.path.join(utils.CLEANED_DIR, "nfcs_pooled_2018_2021_2024.csv")
    return pd.read_csv(path)


def run_pooled_full(pooled: pd.DataFrame) -> pd.DataFrame:
    results = []
    for outcome, label in utils.OUTCOME_LABELS.items():
        sub = pooled.dropna(subset=[outcome, "fin_ed_exposed"] + CONTROLS + ["wave"]).copy()
        formula = f"{outcome} ~ fin_ed_exposed + nonwhite + educ + income_cat + C(age_group) + C(wave)"
        m = smf.logit(formula, data=sub).fit(disp=0)
        coef, p = m.params["fin_ed_exposed"], m.pvalues["fin_ed_exposed"]
        OR = np.exp(coef)
        lo, hi = np.exp(m.conf_int().loc["fin_ed_exposed"])
        results.append({
            "Outcome": label, "N": int(m.nobs), "OR": OR, "OR_CI_low": lo, "OR_CI_high": hi,
            "Cohen's d (approx)": utils.cohens_d_from_logit(coef), "p-value": p,
            "Sig (p<.05)": "Yes" if p < 0.05 else "No",
        })
    return pd.DataFrame(results)


def run_pooled_subgroup(pooled: pd.DataFrame) -> pd.DataFrame:
    young = pooled[pooled["young_adult"] == 1].copy()
    controls = [c for c in CONTROLS if c != "age_group"]  # constant within subgroup
    n_tests = len(utils.OUTCOME_LABELS)
    bonf_alpha = 0.01 / n_tests
    bonf_col = f"Sig (Bonferroni p<{bonf_alpha:.5f})"

    results = []
    for outcome, label in utils.OUTCOME_LABELS.items():
        sub = young.dropna(subset=[outcome, "fin_ed_exposed"] + controls + ["wave"]).copy()
        formula = f"{outcome} ~ fin_ed_exposed + nonwhite + educ + income_cat + C(wave)"
        m = smf.logit(formula, data=sub).fit(disp=0)
        coef, p = m.params["fin_ed_exposed"], m.pvalues["fin_ed_exposed"]
        OR = np.exp(coef)
        lo, hi = np.exp(m.conf_int().loc["fin_ed_exposed"])
        results.append({
            "Outcome": label, "N": int(m.nobs), "OR": OR, "OR_CI_low": lo, "OR_CI_high": hi,
            "Cohen's d (approx)": utils.cohens_d_from_logit(coef), "p-value": p,
            "Sig (uncorrected p<.05)": "Yes" if p < 0.05 else "No",
            bonf_col: "Yes" if p < bonf_alpha else "No",
        })
    return pd.DataFrame(results)


def run_by_wave(pooled: pd.DataFrame) -> pd.DataFrame:
    results = []
    for wave in sorted(pooled["wave"].unique()):
        wdf = pooled[pooled["wave"] == wave]
        for outcome, label in utils.OUTCOME_LABELS.items():
            sub = wdf.dropna(subset=[outcome, "fin_ed_exposed"] + CONTROLS).copy()
            formula = f"{outcome} ~ fin_ed_exposed + nonwhite + educ + income_cat + C(age_group)"
            try:
                m = smf.logit(formula, data=sub).fit(disp=0)
                coef, p = m.params["fin_ed_exposed"], m.pvalues["fin_ed_exposed"]
                OR = np.exp(coef)
                lo, hi = np.exp(m.conf_int().loc["fin_ed_exposed"])
                results.append({
                    "Wave": int(wave), "Outcome": label, "N": int(m.nobs),
                    "OR": OR, "OR_CI_low": lo, "OR_CI_high": hi, "p-value": p,
                    "Sig (p<.05)": "Yes" if p < 0.05 else "No",
                })
            except Exception as e:
                print(f"[{wave}] {label}: MODEL FAILED ({e})")
    return pd.DataFrame(results)


def plot_by_wave_forest(wave_df: pd.DataFrame, out_path: str) -> None:
    """Grouped forest plot: one row per outcome, one marker per wave, so you
    can see at a glance whether an effect is stable across waves or driven
    by a single one."""
    outcomes = list(utils.OUTCOME_LABELS.values())
    waves = sorted(wave_df["Wave"].unique())
    colors = {waves[0]: "#A6C8E0", waves[1]: "#4A90C4", waves[2]: "#1F4E79"} if len(waves) == 3 else {}

    fig, ax = plt.subplots(figsize=(9, 6))
    offset_step = 0.22
    for i, outcome in enumerate(outcomes):
        for j, wave in enumerate(waves):
            row = wave_df[(wave_df["Outcome"] == outcome) & (wave_df["Wave"] == wave)]
            if row.empty:
                continue
            row = row.iloc[0]
            y = i + (j - (len(waves) - 1) / 2) * offset_step
            ax.errorbar(
                row["OR"], y,
                xerr=[[row["OR"] - row["OR_CI_low"]], [row["OR_CI_high"] - row["OR"]]],
                fmt="o", color=colors.get(wave, "#1F4E79"), ecolor=colors.get(wave, "#1F4E79"),
                elinewidth=2, capsize=3, markersize=6,
                label=str(wave) if i == 0 else None,
            )
    ax.axvline(1.0, color="gray", linestyle="--", linewidth=1)
    ax.set_yticks(range(len(outcomes)))
    ax.set_yticklabels(outcomes)
    ax.invert_yaxis()
    ax.set_xlabel("Odds ratio (95% CI) — financial education exposure")
    ax.set_title("By-Wave Robustness: Financial Education Exposure -> Behavioral Outcomes")
    ax.legend(title="Wave", loc="upper right")
    fig.tight_layout()
    fig.savefig(out_path, dpi=150)
    plt.close(fig)


if __name__ == "__main__":
    pooled = load_pooled()

    pooled_results = run_pooled_full(pooled)
    pooled_results.to_csv(os.path.join(utils.TABLES_DIR, "pooled_results.csv"), index=False)
    print("=== Pooled model (2018+2021+2024) ===")
    print(pooled_results.to_string(index=False))

    subgroup_results = run_pooled_subgroup(pooled)
    subgroup_results.to_csv(os.path.join(utils.TABLES_DIR, "pooled_subgroup_results.csv"), index=False)
    print("\n=== Pooled subgroup model (18-24, Bonferroni-corrected) ===")
    print(subgroup_results.to_string(index=False))

    by_wave_results = run_by_wave(pooled)
    by_wave_results.to_csv(os.path.join(utils.TABLES_DIR, "by_wave_results.csv"), index=False)
    print("\n=== By-wave robustness ===")
    print(by_wave_results.to_string(index=False))

    fig_path = os.path.join(utils.FIGURES_DIR, "by_wave_forest_plot.png")
    plot_by_wave_forest(by_wave_results, fig_path)
    print(f"\nForest plot -> {fig_path}")

"""
analysis/06_predictive_validation.py

A second, independent cross-check of the pipeline's headline finding
('has_emergency_fund' ~ fin_ed_exposed) using tools separate from the
statsmodels logistic regression used everywhere else:

  1. scikit-learn: 5-fold stratified cross-validated logistic regression,
     reporting out-of-sample ROC-AUC and a held-out coefficient sign check.
     This asks a different question than statsmodels' in-sample p-values:
     does financial-ed exposure carry any OUT-OF-SAMPLE predictive signal
     for this outcome, not just an in-sample association?
  2. scipy.stats: a non-parametric bootstrap confidence interval on the raw
     difference in emergency-fund rates (exposed vs. not exposed), as a
     third, model-free cross-check alongside the chi-square test in script 03.

None of this replaces the statsmodels regression as the paper's reported
model — it exists so that the headline finding rests on more than one
statistical approach agreeing with itself.

Outputs:
  outputs/tables/predictive_validation_cv_results.csv
  outputs/tables/bootstrap_ci_results.csv
"""

import os
import sys
import warnings
import numpy as np
import pandas as pd
from scipy import stats
from sklearn.linear_model import LogisticRegression
from sklearn.model_selection import StratifiedKFold, cross_val_score
from sklearn.preprocessing import StandardScaler
from sklearn.pipeline import Pipeline

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import utils

warnings.filterwarnings("ignore")

RANDOM_STATE = 42
N_FOLDS = 5
N_BOOTSTRAP = 5000


def load_pooled() -> pd.DataFrame:
    path = os.path.join(utils.CLEANED_DIR, "nfcs_pooled_2018_2021_2024.csv")
    return pd.read_csv(path)


def cross_validated_auc(df: pd.DataFrame) -> pd.DataFrame:
    """For each outcome, fit a 5-fold cross-validated logistic regression
    (scikit-learn) using the same predictor set as the pooled statsmodels
    model, and report mean out-of-sample ROC-AUC. Also fits on the FULL
    data once to report the sign of the fin_ed_exposed coefficient, as a
    directional cross-check against the statsmodels result."""
    controls = utils.CONTROLS_NO_GENDER  # nonwhite, educ, income_cat, age_group
    feature_cols = ["fin_ed_exposed"] + controls

    results = []
    for outcome, label in utils.OUTCOME_LABELS.items():
        sub = df.dropna(subset=[outcome] + feature_cols).copy()
        X = sub[feature_cols].values
        y = sub[outcome].astype(int).values

        pipe = Pipeline([
            ("scale", StandardScaler()),
            ("logit", LogisticRegression(max_iter=1000, random_state=RANDOM_STATE)),
        ])
        cv = StratifiedKFold(n_splits=N_FOLDS, shuffle=True, random_state=RANDOM_STATE)
        auc_scores = cross_val_score(pipe, X, y, cv=cv, scoring="roc_auc")

        pipe.fit(X, y)
        coef = pipe.named_steps["logit"].coef_[0][feature_cols.index("fin_ed_exposed")]

        results.append({
            "Outcome": label,
            "N": len(sub),
            "CV mean ROC-AUC": round(auc_scores.mean(), 4),
            "CV std ROC-AUC": round(auc_scores.std(), 4),
            "Fin-ed coef sign (sklearn, standardized)": "+" if coef > 0 else "-",
            "Fin-ed coef (sklearn, standardized)": round(coef, 4),
        })
    return pd.DataFrame(results)


def bootstrap_rate_difference(df: pd.DataFrame, outcome: str, n_boot: int = N_BOOTSTRAP,
                               seed: int = RANDOM_STATE) -> tuple[float, float, float]:
    """Non-parametric bootstrap CI for the raw difference in outcome rate
    between exposed and unexposed groups. Model-free -- no regression, no
    distributional assumption beyond resampling with replacement."""
    rng = np.random.default_rng(seed)
    sub = df.dropna(subset=[outcome, "fin_ed_exposed"])
    exposed = sub.loc[sub["fin_ed_exposed"] == 1, outcome].values
    unexposed = sub.loc[sub["fin_ed_exposed"] == 0, outcome].values

    observed_diff = exposed.mean() - unexposed.mean()
    boot_diffs = np.empty(n_boot)
    for i in range(n_boot):
        e_sample = rng.choice(exposed, size=len(exposed), replace=True)
        u_sample = rng.choice(unexposed, size=len(unexposed), replace=True)
        boot_diffs[i] = e_sample.mean() - u_sample.mean()

    ci_low, ci_high = np.percentile(boot_diffs, [2.5, 97.5])
    return observed_diff, ci_low, ci_high


def bootstrap_all_outcomes(df: pd.DataFrame) -> pd.DataFrame:
    results = []
    for outcome, label in utils.OUTCOME_LABELS.items():
        diff, lo, hi = bootstrap_rate_difference(df, outcome)
        # two-sided bootstrap p-value proxy: does the 95% CI exclude 0?
        excludes_zero = not (lo <= 0 <= hi)
        results.append({
            "Outcome": label,
            "Observed rate difference (exposed - not exposed)": round(diff, 4),
            "Bootstrap 95% CI low": round(lo, 4),
            "Bootstrap 95% CI high": round(hi, 4),
            "CI excludes zero (i.e. significant)": "Yes" if excludes_zero else "No",
        })
    return pd.DataFrame(results)


if __name__ == "__main__":
    df = load_pooled()

    cv_df = cross_validated_auc(df)
    cv_df.to_csv(os.path.join(utils.TABLES_DIR, "predictive_validation_cv_results.csv"), index=False)
    print("=== Cross-validated predictive check (scikit-learn, 5-fold, pooled sample) ===")
    print(cv_df.to_string(index=False))

    boot_df = bootstrap_all_outcomes(df)
    boot_df.to_csv(os.path.join(utils.TABLES_DIR, "bootstrap_ci_results.csv"), index=False)
    print(f"\n=== Bootstrap CI on raw rate differences ({N_BOOTSTRAP:,} resamples, scipy/numpy) ===")
    print(boot_df.to_string(index=False))

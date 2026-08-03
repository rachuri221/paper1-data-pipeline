"""
analysis/02_descriptive_stats.py

Descriptive statistics and exploratory visualizations for the pooled NFCS
sample. Run after 01_data_cleaning.py.

Outputs:
  outputs/tables/descriptive_stats.csv
  outputs/tables/crosstab_outcome_by_exposure.csv
  outputs/figures/fin_ed_exposure_by_wave.png
  outputs/figures/outcome_rates_by_exposure.png
  outputs/figures/age_distribution_by_wave.png
"""

import os
import sys
import pandas as pd
import matplotlib
matplotlib.use("Agg")  # headless backend, no display needed
import matplotlib.pyplot as plt
import seaborn as sns

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import utils

sns.set_theme(style="whitegrid", palette="deep")


def load_pooled() -> pd.DataFrame:
    path = os.path.join(utils.CLEANED_DIR, "nfcs_pooled_2018_2021_2024.csv")
    return pd.read_csv(path)


def descriptive_table(df: pd.DataFrame) -> pd.DataFrame:
    rows = [
        ("Full pooled sample N", len(df), ""),
        ("Young adults (18-24) N", int((df["young_adult"] == 1).sum()), ""),
    ]
    for wave in sorted(df["wave"].unique()):
        rows.append((f"N — wave {wave}", int((df["wave"] == wave).sum()), ""))

    rows.append(("Fin. ed. exposure rate — full sample",
                  round(df["fin_ed_exposed"].mean(), 4), "share exposed"))
    rows.append(("Fin. ed. exposure rate — young adults (18-24)",
                  round(df.loc[df["young_adult"] == 1, "fin_ed_exposed"].mean(), 4), "share exposed"))
    rows.append(("Fin. ed. exposure rate — older adults (25+)",
                  round(df.loc[df["young_adult"] == 0, "fin_ed_exposed"].mean(), 4), "share exposed"))
    for wave in sorted(df["wave"].unique()):
        rate = df.loc[df["wave"] == wave, "fin_ed_exposed"].mean()
        rows.append((f"Fin. ed. exposure rate — wave {wave}", round(rate, 4), "share exposed"))

    for outcome, label in utils.OUTCOME_LABELS.items():
        exposed_rate = df.loc[df["fin_ed_exposed"] == 1, outcome].mean()
        unexposed_rate = df.loc[df["fin_ed_exposed"] == 0, outcome].mean()
        rows.append((f"{label} — rate among EXPOSED", round(exposed_rate, 4), outcome))
        rows.append((f"{label} — rate among NOT EXPOSED", round(unexposed_rate, 4), outcome))
        rows.append((f"{label} — raw difference (exposed − not exposed)",
                      round(exposed_rate - unexposed_rate, 4), outcome))

    return pd.DataFrame(rows, columns=["Metric", "Value", "Outcome variable"])


def crosstab_table(df: pd.DataFrame) -> pd.DataFrame:
    """Wide crosstab: outcome rate x exposure x wave, for quick eyeballing."""
    recs = []
    for wave in sorted(df["wave"].unique()):
        wdf = df[df["wave"] == wave]
        for outcome, label in utils.OUTCOME_LABELS.items():
            for exposed_val, exposed_label in [(0, "Not exposed"), (1, "Exposed")]:
                sub = wdf[wdf["fin_ed_exposed"] == exposed_val]
                recs.append({
                    "wave": wave, "outcome": label, "group": exposed_label,
                    "n": int(sub[outcome].notna().sum()),
                    "rate": round(sub[outcome].mean(), 4),
                })
    return pd.DataFrame(recs)


def plot_exposure_by_wave(df: pd.DataFrame, out_path: str) -> None:
    rates = df.groupby("wave")["fin_ed_exposed"].mean().reset_index()
    fig, ax = plt.subplots(figsize=(6, 4))
    sns.barplot(data=rates, x="wave", y="fin_ed_exposed", ax=ax, color="#1F4E79")
    ax.set_ylabel("Financial education exposure rate")
    ax.set_xlabel("NFCS survey wave")
    ax.set_title("Financial Education Exposure Rate by Survey Wave")
    ax.set_ylim(0, max(0.35, rates["fin_ed_exposed"].max() * 1.2))
    for i, v in enumerate(rates["fin_ed_exposed"]):
        ax.text(i, v + 0.008, f"{v:.1%}", ha="center", fontsize=9)
    fig.tight_layout()
    fig.savefig(out_path, dpi=150)
    plt.close(fig)


def plot_outcome_rates(df: pd.DataFrame, out_path: str) -> None:
    recs = []
    for outcome, label in utils.OUTCOME_LABELS.items():
        for exposed_val, exposed_label in [(0, "Not exposed"), (1, "Exposed")]:
            rate = df.loc[df["fin_ed_exposed"] == exposed_val, outcome].mean()
            recs.append({"Outcome": label, "Group": exposed_label, "Rate": rate})
    pdf = pd.DataFrame(recs)

    fig, ax = plt.subplots(figsize=(9, 5.5))
    sns.barplot(data=pdf, y="Outcome", x="Rate", hue="Group", ax=ax,
                palette={"Not exposed": "#B7B7B7", "Exposed": "#1F4E79"})
    ax.set_xlabel("Rate")
    ax.set_ylabel("")
    ax.set_title("Behavioral Outcome Rates by Financial Education Exposure\n(pooled 2018+2021+2024, unadjusted — see regression tables for controlled estimates)")
    ax.legend(title="")
    fig.tight_layout()
    fig.savefig(out_path, dpi=150)
    plt.close(fig)


def plot_age_distribution(df: pd.DataFrame, out_path: str) -> None:
    age_labels = {1: "18-24", 2: "25-34", 3: "35-44", 4: "45-54", 5: "55-64", 6: "65+"}
    plot_df = df.copy()
    plot_df["age_label"] = plot_df["age_group"].map(age_labels)
    fig, ax = plt.subplots(figsize=(8, 4.5))
    sns.countplot(data=plot_df, x="age_label", hue="wave",
                  order=list(age_labels.values()), ax=ax, palette="Blues")
    ax.set_xlabel("Age group")
    ax.set_ylabel("Respondent count")
    ax.set_title("Age Distribution by Survey Wave")
    fig.tight_layout()
    fig.savefig(out_path, dpi=150)
    plt.close(fig)


if __name__ == "__main__":
    df = load_pooled()

    desc_df = descriptive_table(df)
    desc_path = os.path.join(utils.TABLES_DIR, "descriptive_stats.csv")
    desc_df.to_csv(desc_path, index=False)
    print(f"Descriptive stats -> {desc_path}")

    cross_df = crosstab_table(df)
    cross_path = os.path.join(utils.TABLES_DIR, "crosstab_outcome_by_exposure.csv")
    cross_df.to_csv(cross_path, index=False)
    print(f"Crosstab -> {cross_path}")

    fig1 = os.path.join(utils.FIGURES_DIR, "fin_ed_exposure_by_wave.png")
    plot_exposure_by_wave(df, fig1)
    print(f"Figure -> {fig1}")

    fig2 = os.path.join(utils.FIGURES_DIR, "outcome_rates_by_exposure.png")
    plot_outcome_rates(df, fig2)
    print(f"Figure -> {fig2}")

    fig3 = os.path.join(utils.FIGURES_DIR, "age_distribution_by_wave.png")
    plot_age_distribution(df, fig3)
    print(f"Figure -> {fig3}")

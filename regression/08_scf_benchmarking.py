"""
analysis/08_scf_benchmarking.py

Uses the SCF tables extracted by 07_scf_extraction.py to benchmark the
NFCS young-adult (18-24) sample against national population figures.
SCF has no financial-education variable and is aggregate/summary data
(not respondent microdata), so it cannot enter the regression models --
its role here is strictly descriptive context: how does the "Age of
reference person: Less than 35" SCF group compare to national medians,
and how does credit behavior for the whole population compare over time.

This directly implements the role your dataset catalog assigned to SCF:
"Used primarily for benchmarking in results section."

Outputs:
  outputs/tables/scf_benchmark_summary.csv
  outputs/figures/scf_income_by_age_2022.png
  outputs/figures/scf_credit_constrained_trend.png
"""

import os
import sys
import pandas as pd
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import seaborn as sns

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import utils

sns.set_theme(style="whitegrid", palette="deep")


def load_scf_tables():
    t1 = pd.read_csv(os.path.join(utils.CLEANED_DIR, "scf_table1_income.csv"))
    t2 = pd.read_csv(os.path.join(utils.CLEANED_DIR, "scf_table2_networth.csv"))
    t5 = pd.read_csv(os.path.join(utils.CLEANED_DIR, "scf_table5_debt_burden.csv"))
    return t1, t2, t5


def build_benchmark_summary(t1: pd.DataFrame, t2: pd.DataFrame, t5: pd.DataFrame) -> pd.DataFrame:
    rows = []

    all_fam = t1[t1["Family characteristic"] == "All families"].iloc[0]
    rows.append({
        "Metric": "Median family income, all families (SCF 2022)",
        "Value": all_fam["Median_2022"], "Unit": "$ thousands"
    })
    under35 = t1[t1["Family characteristic"] == "Less than 35"].iloc[0]
    rows.append({
        "Metric": "Median family income, age <35, reference person (SCF 2022)",
        "Value": under35["Median_2022"], "Unit": "$ thousands"
    })
    rows.append({
        "Metric": "Under-35 median income as % of all-families median (SCF 2022)",
        "Value": round(100 * under35["Median_2022"] / all_fam["Median_2022"], 1), "Unit": "%"
    })

    nw_all = t2[t2["Family characteristic"] == "All families"].iloc[0]
    nw_under35 = t2[t2["Family characteristic"] == "Less than 35"].iloc[0]
    rows.append({
        "Metric": "Median net worth, all families (SCF 2022)",
        "Value": nw_all["Median_2022"], "Unit": "$ thousands"
    })
    rows.append({
        "Metric": "Median net worth, age <35, reference person (SCF 2022)",
        "Value": nw_under35["Median_2022"], "Unit": "$ thousands"
    })
    rows.append({
        "Metric": "Under-35 median net worth as % of all-families median (SCF 2022)",
        "Value": round(100 * nw_under35["Median_2022"] / nw_all["Median_2022"], 1), "Unit": "%"
    })

    cc_convenience = t5[t5["Family characteristic"].str.contains("convenience only", na=False)].iloc[0]
    rows.append({
        "Metric": "% of all families using credit cards for convenience only, i.e. pay in full (SCF 2022, national)",
        "Value": cc_convenience["y2022"], "Unit": "%"
    })
    rows.append({
        "Metric": "Same, SCF 2010 (for trend comparison)",
        "Value": cc_convenience["y2010"], "Unit": "%"
    })

    late = t5[t5["Family characteristic"] == "Late on payments"].iloc[0]
    rows.append({"Metric": "% of all families late on payments (SCF 2022, national)",
                  "Value": late["y2022"], "Unit": "%"})
    rows.append({"Metric": "Same, SCF 2010 (for trend comparison)",
                  "Value": late["y2010"], "Unit": "%"})

    return pd.DataFrame(rows)


def compare_to_nfcs(summary_df: pd.DataFrame) -> pd.DataFrame:
    """Pull the matching NFCS 2024 rate for 'always pays credit card in
    full' among 18-24 year olds, and put it side by side with the SCF
    national benchmark. This is descriptive juxtaposition only -- the two
    surveys use different populations, question wording, and years, so
    this is NOT a statistical test, just a benchmarking table."""
    nfcs_path = os.path.join(utils.CLEANED_DIR, "nfcs_2024_cleaned.csv")
    if not os.path.exists(nfcs_path):
        return pd.DataFrame([{
            "Note": "NFCS 2024 cleaned file not found -- run 01_data_cleaning.py first "
                    "to enable the NFCS-vs-SCF comparison row."
        }])
    nfcs = pd.read_csv(nfcs_path)
    young = nfcs[nfcs["young_adult"] == 1]
    nfcs_rate = 100 * young["pays_cc_full"].mean()

    return pd.DataFrame([{
        "Comparison": "Always pays credit card in full",
        "SCF 2022 (national, all ages, uses CC 'for convenience only')": summary_df.loc[
            summary_df["Metric"].str.contains("convenience only.*2022", regex=True, na=False), "Value"
        ].iloc[0],
        "NFCS 2024 (ages 18-24 only)": round(nfcs_rate, 1),
        "Note": "Different surveys, populations, question wording, and years -- "
                "descriptive juxtaposition only, not a statistical comparison.",
    }])


def plot_income_by_age(t1: pd.DataFrame, out_path: str) -> None:
    age_rows = t1[t1["Family characteristic"].isin(
        ["Less than 35", "35-44", "45-54", "55-64", "65-74", "75 or more"]
    )].copy()
    order = ["Less than 35", "35-44", "45-54", "55-64", "65-74", "75 or more"]
    age_rows["Family characteristic"] = pd.Categorical(age_rows["Family characteristic"], order)
    age_rows = age_rows.sort_values("Family characteristic")

    fig, ax = plt.subplots(figsize=(8, 4.5))
    x = range(len(age_rows))
    ax.bar([i - 0.2 for i in x], age_rows["Median_2022"], width=0.4, label="Median", color="#1F4E79")
    ax.bar([i + 0.2 for i in x], age_rows["Mean_2022"], width=0.4, label="Mean", color="#A6C8E0")
    ax.set_xticks(list(x))
    ax.set_xticklabels(age_rows["Family characteristic"])
    ax.set_ylabel("2022 dollars (thousands)")
    ax.set_title("SCF 2022: Family Income by Age of Reference Person (National Benchmark)")
    ax.legend()
    fig.tight_layout()
    fig.savefig(out_path, dpi=150)
    plt.close(fig)


def plot_credit_trend(t5: pd.DataFrame, out_path: str) -> None:
    row = t5[t5["Family characteristic"].str.contains("convenience only", na=False)].iloc[0]
    late_row = t5[t5["Family characteristic"] == "Late on payments"].iloc[0]
    years = ["y2010", "y2013", "y2016", "y2019", "y2022"]
    year_labels = [2010, 2013, 2016, 2019, 2022]

    fig, ax = plt.subplots(figsize=(7, 4.5))
    ax.plot(year_labels, [row[y] for y in years], marker="o", label="Pays CC in full (convenience only)", color="#1F4E79")
    ax.plot(year_labels, [late_row[y] for y in years], marker="o", label="Late on payments", color="#C0504D")
    ax.set_xlabel("SCF survey wave")
    ax.set_ylabel("% of all families (national)")
    ax.set_title("SCF National Trends: Credit Card Behavior, 2010-2022")
    ax.legend()
    fig.tight_layout()
    fig.savefig(out_path, dpi=150)
    plt.close(fig)


if __name__ == "__main__":
    t1, t2, t5 = load_scf_tables()

    summary_df = build_benchmark_summary(t1, t2, t5)
    summary_path = os.path.join(utils.TABLES_DIR, "scf_benchmark_summary.csv")
    summary_df.to_csv(summary_path, index=False)
    print("=== SCF Benchmark Summary ===")
    print(summary_df.to_string(index=False))

    comparison_df = compare_to_nfcs(summary_df)
    comparison_path = os.path.join(utils.TABLES_DIR, "scf_vs_nfcs_comparison.csv")
    comparison_df.to_csv(comparison_path, index=False)
    print("\n=== SCF vs. NFCS Descriptive Comparison ===")
    print(comparison_df.to_string(index=False))

    fig1 = os.path.join(utils.FIGURES_DIR, "scf_income_by_age_2022.png")
    plot_income_by_age(t1, fig1)
    print(f"\nFigure -> {fig1}")

    fig2 = os.path.join(utils.FIGURES_DIR, "scf_credit_constrained_trend.png")
    plot_credit_trend(t5, fig2)
    print(f"Figure -> {fig2}")

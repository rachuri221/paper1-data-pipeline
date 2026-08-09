# Paper 1 — Financial Literacy Education and Behavioral Outcomes

This repository contains the data pipeline, cleaning procedures, analysis
scripts, and outputs for Paper 1 research.

## Repository Structure

- `data/raw/` → Original datasets
- `data/cleaned/` → Processed datasets
- `analysis/` → Analysis scripts and notebooks
- `outputs/` → Figures, tables, and model outputs
- `docs/` → Cleaning logs and analytical decisions

```
.
├── data/
│   ├── raw/                              # source downloads go here (gitignored)
│   │   ├── NFCS_2018_SxS/ NFCS_2021_SxS/ NFCS_2024_SxS/
│   │   ├── SCF/scf23.pdf
│   │   └── NFWBS/NFWBS_PUF_2016_data.csv
│   └── cleaned/                          # generated CSVs (gitignored, run pipeline to regenerate)
├── analysis/
│   ├── utils.py                          # shared config, cleaning, effect-size helpers (NFCS)
│   ├── 01_data_cleaning.py               # NFCS raw -> cleaned, writes docs/cleaning_log.md
│   ├── 02_descriptive_stats.py           # NFCS descriptives + exploratory figures
│   ├── 03_primary_model_2024.py          # NFCS 2024 primary + subgroup, chi-square cross-check
│   ├── 04_pooled_models.py               # NFCS pooled 2018+2021+2024 + by-wave robustness
│   ├── 05_build_final_report.py          # NFCS results -> Excel workbook
│   ├── 06_predictive_validation.py       # scikit-learn CV + scipy bootstrap, independent cross-checks
│   ├── 07_scf_extraction.py              # SCF Bulletin PDF -> structured tables (pdfplumber + regex)
│   ├── 08_scf_benchmarking.py            # SCF national benchmarks vs. NFCS young-adult sample
│   ├── 09_nfwbs_model.py                 # NFWBS cleaning + financial-socialization regression models
│   ├── 10_build_supplementary_report.py  # SCF + NFWBS results -> second Excel workbook
│   ├── 11_knowledge_score_models.py      # financial knowledge score -> outcomes, underserved 18-24, 2018/2021
│   └── 12_build_knowledge_score_report.py # knowledge-score results -> third Excel workbook
├── outputs/
│   ├── figures/                          # .png plots (11 total across all scripts)
│   ├── tables/                           # .csv result tables
│   └── models/                           # 2 final .xlsx reports
├── docs/
│   ├── cleaning_log.md                   # auto-generated: NFCS missingness by variable/wave
│   ├── variable_dictionary.md            # every variable, all 3 datasets, source item, coding
│   └── analytical_decisions.md           # 13 sections explaining every modeling choice
├── requirements.txt
└── README.md
```

## Three datasets, three different roles — read this before running anything

This project deliberately does **not** treat every dataset the same way.
Each plays a distinct, documented role (full reasoning in
`docs/analytical_decisions.md`):

| Dataset | Role | Why |
|---|---|---|
| **NFCS** (State-by-State, 2018/2021/2024) | **Primary regression sample.** Has the financial-education-exposure predictor (`M20`) the research question needs. | Only one of the three with a formal financial-education item and adequate sample size for subgroup analysis. |
| **SCF** (Survey of Consumer Finances) | **Benchmarking only.** Never enters a regression. | Publishes aggregate national statistics, not respondent microdata — there's nothing to regress. |
| **NFWBS** (National Financial Well-Being Survey) | **Separate model, different construct.** Never pooled with NFCS. | Has no item equivalent to `M20` — its closest analog (`FINSOC2`, parental financial socialization) measures something related but conceptually distinct from formal financial education. |

If you're citing a number from this repo in the paper, check which
workbook it came from — `NFCS_Financial_Ed_Full_Report.xlsx` is the
primary-hypothesis evidence; `SCF_and_NFWBS_Supplementary_Report.xlsx` is
context and a related-but-different finding, not replication.

## Data Access

All source data are free and public but are **not redistributed in this
repo** (respondent-microdata terms of use + file size).

| Dataset | Source | URL |
|---|---|---|
| NFCS State-by-State 2018/2021/2024 | FINRA Investor Education Foundation | https://www.usfinancialcapability.org/downloads.php |
| SCF Bulletin (`scf23.pdf`) | Federal Reserve Board | https://www.federalreserve.gov/publications/files/scf23.pdf |
| NFWBS PUF (2016) | Consumer Financial Protection Bureau | https://www.consumerfinance.gov/data-research/financial-well-being-survey-data/ |

Place files at the paths referenced in `analysis/utils.py` (`WAVE_PATHS`)
for NFCS, and `analysis/07_scf_extraction.py` / `09_nfwbs_model.py` for
SCF/NFWBS respectively:

```
data/raw/NFCS_2018_SxS/NFCS 2018 State Data 190603.csv
data/raw/NFCS_2021_SxS/NFCS 2021 State Data 220627.csv
data/raw/NFCS_2024_SxS/NFCS 2024 State Data 250623.csv
data/raw/SCF/scf23.pdf
data/raw/NFWBS/NFWBS_PUF_2016_data.csv
```

If your filenames differ, edit the paths in `analysis/utils.py::WAVE_PATHS`
(NFCS) or the `*_PATH` constants at the top of `07_scf_extraction.py` /
`09_nfwbs_model.py`.

**NFCS Investor Survey (`Inv`) files are intentionally not used** anywhere
in this pipeline. See `docs/analytical_decisions.md` §5.

## Setup

```bash
python -m venv .venv
source .venv/bin/activate        # Windows: .venv\Scripts\activate
pip install -r requirements.txt
```

## Running the pipeline

Run in order from the repo root. Scripts 07-10 (SCF/NFWBS) are independent
of 01-06 (NFCS) except for one optional cross-reference (08 reads the 2024
NFCS cleaned file if present, to build a descriptive comparison table —
it degrades gracefully and skips that one row if 01 hasn't been run yet).

```bash
# NFCS pipeline
python analysis/01_data_cleaning.py
python analysis/02_descriptive_stats.py
python analysis/03_primary_model_2024.py
python analysis/04_pooled_models.py
python analysis/05_build_final_report.py
python analysis/06_predictive_validation.py     # optional: independent sklearn/scipy cross-checks

# SCF + NFWBS pipeline
python analysis/07_scf_extraction.py
python analysis/08_scf_benchmarking.py          # run after 01, for the NFCS comparison row
python analysis/09_nfwbs_model.py
python analysis/10_build_supplementary_report.py

# Financial knowledge score models (underserved 18-24, 2018/2021)
python analysis/11_knowledge_score_models.py
python analysis/12_build_knowledge_score_report.py
```

Each script prints its results to the console and writes outputs to
`outputs/`. Two formatted reports land in `outputs/models/`:

**`NFCS_Financial_Ed_Full_Report.xlsx`**

| Sheet | Contents |
|---|---|
| `Methodology` | Data sources, harmonization decisions, caveats, key findings |
| `Descriptive_Stats` | Pooled sample descriptives |
| `Primary_2024` | Full 2024 sample logistic regression |
| `Subgroup_2024_18to24` | 2024 young-adult subgroup, Bonferroni-corrected |
| `ChiSquare_CrossCheck` | Independent bivariate cross-validation (pingouin) |
| `Pooled_AllWaves` | Pooled 2018+2021+2024 full-sample model |
| `Pooled_Subgroup_18to24` | Pooled young-adult subgroup, Bonferroni-corrected |
| `ByWave_Robustness` | Same spec run separately per wave |

**`SCF_and_NFWBS_Supplementary_Report.xlsx`**

| Sheet | Contents |
|---|---|
| `Methodology` | SCF's benchmarking role, NFWBS's different-construct caveat, key finding |
| `SCF_Benchmark_Summary` | National income/net worth/credit figures, young-adult vs. all-families |
| `SCF_Table1_Income` / `SCF_Table2_NetWorth` / `SCF_Table5_DebtBurden` | Full extracted SCF bulletin tables |
| `SCF_vs_NFCS_Comparison` | Descriptive juxtaposition (explicitly not a statistical test) |
| `NFWBS_Descriptive_Stats` | NFWBS sample descriptives |
| `NFWBS_Regression_Results` | Financial socialization -> well-being outcomes |

## Key variables (full detail in `docs/variable_dictionary.md`)

| Variable | Dataset | Source | Definition |
|---|---|---|---|
| `fin_ed_exposed` | NFCS | `M20` | 1 = financial education offered and participated; 0 = not offered or offered-but-declined |
| `overspends` / `has_emergency_fund` / `pays_cc_full` / `revolves_cc_balance` / `overdraws_checking` | NFCS | `J3`/`J5`/`F2_1`/`F2_2`/`B4` | Five behavioral outcomes, see `docs/variable_dictionary.md` |
| `young_adult` | NFCS | derived from `A3Ar_w` | Ages 18-24 — proxy for the paper's 18-22 target population |
| `fin_socialization_score` | NFWBS | sum of `FINSOC2_1..7` | 0-7 count of parental financial-socialization behaviors — informal, NOT formal education |
| `FWBscore` | NFWBS | `FWBscore` | CFPB's validated financial well-being scale |

## Statistical protocol

- **Primary analyses:** logistic regression (NFCS), OLS/logistic (NFWBS), significance threshold p < .05.
- **Subgroup analyses** (NFCS young-adult 18-24 subsample): Bonferroni-corrected
  across the 5 outcome tests, alpha = 0.01 / 5 = .002.
- **Effect sizes:** odds ratios with 95% CI (primary), approximate Cohen's d
  via the logit-to-d transform, Cramer's V for the independent chi-square
  cross-validation (NFCS), OLS coefficients (NFWBS continuous outcome).
- **Robustness:** every NFCS pooled-model finding is checked against (a) the
  same spec run separately in each of the three waves, (b) an independent
  chi-square test of the unadjusted 2024 association, and (c) scikit-learn
  cross-validated out-of-sample AUC + scipy bootstrap CIs.
- **SCF** is descriptive benchmarking only — no significance testing, by design.

## Known limitations

See `docs/analytical_decisions.md` for full detail on each of these:

1. **Correlational, not causal**, for both NFCS and NFWBS models — cross-sectional
   measurement, no random assignment, no panel structure.
2. **Age proxies in both microdata sources.** NFCS's 18-24 and NFWBS's
   `agecat==1` both stand in for "youngest adults available" without
   precisely matching the paper's 18-22 target range.
3. **Cross-wave harmonization** (NFCS): gender unavailable in 2018 (excluded
   from pooled models); income category counts differ slightly by wave.
4. **A significant NFCS finding runs opposite the hypothesis**: financial-ed
   exposure is associated with *higher* odds of overspending and
   overdrafting, replicating across two independent waves. Reported
   explicitly — see the `ByWave_Robustness` sheet.
5. **NFWBS models a different construct than the paper's hypothesis.** Its
   significant, consistent findings on parental financial socialization
   should not be cited as evidence about formal financial-education
   programming specifically.
6. **SCF and NFWBS/NFCS comparisons are descriptive only** — different
   surveys, populations, years, and question wording mean no statistical
   test is implied by any side-by-side table.

## Requirements

```
pandas
numpy
matplotlib
seaborn
statsmodels
scipy
scikit-learn
pingouin
openpyxl
pdfplumber
```

# Variable Dictionary

Every analytic variable used in this pipeline, its NFCS source item, and
how it's recoded. This is the human-readable mirror of the single source of
truth in `analysis/utils.py` (`load_and_recode_wave`) — if the two ever
disagree, the code is correct and this file needs updating.

## Predictor

| Variable | Source | Type | Coding |
|---|---|---|---|
| `fin_ed_exposed` | `M20` | Binary | 1 = offered financial education AND participated; 0 = not offered, or offered but did not participate |

## Outcomes

| Variable | Source | Type | Coding |
|---|---|---|---|
| `overspends` | `J3` | Binary | 1 = household spending exceeded income (past year); 0 = spending less than or about equal to income |
| `has_emergency_fund` | `J5` | Binary | 1 = has a 3-month emergency/rainy-day fund; 0 = does not |
| `pays_cc_full` | `F2_1` | Binary | 1 = always paid credit card balance in full; 0 = did not (asked only of credit card holders) |
| `revolves_cc_balance` | `F2_2` | Binary | 1 = carried an interest-bearing balance in some months; 0 = did not (asked only of credit card holders) |
| `overdraws_checking` | `B4` | Binary | 1 = occasionally overdraws checking account; 0 = does not |

## Demographics / controls

| Variable | Source | Type | Coding |
|---|---|---|---|
| `age_group` | `A3Ar_w` | Ordinal (1-6) | 1=18-24, 2=25-34, 3=35-44, 4=45-54, 5=55-64, 6=65+ |
| `young_adult` | derived from `A3Ar_w` | Binary | 1 if `age_group == 1` (18-24), else 0. Proxy for the paper's 18-22 target population — see `docs/analytical_decisions.md` §2. |
| `female` | `A50A` | Binary | 1 = female, 0 = male. **Not available in 2018** — excluded from all pooled/by-wave models; included in the 2024-only model. |
| `nonwhite` | `A4A_new_w` | Binary | 1 = non-white, 0 = white non-Hispanic |
| `educ` | `A5_2015` | Ordinal (1-7) | 1 = did not complete high school ... 7 = post-graduate degree |
| `income_cat` | `A8` (2018) / `A8_2021` (2021, 2024) | Ordinal | 2018: 8 categories. 2021/2024: 10 categories (finer top-income splits). Not directly comparable at the top end across waves — used as a control only, never as an outcome. |
| `wave` | derived | Integer | 2018, 2021, or 2024 — survey year, used for wave fixed effects in pooled models |
| `wgt` | `wgt_n2` | Float | NFCS national population weight. Present in the cleaned files but **not currently applied** in any model — all regressions in this pipeline are unweighted. If weighted estimates are needed for the paper, this is where to start. |

## Missing data codes

NFCS raw files use `98` = "Don't know" and `99` = "Prefer not to say /
Refused" for most items. `analysis/utils.clean_numeric()` converts both to
`NaN` uniformly across every variable. Credit-card items (`F2_1`, `F2_2`)
additionally have blank cells for respondents who were skipped past those
questions (e.g. no credit card) — these are also `NaN`, and are the main
driver of the higher missingness rates for those two variables (see
`docs/cleaning_log.md`).

## Knowledge-score model variables (analysis/11, separate predictor — see docs/analytical_decisions.md §14-15)

Uses the same NFCS raw files as the primary models, but a different
predictor and sample definition. Cleaned files: `data/cleaned/nfcs_2018_knowledge.csv`,
`data/cleaned/nfcs_2021_knowledge.csv`.

| Variable | Source | Type | Coding |
|---|---|---|---|
| `knowledge_score` | `M6`, `M7`, `M8`, `M9`, `M10` | Integer (0-5) | Count of correct answers to the NFCS "Big Five" financial knowledge quiz. "Don't know" scored as incorrect; "Refused" on any item sets the total to missing. NOT the same construct as `fin_ed_exposed` (`M20`) used elsewhere. |
| `underserved` | derived from `A8`/`A8_2021` | Binary | 1 if household income < $35,000/year (bands 1-3, identical in 2018 and 2021). An income-band proxy for "underserved," not a literal %-of-FPL calculation — NFCS has no household-size variable. See §15. |
| `young_adult` | `A3Ar_w` | Binary | Same 18-24 proxy used throughout this repo |
| `female` | `A50A` | Binary | 2021 only — not collected in 2018 |
| `nonwhite`, `educ`, `income_cat` | same as primary models | — | Same coding as `docs/variable_dictionary.md` primary NFCS section above |

## Files NOT used, and why

| File | Why excluded |
|---|---|
| NFCS Investor Survey (`Inv`), all waves | Screened to investment-account holders; not representative of the target population. See `docs/analytical_decisions.md` §5. |

## SCF variables (benchmarking only — not pooled)

Extracted programmatically from `scf23.pdf` by `analysis/07_scf_extraction.py`.
Aggregate national statistics, not respondent microdata.

| Table | File | Columns |
|---|---|---|
| Table 1 (Income) | `data/cleaned/scf_table1_income.csv` | `Family characteristic`, `Median_2019`, `Median_2022`, `Median_pct_change`, `Mean_2019`, `Mean_2022`, `Mean_pct_change` |
| Table 2 (Net Worth) | `data/cleaned/scf_table2_networth.csv` | same structure as Table 1 |
| Table 5 (Debt Burden) | `data/cleaned/scf_table5_debt_burden.csv` | `Family characteristic`, `y2010`, `y2013`, `y2016`, `y2019`, `y2022` |

## NFWBS variables (informal financial socialization — not formal education)

From `NFWBS_PUF_2016_data.csv`, cleaned by `analysis/09_nfwbs_model.py`.
**No item here is equivalent to NFCS's `M20`** — see `docs/analytical_decisions.md` §13.

| Variable | Source | Type | Coding |
|---|---|---|---|
| `fin_socialization_score` | sum of `FINSOC2_1`...`FINSOC2_7` | Integer (0-7) | Count of parental financial-socialization behaviors reported (informal, retrospective — NOT a formal-education exposure measure) |
| `fin_socialization_high` | derived | Binary | 1 if `fin_socialization_score >= 5` |
| `FWBscore` | `FWBscore` | Continuous (~14-95) | CFPB's validated IRT-based financial well-being scale score |
| `save_habit_top2` | `SAVEHABIT` | Binary | 1 if respondent selected "Agree" or "Strongly agree" (top 2 of 6-point scale) to "putting money into savings is a habit for me" |
| `pays_cc_often_always` | `MANAGE1_3` | Binary | 1 if "Often" or "Always" paid off credit card balance in full each month |
| `ends_meet_difficulty` | `ENDSMEET` | Binary | 1 if "Somewhat difficult" or "Very difficult" covering monthly expenses |
| `young_bracket` | derived from `agecat` | Binary | 1 if `agecat == 1` (youngest available bracket, n=414) — exact age bounds not independently confirmed, treated as a disclosed proxy, same caveat as NFCS's 18-24 bucket |
| `female` | `PPGENDER` | Binary | 1 = female, 0 = male |
| `educ` | `PPEDUC` | Ordinal | GfK panel education categories |
| `income` | `PPINCIMP` | Ordinal | GfK panel household income categories |
| `nonwhite` | `PPETHM` | Binary | 1 = non-white, 0 = white non-Hispanic |
| `weight` | `finalwt` | Float | NFWBS final survey weight (present in cleaned file, **not currently applied** in any model — same as NFCS's `wgt_n2`) |

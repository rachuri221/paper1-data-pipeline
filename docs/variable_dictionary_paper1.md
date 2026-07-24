# Paper 1 — Variable Dictionary

Owner: Secondary Data Analyst. This documents **every variable in the cleaned
Paper 1 datasets** that Statistician will use to build the regression models. Ranges below are the **actual
post-cleaning values** read from `data/cleaned/<dataset>/<dataset>_clean.csv` (pipeline:
`analysis/paper1_cleaning.py`; naming: `docs/variable_naming_convention.md`; composite construction:
`docs/analysis_decisions.md`).

Datasets (source key): `cfpb_nfwbs_2016` (n=414) · `scf_2022` (n=555 = 111 households ×5 implicates) ·
`nfcs_2018` (n=2,795) · `nfcs_2021` (n=3,009) · `nlsy97_1997cohort` (n=8,984).

Fields per variable: **name · description · type · range after cleaning · source dataset(s) · role · construction.**

---

## A. Outcome (dependent) variables — the four composites, each 0–100

| Variable | Description | Type | Range after cleaning | Source datasets | Role |
|----------|-------------|------|----------------------|-----------------|------|
| `financial_knowledge_score` | Objective financial-literacy score, normalized 0–100 | Continuous | 0–100 (CFPB 13 levels; NFCS {0,20,40,60,80,100}; SCF {0,33.3,66.7,100}) | CFPB, SCF, NFCS 2018/2021 (**NLSY97 = NaN, not fielded**) | Dependent |
| `savings_behavior_index` | Savings-behavior composite, 0–100 (higher = stronger) | Continuous | 0–100 (CFPB continuous; NFCS {0,50,100}; SCF {0,33.3,66.7,100}; NLSY97 {0,100}) | All 5 | Dependent |
| `credit_behavior_index` | Credit-behavior composite, 0–100 | Continuous | 0–100 (NFCS {0,33.3,50,66.7,100}; SCF {33.3,66.7,100}) | NFCS 2018/2021, SCF (**CFPB & NLSY97 = NaN**) | Dependent |
| `spending_behavior_index` | Spending-behavior composite, 0–100 | Continuous | CFPB 6.25–100; NFCS 0–100; SCF 0–83.3 | CFPB, SCF, NFCS 2018/2021 (**NLSY97 = NaN**) | Dependent |

**Construction (item 11) — row-mean of available components, each rescaled to 0–1, ×100:**
- **financial_knowledge_score:** CFPB = mean of 12 objective correct flags (FK1–3 + KH1–9); SCF = `FINLIT`/3;
  NFCS = mean-correct over Big-Five M6–M10, **"Don't know"(98)=incorrect**.
- **savings_behavior_index:** CFPB = SAVEHABIT + SAVINGSRANGES + ABSORBSHOCK; SCF = SAVED + HSAVING + EMERGSAV;
  NFCS = has-savings-account(B2) + emergency-fund(J5); **NLSY97 = checking/savings/MM account ownership (YAST-4400)**.
- **credit_behavior_index:** NFCS = owns-card(G1) + pays-in-full(F2_1) + score-aware(G20); SCF = no-revolving-balance(NOCCBAL)
  + not-late(LATE) + no-bankruptcy(BNKRUPLAST5).
- **spending_behavior_index:** CFPB = PROPPLAN + MANAGE1 + SELFCONTROL; SCF = SPENDLESS + reverse-SPENDMOR + BFINPLAN;
  NFCS = covers-expenses(J4) + spending-vs-income(J32).

> **Comparability caveat (read before pooling):** the same-named composite is built from *different items* in
> each dataset, so scores are **not directly comparable across datasets** (e.g., NFCS knowledge means ≈36–41 vs
> CFPB/SCF ≈63–65 is largely instrument difference). Standardize *within* dataset before any cross-dataset comparison.
> Confidence by dataset is documented in `analysis_decisions.md` (e.g., SCF credit and NFCS/SCF spending are LOW–MEDIUM).

---

## B. Primary independent variable

| Variable | Description | Type | Range after cleaning | Source datasets | Role |
|----------|-------------|------|----------------------|-----------------|------|
| `underserved_200fpl` | Household at or below 200% of the federal poverty line (primary underserved indicator) | Binary | 0/1 (missing: CFPB 5%, NLSY97 31%, others 0%) | All 5 | Independent |

**Construction (item 11):** CFPB = direct `PCTLT200FPL`; SCF = INCOME vs 200% FPL by household size;
NFCS = income-band midpoint vs 200% FPL by household size (**coarse**); NLSY97 = `CV_HH_POV_RATIO` ≤ 200%.
See `underserved_method` for the per-row label. NLSY97/CFPB missings are **held, not imputed**.

---

## C. Control variables

| Variable | Description | Type | Range after cleaning | Source datasets | Role |
|----------|-------------|------|----------------------|-----------------|------|
| `age` | Age in years | Continuous (int) | SCF 18–24; NLSY97 = 20 (age-20 anchor); **CFPB/NFCS = NaN** (banded age only) | SCF, NLSY97 | Control |
| `age_band` | Age band retained | Categorical | `"18-24"` (all rows) | All 5 | Control/metadata |
| `female` | 1 = female, 0 = male | Binary | 0/1 | All 5 | Control |
| `race_ethnicity` | 1=Black, 2=Hispanic, 3=Mixed, 4=Non-Black/Non-Hispanic | Categorical | 1–4 | NLSY97 only | Control |
| `education_level` | Harmonized education: 1=<HS, 2=HS/GED, 3=some college/assoc, 4=bachelor, 5=graduate | Categorical (ordinal) | 1–5 (SCF 1–4; NLSY97 observed 1–2 at age 20; NLSY97 miss 14%) | All 5 | Control |
| `census_region` | 1=Northeast, 2=Midwest/NC, 3=South, 4=West | Categorical | 1–4 (NLSY97 miss 14%; **SCF = NaN**, not in summary extract) | CFPB, NFCS, NLSY97 | Control |
| `household_size` | Persons in the economic unit | Continuous (int) | CFPB 1–5, NFCS 1–6, SCF 1–4, NLSY97 1–13 (miss 13%) | All 5 | Control |
| `household_income_2020_usd` | Annual household income, 2020 USD (CPI-U deflated) | Continuous | CFPB ~16k–189k; NFCS ~7k–334k; SCF ~0.4k–403k; NLSY97 0–593k (miss 31%) | All 5 | Control |
| `income_is_banded` | 1 if income derived from a band midpoint | Binary | CFPB/NFCS = True; SCF/NLSY97 = False | All 5 | Metadata (income precision) |
| `pov_ratio` | Household income-to-poverty ratio (1.0 = at poverty line) | Continuous | 0–26.3 (miss 31%) | NLSY97 only | Control (source of `underserved_200fpl`) |
| `lives_in_parents_home` | 1 if respondent lives in parents' home (income reported is individual) | Binary | 0/1 | NFCS 2018/2021 | Control / FPL caveat flag |
| `net_worth_2020_usd` | Household net worth, 2020 USD | Continuous | 0–902k (miss 46%) | NLSY97 only | Control/auxiliary |
| `financial_assets_age20_2020_usd` | Financial assets at age 20, 2020 USD (topcoded $300k) | Continuous | 0–438k (miss 9%) | NLSY97 only | Control/auxiliary |
| `debt_age20_2020_usd` | Non-housing debt at age 20, 2020 USD (topcoded $370k) | Continuous | 0–292k (miss 7%) | NLSY97 only | Control/auxiliary |
| `asvab_math_verbal_pctile` | ASVAB math+verbal percentile — **numeracy proxy, NOT financial literacy** | Continuous | 0–100 (miss 21%) | NLSY97 only | Control |
| `asvab_math_knowledge` | ASVAB math-knowledge ability score | Continuous | 0–2.68 (miss 64%) | NLSY97 only | Control |
| `ap_econ_score` | AP economics exam score | Categorical | 1–5 (**only n=13; ~100% missing — not usable**) | NLSY97 only | Auxiliary |

---

## D. Identifiers & survey metadata (not predictors)

| Variable | Description | Type | Range | Source | Role |
|----------|-------------|------|-------|--------|------|
| `respondent_id` | Unique respondent id | ID | unique per row | All 5 | Identifier |
| `household_id` | Household id (5 imputation implicates share it) | ID | 111 unique (×5) | SCF only | **Cluster unit — required for SCF repeated-imputation inference** |
| `source_dataset` | Dataset name | Categorical | 5 values | All 5 | Metadata |
| `survey_year` | Wave year | Categorical/int | 2016/2018/2021/2022; NLSY97 2000–2004 | All 5 | Metadata/period control |
| `weight` | Survey sampling weight | Continuous | CFPB 0.39–6.6, NFCS 0.28–5.2, SCF 1.4k–28k, NLSY97 76k–1.58M | All 5 | Survey weight (**scales differ — normalize within dataset**) |
| `sample_type` | 1=cross-sectional, 0=oversample | Binary | 0/1 | NLSY97 only | Metadata |
| `underserved_method` | How `underserved_200fpl` was constructed for that row | Categorical | 5 labels | All 5 | Metadata |

---

## E. Outcome coverage & modeling notes (for )

**Which datasets carry which outcome** (a model can only include a dataset for an outcome it measures):

| Outcome | CFPB | SCF | NFCS 2018/2021 | NLSY97 |
|---------|:---:|:---:|:---:|:---:|
| financial_knowledge_score | ✅ | ✅ | ✅ | — |
| savings_behavior_index | ✅ | ✅ | ✅ | ✅ (account-ownership, ~79%) |
| credit_behavior_index | — | ✅ | ✅ | — |
| spending_behavior_index | ✅ | ✅ | ✅ | — |

Modeling reminders: (1) SCF must be analyzed with all 5 implicates and clustered on `household_id`
(effective ≈111 households); (2) held-missing variables (`underserved_200fpl`, NLSY97 income/poverty/savings)
were **not imputed** — decide on treatment before estimation; (3) `age` is unavailable for CFPB/NFCS (banded)
— use `age_band`/`survey_year`; (4) do not pool composites across datasets without within-dataset standardization.

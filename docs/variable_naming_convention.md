# Paper 1 — Master Variable Naming Convention (Step 3, item 16)

All cleaned Paper 1 datasets use the **same snake_case canonical names** so variables mean the
same thing across CFPB, SCF, and NFCS. Cleaned files live in `data/cleaned/<dataset>/<dataset>_clean.csv`.
Each cleaned file is a tidy table of these canonical variables. The component items behind each
composite and their exact formulas are documented in `docs/analysis_decisions.md` and
`analysis/paper1_cleaning.py`, so Secondary Data Analyst can recompute any composite from the raw files for his
spot-check validation. Binary variables are coded **0/1** everywhere
(item 19); ages are integers (item 18); income is 2020 USD (item 17).

| Canonical name | Type | Definition / coding | Notes |
|----------------|------|---------------------|-------|
| `source_dataset` | categorical | dataset id: `cfpb_nfwbs_2016`, `scf_2022`, `nfcs_2018`, `nfcs_2021` | |
| `survey_year` | integer | calendar year of the wave | |
| `respondent_id` | id | unique respondent id | SCF: `Y1` (see `household_id`) |
| `household_id` | id | SCF only — `YY1`; 5 imputation implicates share it | not a duplicate (see log) |
| `age` | integer | age in years | only SCF has exact age; CFPB/NFCS banded → `NaN` |
| `age_band` | categorical | `"18-24"` for all retained records | analysis window (was 13–22; changed to 18–24) |
| `female` | binary | 1 = female, 0 = male | CFPB `PPGENDER`, SCF `HHSEX`, NFCS 2018 `A3` / 2021 `A50A` |
| `education_level` | categorical (ordinal) | 1=<HS, 2=HS/GED, 3=some college/associate, 4=bachelor, 5=graduate | harmonized across datasets |
| `census_region` | categorical | 1=NE, 2=MW, 3=South, 4=West | SCF summary extract lacks region → `NaN` |
| `household_size` | integer | persons in the economic unit | derived (see log Step 1) |
| `household_income_2020_usd` | continuous | annual household income, **2020 dollars** (CPI-U) | CFPB/NFCS from band midpoints (`income_is_banded=True`) |
| `income_is_banded` | binary | 1 if income came from a band midpoint (CFPB, NFCS) | SCF continuous = 0 |
| `underserved_200fpl` | binary | 1 = household ≤ 200% federal poverty line (primary underserved indicator) | method in `underserved_method` |
| `underserved_method` | categorical | how the flag was built (direct flag vs constructed) | |
| `lives_in_parents_home` | binary | NFCS only — 1 if `A7`==3 (income reported is individual) | data-quality caveat for FPL |
| `financial_knowledge_score` | continuous 0–100 | objective financial-literacy score, normalized 0–100 (item 20) | composite — see `analysis_decisions.md` |
| `savings_behavior_index` | continuous 0–100 | savings-behavior composite (item 21) | composite |
| `credit_behavior_index` | continuous 0–100 | credit-behavior composite (item 22) | composite; **unusable for CFPB** (81% missing) |
| `spending_behavior_index` | continuous 0–100 | spending-behavior composite (item 23) | composite |
| `weight` | continuous | survey sampling weight | CFPB `finalwt`, SCF `WGT`, NFCS `wgt_n2`; NLSY97 not pulled → `NaN` |
| `race_ethnicity` | categorical | NLSY97 only — 1=Black, 2=Hispanic, 3=Mixed, 4=Non-Black/Non-Hispanic | |
| `sample_type` | binary | NLSY97 only — 1=cross-sectional, 0=oversample | |
| `pov_ratio` | continuous | NLSY97 only — household-income-to-poverty ratio (1.0 = at poverty line) | source of `underserved_200fpl` |
| `net_worth_2020_usd` | continuous | NLSY97 only — household net worth, 2020 USD | control/position |
| `financial_assets_age20_2020_usd` | continuous | NLSY97 only — financial assets at age 20, 2020 USD | control/position |
| `debt_age20_2020_usd` | continuous | NLSY97 only — non-housing debt at age 20, 2020 USD | control/position |
| `asvab_math_verbal_pctile` | continuous 0–100 | NLSY97 only — ASVAB math+verbal percentile | **numeracy control, NOT financial literacy** |
| `asvab_math_knowledge` | continuous | NLSY97 only — ASVAB math-knowledge ability score | numeracy control |
| `ap_econ_score` | categorical | NLSY97 only — AP economics exam score (1–5) | sparse (n=13); not a usable treatment |

**NLSY97 note:** NLSY97 supplies the **savings** outcome only — `savings_behavior_index` = checking/
savings/money-market account ownership (YAST-4400, ~79% coverage). `financial_knowledge_score`,
`credit_behavior_index`, and `spending_behavior_index` are **`NaN`** (not fielded at the 1997–2006 target
years). `underserved_200fpl` is clean (from `pov_ratio` ≤ 200%). ASVAB is a numeracy control, not literacy.
See `cleaning_log.md`.

**Roles for analysis** (for Secondary Data Analyst's variable dictionary / Statistician's models): the four composite
indices are the **dependent (outcome)** variables; `underserved_200fpl` is the primary
**independent** variable; `age`/`female`/`education_level`/`census_region`/`household_income_2020_usd`
are **controls**.

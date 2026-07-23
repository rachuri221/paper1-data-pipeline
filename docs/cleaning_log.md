# Cleaning Log

Document every data cleaning decision here.

## Format

- Date:
- Dataset:
- Change Made:
- Reason:

---

## Assignment 2 — Steps 1–2 audit (no data modified yet; raw files untouched)

Research question: does structured financial literacy education change spending/saving/credit
behavior in underserved teens ages 13–22. Audit scripts: `analysis/_audit.py`,
`analysis/_missingness_audit.py`. Nothing below has been imputed, filtered, or removed — the
flag-and-discuss items are held for Lydia per spec items 12/13/26.

- Date: 2026-07-23
- Dataset: cfpb_financial_wellbeing (NFWBS_PUF_2016_data.csv — 6,394 rows × 217 cols, adult person 18+)
- Change Made: none — audit only
- Reason: Age is banded (`agecat` 1–8, youngest band 18–24 = 414) so the 13–22 filter can't be
  isolated. Has a direct ≤200% FPL flag `PCTLT200FPL` (6.18% coded −5 refused → 5–20% flag).
  Fin-literacy/wellbeing scores (FWBscore, FSscore, LMscore, KHscore, FINKNOWL1–3) all <5% missing.

- Date: 2026-07-23
- Dataset: federal_reserve_scf (SCFP2022.csv — 22,975 rows × 357 cols, household w/ 5 imputation implicates)
- Change Made: none — audit only
- Reason: Fully imputed (0 nulls). `AGE` is continuous but = age of household head (min 18); only
  18–22 = 315 records. No direct ≤200% FPL flag — has continuous `INCOME` but needs household-size
  + poverty threshold to derive FPL. Note: 5 implicates per household (YY1) affects duplicate/ID checks.

- Date: 2026-07-23
- Dataset: nlsy97 (default.csv — 11,551 rows × 6 cols, person)
- Change Made: none — audit only
- Reason: Extract is demographics-only: child id, mother id, race, sex, birth year, version marker.
  No income, no financial-literacy, no savings/credit/spending, no direct age. Not usable for the
  analysis as delivered (see open decision B2).

- Date: 2026-07-23
- Dataset: finra_nfcs (NFCS 2018 — 27,091 rows × 128; NFCS 2021 — 27,118 rows × 126, adult person 18+)
- Change Made: none — audit only
- Reason: Age banded (`A3Ar_w` 1–6, youngest band 18–24 = 2,795 / 3,009) — 13–22 not isolable.
  Income is bands only (`A8`/`A8_2021`) — no direct FPL. Literacy items M6–M10 have high non-response
  (see below). Savings (J5,B1,B2) and credit (F2_1,G1,G20) items <5% missing.

- Date: 2026-07-23
- Dataset: cfpb_youth_survey
- Change Made: none — no data file present in /data/raw/cfpb_youth_survey/ (only empty placeholders)
- Reason: Cannot clean a dataset that is not there (see open decision B1).

### Item 10 — key variables ≥5% missing (documented missing codes treated as missing)
Missing codes: CFPB {−1,−2,−3,−4,−5}; SCF {−1}; NFCS {98 "don't know", 99 "prefer not to say"} + blanks.
All key variables not listed here were <5% → eligible for item-11 auto-imputation once the sample is set.

- CFPB `PCTLT200FPL` — 6.18% (5–20%, item 12: flag before imputing)
- NFCS 2018 `M6` 13.16%, `M9` 16.56% (5–20%, item 12)
- NFCS 2018 `M7` 21.79%, `M8` 37.88%, `M10` 44.65% (>20%, item 13: potentially unusable)
- NFCS 2021 `M6` 15.23% (5–20%); `M7` 23.09%, `M8` 40.43%, `M9` 20.51%, `M10` 45.30% (>20%)
- ⚠️ Caveat: NFCS literacy "missing" is almost entirely code 98 = "Don't know" (99 refused <1%).
  FINRA scores "Don't know" as *incorrect*, not missing — treatment is a flag-and-discuss item (B5).

### Open decisions — RESOLVED (research lead / Lydia, 2026-07-23)
- B1: CFPB Youth Survey — **DROPPED** (not public; removed from the dataset list).
- B2: NLSY97 — **full re-pull used (`nlsy97_20260723_full.*`, 1997 cohort n=8,984)** + custom sampling
  weight. Adds household-income-to-poverty ratio, household size, census region, **YAST savings-account
  ownership** (the real savings outcome), and ASVAB. Per the research lead, **credit behavior and
  financial-literacy knowledge were not fielded in the 1997–2006 target years**, so those two composites
  stay NaN; spending behavior is also unavailable. NLSY97 now contributes a **savings-behavior outcome**
  + a clean underserved indicator + controls. (Earlier 6-col and 39-col position-only extracts moved to
  `_superseded_*` subfolders.)
- B3: age filter — **research lead changed the target bracket from 13–22 to 18–24** to fit the data.
  18–24 now matches the CFPB/NFCS age bands *exactly* (no approximation) and is applied to SCF's
  continuous age directly.
- B4: ≤200% FPL — **option A** (construct from income + household size). See `analysis_decisions.md`.
- B5: NFCS literacy "Don't know" (98) — **scored as incorrect** (not missing); anything still
  ≥5% missing after that is **held, not imputed**, and surfaced for confirmation.

---

## Steps 1–6 — cleaning results (pipeline: `analysis/paper1_cleaning.py`, run 2026-07-23)

Datasets cleaned: CFPB NFWBS 2016, SCF 2022, NFCS 2018, NFCS 2021. (NLSY97 deferred; Youth Survey dropped.)
Cleaned files: `data/cleaned/<dataset>/<dataset>_clean.csv`. Validation JSON: `outputs/validation_summary.json`.
Histograms (item 25): `outputs/histograms/<dataset>/`.

- Date: 2026-07-23
- Dataset: cfpb_nfwbs_2016
- Change Made: age filter 18–24 (`agecat`==1) → 6,394 → **414** (93.5% removed). Underserved = direct
  `PCTLT200FPL` (20 records = 4.8% coded −5 refused → HELD, not imputed — it's the population-definition
  variable). Income → 2020 USD from `PPINCIMP` band midpoints. Composites built (item 20–23). <5%
  imputation: savings_behavior_index 0.24%, spending_behavior_index 0.48% (median). 0 records dropped
  (item 14: all had ≥1 outcome). Final n = **414**.
- Reason: See `analysis_decisions.md` for composite construction. **Decision 2026-07-23:
  credit_behavior_index EXCLUDED for CFPB** (was 81% missing / biased subset) — set to NaN for all 414,
  column kept for cross-dataset schema consistency. **underserved_200fpl 20 refusals HELD as missing**
  (not mode-imputed — it's the population-definition variable).

- Date: 2026-07-23
- Dataset: scf_2022
- Change Made: age filter 18–24 (continuous `AGE`) → 22,975 → **555** (97.6% removed; = 111 households ×
  5 implicates). Underserved = INCOME vs 200% FPL by household size. Income → 2020 USD (CPI). Knowledge =
  `FINLIT` (objective). No imputation needed (SCF fully imputed at source). 0 dropped. Final n = **555**.
- Reason: `household_id` (`YY1`) repeats 5× by design (multiple-imputation implicates) — NOT duplicates.

- Date: 2026-07-23
- Dataset: nfcs_2018
- Change Made: age filter 18–24 (`A3Ar_w`==1) → 27,091 → **2,795** (89.7% removed). Underserved =
  income-band midpoint vs 200% FPL by household size (1 + partner + dependent children). Literacy
  (M6–M10) with DK=incorrect. <5% imputation: savings 1.43%, spending 2.72% (median). 0 dropped. Final n = **2,795**.
- Reason: `lives_in_parents_home` flagged (A7==3) — income is individual there (FPL caveat).

- Date: 2026-07-23
- Dataset: nfcs_2021
- Change Made: age filter 18–24 (`A3Ar_w`==1) → 27,118 → **3,009** (88.9% removed). Same construction as
  2018; gender from `A50A` (2021) not `A3`. <5% imputation: savings 2.19%, spending 2.76% (median).
  0 dropped. Final n = **3,009**.
- Reason: same FPL caveat as 2018.

- Date: 2026-07-23
- Dataset: nlsy97_1997cohort (full extract `nlsy97_20260723_full.*` + custom weight)
- Change Made: built an **age-20 cross-section** (n=**8,984**) — every respondent (born 1980–84) is 18–24
  at age 20; income/education/net-worth/poverty-ratio/household-size/region taken from each respondent's
  age-20 survey year (2000–2004); savings-account ownership from YAST-4400; assets/debt from the age-20
  anchors; ASVAB (one-time) as a numeracy control. Dollar amounts deflated to 2020 USD. NLS negative
  codes (−1..−5) and HGC=95 → missing. **No imputation** (all ≥5%-missing vars held per B5). Custom
  sampling weight merged on PUBID. No records dropped.
- Reason: **Savings behavior IS measured** → `savings_behavior_index` = checking/savings/money-market
  account ownership ×100 (1 of 3 spec components; NLSY97 lacks a saving-frequency & emergency-fund item).
  **Credit & financial-literacy knowledge were NOT fielded 1997–2006, and spending isn't available** →
  those three composites are **NaN**. `underserved_200fpl` is now **clean** — NLSY97 household-income-to
  -poverty ratio ≤ 200% (no more assumed household size). Missingness HELD & flagged: savings **21.3% (>20%)**,
  poverty ratio/income **30.6%**, education 14.3%, household size 13.3%, ASVAB 21%. Extra control columns:
  `pov_ratio`, `household_size`, `net_worth_2020_usd`, `financial_assets_age20_2020_usd`, `debt_age20_2020_usd`,
  `asvab_math_verbal_pctile`, `asvab_math_knowledge`, `ap_econ_score` (sparse), `race_ethnicity`, `sample_type`, `weight`.

### Step 5 — validation outputs (items 24–28)
- Null check (item 24): 0 nulls in primary outcomes after imputation for SCF/NFCS. CFPB: 0 except
  `credit_behavior_index` (414 = excluded by decision) and `underserved_200fpl` (20 = 4.8%, HELD).
- Range check (item 27): 0 violations (all indices ∈ [0,100], income > 0, age ∈ [18,24]).
- Duplicate check (item 28): 0 duplicate `respondent_id` in any dataset. (SCF `household_id` repeats
  5× by design — documented, not a duplicate.)
- Outliers >3 SD (item 26 — **FLAGGED, none removed; decision 2026-07-23 = keep all**): CFPB knowledge 3,
  spending 3; SCF income 5, spending 5; NFCS 2018 income 60; NFCS 2021 income 49; NLSY97 income 199,
  net worth 119, debt 151, financial assets 63. All plausible (high-income young households, legit
  extremes); removing/capping would bias. Flagged records exported to
  `outputs/outlier_flags/<dataset>_outliers.csv` for Lydia's review.

## Step 6 — cleaning summary
| Dataset | Raw n | After 18–24 filter | Dropped (no outcome) | Final n | % removed |
|---------|-------|--------------------|----------------------|---------|-----------|
| cfpb_nfwbs_2016 | 6,394 | 414 | 0 | **414** | 93.5% |
| scf_2022 | 22,975 | 555 | 0 | **555** | 97.6% (111 households ×5) |
| nfcs_2018 | 27,091 | 2,795 | 0 | **2,795** | 89.7% |
| nfcs_2021 | 27,118 | 3,009 | 0 | **3,009** | 88.9% |
| nlsy97_1997cohort | 8,984 | 8,984 (age-20 anchor) | 0 | **8,984** | 0% (savings outcome ~79%; no credit/knowledge/spending) |

**Significant missingness / handling (item 31):** NFCS Big-Five literacy items were 13–45% "missing"
in the raw audit, but that was code 98 "Don't know" → scored incorrect per B5, so the knowledge score
has 0% missing. CFPB `credit_behavior_index` (81%) and `underserved_200fpl` (4.8%) are HELD (not imputed).
All other key variables were <5% → median/mode imputed.

**Data-quality concerns for Lydia & Satvik (item 32):**
1. Sample is **18–24 young adults**, not 13–22 teens (bracket changed to fit the data). No dataset
   contains under-18s.
2. **CFPB n=414 and SCF n=111 households are small** — limited power for that pair.
3. **CFPB credit_behavior_index unusable** (81% missing) — exclude.
4. **NFCS/SCF spending index and SCF credit index are low-confidence** proxies (see `analysis_decisions.md`).
5. **NFCS underserved flag is coarse** (banded income) and uses *individual* income for respondents
   living in parents' homes (`lives_in_parents_home`).
6. **NFCS knowledge scores run lower** than CFPB/SCF (DK=incorrect) — standardize within-dataset before pooling.
7. **NLSY97 supplies only the SAVINGS outcome** (account ownership, ~79% coverage; savings 21.3% missing,
   held). **Credit, financial-literacy knowledge, and spending were not fielded at 1997–2006** → those
   composites are NaN for NLSY97. Its underserved flag is now clean (poverty ratio), but income/poverty is
   30.6% missing. NLSY97 data is early-2000s (cohort born 1980–84) — a data-currency point. ASVAB is a
   **numeracy** control, **not** financial literacy.

**Final sample sizes (item 33):** CFPB 414 · SCF 555 (111 households) · NFCS 2018 2,795 · NFCS 2021 3,009
· NLSY97 8,984 (savings outcome + controls). Total ≈ 15,757 records across 5 cleaned datasets. Outcome
coverage: knowledge = CFPB/SCF/NFCS; savings = all 5; credit & spending = CFPB/SCF/NFCS only.

---

## NLSY97 usage — RESOLVED (full extract received & cleaned 2026-07-23)
The re-pull (`nlsy97_20260723_full.*`) delivered the behavior/household items: **YAST savings-account
ownership** (→ `savings_behavior_index`), **`CV_HH_POV_RATIO`** (→ clean `underserved_200fpl`, no more
assumed household size), **`CV_HH_SIZE`**, **`CV_CENSUS_REGION`**, and **ASVAB** (numeracy control). A
custom sampling weight was also provided and merged. NLSY97 now works as the paper's main dataset for the
**savings** outcome across a 18–24 (age-20) cross-section of 8,984 respondents.

**Still not available in NLSY97 at 1997–2006 (research lead confirmed, left out):**
- **Credit behavior** and **financial-literacy knowledge** — not fielded in the target years → composites NaN.
- **Spending behavior** — not available → composite NaN.
- So for credit/spending/knowledge outcomes the analysis relies on CFPB, SCF, and NFCS.

**Remaining open item — the treatment variable:** NLSY97 doesn't cleanly flag "received financial-literacy
education." The paper's identification strategy (e.g., HS economics/personal-finance coursework, or a
state-of-residence × state financial-education-mandate merge) still needs to be decided with Lydia; note
state identifiers are in NLSY97's **restricted-access Geocode** file (separate application). `ap_econ_score`
is present but sparse (13 respondents) and is not a usable treatment on its own.

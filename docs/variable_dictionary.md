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

## Files NOT used, and why

| File | Why excluded |
|---|---|
| NFCS Investor Survey (`Inv`), all waves | Screened to investment-account holders; not representative of the target population. See `docs/analytical_decisions.md` §5. |
| CFPB National Financial Well-Being Survey PUF (2016) | No item equivalent to `M20` (financial-education exposure); cannot support the same predictor. See `docs/analytical_decisions.md` §6. |

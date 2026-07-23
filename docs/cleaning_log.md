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

### Open decisions — awaiting Lydia (nothing auto-resolved)
- B1: CFPB Youth Survey has no data file — drop / re-acquire / halt?
- B2: NLSY97 extract is demographics-only — drop / re-pull with intended variables?
- B3: 13–22 age filter unsupported by any dataset — how to interpret?
- B4: ≤200% FPL indicator must be constructed for SCF & NFCS — method?
- B5: NFCS literacy items + CFPB PCTLT200FPL missingness (esp. code 98 "don't know") — how to treat?

# Analysis Decisions

Document every analytical decision here.

## Format

- Date:
- Analysis Step:
- Decision:
- Reason:

---

## Step 4 — Composite variable construction (items 20–23)

All four composites are normalized to **0–100** (higher = stronger of that behavior/knowledge).
Each is the row-mean of its available components (each component rescaled to 0–1), so a dataset that
lacks a component still yields a comparable index. Built in `analysis/paper1_cleaning.py`.
Confidence = how well the dataset's items match the spec definition.

### Item 20 — financial_knowledge_score (objective, 0–100)
- Date: 2026-07-23
- Analysis Step: Step 4 — financial knowledge score
- Decision: CFPB = mean of 12 objective correct-answer flags (FK1–FK3 Big-Three + KH1–KH9
  Knoll-Houts) ×100. SCF = `FINLIT` (0–3 Big-Three correct) /3 ×100. NFCS = mean-correct over the
  Big-Five (M6–M10) ×100, with "Don't know" (98) and refused (99) scored as **incorrect** (per B5).
- Reason: All are objective knowledge items normalized to 0–100 as the spec requires. **Confidence: HIGH.**
  Cross-dataset caveat: CFPB/SCF use quiz batteries; NFCS uses the Big-Five with DK=incorrect, so NFCS
  scores run lower (mean ≈36–41 vs ≈63–65) — comparisons across datasets should be within-dataset standardized.

### Item 21 — savings_behavior_index (0–100)
- Date: 2026-07-23
- Analysis Step: Step 4 — savings behavior index
- Decision: CFPB = SAVEHABIT (saving habit) + SAVINGSRANGES (savings amount) + ABSORBSHOCK (emergency
  capacity). SCF = SAVED (saved last year) + HSAVING (has savings account) + EMERGSAV (emergency savings).
  NFCS = B2 (has savings account) + J5 (emergency/rainy-day fund).
- Reason: Maps to spec components (account ownership, regular saving, emergency fund). **Confidence:
  HIGH for SCF (all 3), MEDIUM for CFPB, MEDIUM for NFCS (2/3 — NFCS has no clean saving-frequency item).**

### Item 22 — credit_behavior_index (0–100)
- Date: 2026-07-23
- Analysis Step: Step 4 — credit behavior index
- Decision: NFCS = G1 (owns credit card) + F2_1 (pays in full; non-cardholders = 0) + G20 (credit-score
  awareness) — all 3 spec components. SCF = NOCCBAL (no revolving balance) + not-LATE + no-bankruptcy-5y
  (payment behavior only). CFPB = COLLECT/REJECTED (reverse-coded) only.
- Reason: **Confidence: HIGH for NFCS; LOW-MEDIUM for SCF** (no card-ownership/score-awareness items;
  `NOCCBAL`=1 also captures no-card young adults, inflating SCF credit ≈79); **UNUSABLE for CFPB**
  — 81% missing (COLLECT/REJECTED asked of a small subset). **Decision 2026-07-23: EXCLUDED for CFPB**
  — set to NaN for all 414 records (the 79 non-null values came from a biased subset); the column is
  kept all-NaN for cross-dataset schema consistency. Credit outcomes come from NFCS and SCF only.

### Item 23 — spending_behavior_index (0–100)
- Date: 2026-07-23
- Analysis Step: Step 4 — spending behavior index
- Decision: CFPB = PROPPLAN (planning) + MANAGE1 (money management/budget tracking) + SELFCONTROL
  (impulse). SCF = SPENDLESS + reverse-SPENDMOR (spending vs income) + BFINPLAN (financial plan).
  NFCS = J4 (ease covering bills) + J32 (spending vs income).
- Reason: **Confidence: HIGH for CFPB** (matches all 3 spec components: budget tracking, impulse,
  planning); **MEDIUM for SCF; LOW for NFCS** (no clean budget-tracking or impulse-purchase items —
  built from cash-flow proxies). NFCS and SCF spending indices flagged as approximate for Lydia.

### NLSY97 — composites (full extract 2026-07-23)
- Date: 2026-07-23
- Analysis Step: Step 4 — NLSY97 composites
- Decision: `savings_behavior_index` = checking/savings/money-market **account ownership** (YAST-4400:
  codes 1–4 = has account → 1, 0 = no → 0) ×100. `financial_knowledge_score`, `credit_behavior_index`,
  and `spending_behavior_index` are left **NaN**.
- Reason: Per the research lead, **credit behavior and financial-literacy knowledge were not fielded at the
  1997–2006 target years**, and spending behavior isn't available — so those three can't be built.
  Savings behavior IS available via YAST account ownership (**MEDIUM confidence — 1 of 3 spec components;
  NLSY97 lacks a saving-frequency and an emergency-fund item; ~21% held-missing** because the item's
  universe is "R is independent"). ASVAB math/verbal is kept as a **numeracy control**, not a
  financial-knowledge score (it is not a financial-literacy instrument). NLSY97 `underserved_200fpl` uses
  the clean `CV_HH_POV_RATIO` (≤200%). See `cleaning_log.md`.

### Underserved indicator (Step 1, item 7) — construction (option A)
- Date: 2026-07-23
- Analysis Step: Step 1 — ≤200% FPL flag
- Decision: CFPB = direct `PCTLT200FPL`. SCF = INCOME (2022 nominal) ≤ 200% FPL threshold for
  household size (1 + married + KIDS). NFCS = income-band midpoint ≤ 200% FPL threshold for household
  size (1 + partner[A7==2] + dependent children[A11]).
- Reason: Only CFPB ships a direct flag; SCF/NFCS constructed from income + household size vs HHS
  poverty guidelines (×2). **NFCS is coarse** (banded income via midpoints) and, for respondents living
  in their parents' home (`A7`==3, flagged `lives_in_parents_home`), NFCS `A8` is *individual* income —
  so the flag reflects the young adult's own resources, not the parental household. Flagged for Lydia.

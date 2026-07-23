# Paper 1 — Independent Validation Report (Rohan, Task 1)

**Validator:** Rohan (Data Analyst 2). **Method:** every check is re-derived directly from the **raw**
files (`analysis/independent_validation.py`), *not* by re-running Yousef's pipeline — so this is a genuine
independent reproduction, not a circular re-run. Random seed = 42 (reproducible). Compared against the
cleaned files and Yousef's `outputs/validation_summary.json`.

**Result: all checks PASS — 0 discrepancies. The cleaned data reproduces exactly from raw.**
(Per spec item 4, any discrepancy would be reported here and raised with Yousef, not fixed unilaterally.)

---

## Check 1 — Null counts (item 1): independent recount vs Yousef's output
Recounted nulls in the four primary outcome variables for each dataset and compared to Yousef's recorded
`nulls_in_primary`. **Every dataset matches exactly.**

| Dataset | Independent null counts (knowledge / savings / credit / spending) | Matches Yousef? |
|---|---|---|
| cfpb_nfwbs_2016 | 0 / 0 / **414** / 0 | ✅ |
| scf_2022 | 0 / 0 / 0 / 0 | ✅ |
| nfcs_2018 | 0 / 0 / 0 / 0 | ✅ |
| nfcs_2021 | 0 / 0 / 0 / 0 | ✅ |
| nlsy97_1997cohort | **8984** / **1911** / **8984** / **8984** | ✅ |

The intentional nulls are confirmed as designed: CFPB credit excluded (414); NLSY97 knowledge/credit/spending
not fielded (8984 each) and savings held-missing where the account question wasn't asked (1911 = 21.3%).

## Check 2 — Filtering logic (item 2): 50 random records + exact ID set-equality
For each dataset I independently recomputed the 18–24 filter from the raw age variable (CFPB `agecat==1`;
SCF `AGE∈[18,24]`; NFCS `A3Ar_w==1`; NLSY97 age-20 anchor = whole cohort) and confirmed the set of raw IDs
that *should* pass **equals** the set of cleaned IDs — a stronger check than 50 records (it covers all of
them). The 50-record spot check is a subset of this.

| Dataset | Cleaned n | Raw passing filter | Extra (shouldn't be in) | Missing (should be in) | 50-record sample bad | Result |
|---|---|---|---|---|---|---|
| cfpb_nfwbs_2016 | 414 | 414 | 0 | 0 | 0 | ✅ |
| scf_2022 | 555 | 555 | 0 | 0 | 0 | ✅ |
| nfcs_2018 | 2,795 | 2,795 | 0 | 0 | 0 | ✅ |
| nfcs_2021 | 3,009 | 3,009 | 0 | 0 | 0 | ✅ |
| nlsy97_1997cohort | 8,984 | 8,984 | 0 | 0 | 0 | ✅ |

## Check 3 — Composite arithmetic (item 3): recompute 10 records from raw
Recomputed composites by hand from the raw component items on 10 random records each and compared to the
cleaned value (tolerance 0.05). **All matched.**

| Dataset | Composite recomputed | Records | Mismatches |
|---|---|---|---|
| cfpb | financial_knowledge_score (mean of 12 correct flags ×100) | 10 | 0 |
| scf | financial_knowledge_score (FINLIT/3 ×100) | 10 | 0 |
| nfcs_2018 | financial_knowledge_score (Big-Five, DK=wrong ×20) | 10 | 0 |
| nfcs_2018 | savings_behavior_index (B2 + J5) | 10 | 0 |
| nfcs_2021 | financial_knowledge_score | 10 | 0 |
| nfcs_2021 | savings_behavior_index | 10 | 0 |
| nlsy97 | savings_behavior_index (YAST-4400 ownership) | 10 | 0 |

## Additional confirmations (for "ready for analysis" sign-off)
Independently confirmed on all 5 cleaned datasets: **0 duplicate `respondent_id`**, **0 index values
outside [0,100]**, **all `age` within 18–24**, **all income ≥ 0**.
- Note (not a discrepancy): SCF `respondent_id` (Y1) is unique, but `household_id` (YY1) repeats 5× by
  design (multiple-imputation implicates). Confirmed this is expected, per Yousef's log.

---

## Sign-off
From a **data-integrity standpoint the cleaning is faithfully executed and fully reproducible** — filtering,
null handling, and composite arithmetic all independently check out. Cleared to proceed **on execution grounds**.

Scope note: Task 1 validates that the cleaning does what it claims (execution correctness). It does **not**
assess whether the datasets can support the paper's research question (research validity) — that is a
separate discussion already raised with the team and left open pending the reframing decision.

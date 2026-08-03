# Analytical Decisions — Paper 1

This document records the substantive analytical decisions behind the
pipeline in `analysis/`, and why each was made. It's meant to answer the
question "why did you do it this way?" without having to reconstruct the
reasoning from code or Slack history.

## 1. Predictor variable: `M20` as financial-education exposure

NFCS item `M20` asks whether financial education was offered by a school,
college, or employer, and whether the respondent participated. We recode
this as a binary:

- `1` (exposed) — offered AND participated
- `0` (not exposed) — not offered, OR offered but did not participate

We collapse "not offered" and "offered but didn't participate" into one
category because the paper's research question is about the effect of
*receiving* financial education, not about access/offer rates specifically.
If access itself becomes a research question later, these two groups should
be split back out (`M20 == 1` vs `M20 == 3`).

## 2. Age proxy: 18–24 stands in for 18–22

The paper's research question targets ages 13–22. NFCS's youngest age
bucket (`A3Ar_w == 1`) is 18–24, and NFCS does not sample anyone under 18.
Two consequences:

- The 13–17 slice of the research question is **not covered** by NFCS at
  all. It would need a separate instrument (e.g. a school-based youth
  survey) with compatible variables — see `docs/cleaning_log.md` notes for
  what was investigated and ruled out.
- The 18–24 bucket is used as a **disclosed proxy** for "young adult" in
  every subgroup model. This is a real limitation, not a rounding error:
  it includes 23–24 year olds who are outside the paper's stated range.
  Every subgroup table in the final report explicitly labels this as
  "18-24," not "18-22," to keep the approximation visible rather than
  quietly assumed away.

## 3. Why pool three survey waves instead of using 2024 alone

The single-wave 2024 model has real statistical power for the full sample
(N=25,539) but is underpowered in the 18-24 subgroup (N=2,468) once
Bonferroni correction is applied for five outcome tests (alpha=.002). One
finding ("has emergency fund") is significant at the uncorrected p<.05
threshold but does not survive correction in the 2024-only subgroup.

Pooling 2018+2021+2024 (N=79,748 total, N=8,272 in the 18-24 subgroup)
recovers enough power that this same finding **does** survive Bonferroni
correction. Pooling is not just "more data is better" — it's specifically
what lets us distinguish "no effect" from "effect too small to detect at
this sample size" for the subgroup that matters most to the paper.

## 4. Why gender is excluded from all pooled and by-wave models

The 2018 NFCS questionnaire did not include a gender item (`A50A` was added
starting 2021, after NFCS began including a nonbinary response option).
Two options were considered:

- **Include gender only where available**, treating it as missing for all
  2018 respondents. Rejected: this would silently drop the entire 2018
  wave from any model formula that includes `female`, since `statsmodels`
  listwise-deletes rows with missing predictor values. That would look
  like pooling while actually running the 2021+2024 sample only.
- **Exclude gender from all pooled models** (what we did). This keeps the
  2018 wave in every pooled analysis, at the cost of not controlling for
  gender in the pooled/by-wave results. The single-wave 2024 model still
  includes gender, since it's fully available there — so the 2024-only
  numbers and the pooled numbers are not directly comparable to each
  other, and the report says so explicitly (Methodology sheet).

## 5. Why the Investor Survey (NFCS "Inv") is excluded entirely

The Investor Survey samples people who already hold investment accounts.
Two problems for this paper specifically:

- **Population mismatch.** The research question is about underserved
  young people who *lack* access to financial education. A sample
  restricted to people who already have investment accounts is closer to
  the opposite population.
- **Coarser age resolution.** The Investor Survey's age variable only
  distinguishes 18–34 / 35–54 / 55+ — even less precise than the State-by-
  State survey's 18-24 bucket, and the youngest bracket is thin (n≈213 in
  the 2024 file) and likely skews toward the upper end of that range since
  respondents needed an investment account to qualify.

Both files are present in `data/raw/` (if downloaded) for reference, but
no script in `analysis/` reads them.

## 6. Why the CFPB Financial Well-Being Survey PUF is not pooled

The CFPB National Financial Well-Being Survey (2016 PUF) has no item
equivalent to NFCS's `M20` — there's no "was financial education offered,
did you participate" question. Its strength is a validated financial
well-being *scale* (a standardized dependent variable), not an education-
exposure predictor. It could support a separate model using a different
predictor (e.g. `FINSOC2`, parental financial socialization, as a proxy for
informal rather than formal financial education), but that is a different
research design and is out of scope for this pipeline. Flagging here so
it isn't silently dropped from the project plan.

## 7. Effect-size reporting: odds ratios, approximate Cohen's d, Cramer's V

- **Odds ratios with 95% CI** are the primary effect-size metric, since all
  outcomes are binary and all models are logistic regression.
- **Approximate Cohen's d** is also reported via the standard logit-to-d
  transform (`d = coefficient × √3 / π`), which treats the outcome as
  generated by an underlying continuous logistic latent variable. This is
  a standard approximation, not an exact value, and is labeled as such
  everywhere it appears.
- **Cramer's V** (via `pingouin.chi2_independence`) is reported only in the
  chi-square cross-validation table, for the unadjusted bivariate
  association — an independent, model-free effect-size check against the
  regression-based OR/d estimates.

## 8. Why every 2024 regression result is cross-checked with a chi-square test

Logistic regression and chi-square testing answer related but distinct
questions: the regression estimates an *adjusted* association (controlling
for demographics), while the chi-square test checks the *raw, unadjusted*
association. Running both and comparing catches cases where a raw
association is entirely explained by demographic composition rather than
reflecting anything about financial-education exposure itself.

This is exactly what happened for two outcomes: "spends more than income"
and "carries an interest-bearing CC balance" are both significant in the
unadjusted chi-square test but not significant in the adjusted logistic
regression. That's not a contradiction or an error — it's the controls
doing their job, and it's an important nuance for how the paper frames
these two null results (they aren't simply "no relationship"; they're "no
relationship once you account for who tends to get financial education").

## 9. Predictive validation (scikit-learn / scipy) — a second, independent check

`analysis/06_predictive_validation.py` runs two more cross-checks that use
neither `statsmodels` nor `pingouin`, so the headline finding doesn't rest
on one library's implementation:

- **5-fold cross-validated logistic regression (scikit-learn).** Out-of-
  sample ROC-AUC for "has emergency fund" is ~0.74 — noticeably higher than
  the other four outcomes (~0.61–0.67). That's a useful sanity signal: this
  model's predictors (income, education, age, and financial-ed exposure
  together) carry real out-of-sample discriminative power for this outcome
  specifically, not just an in-sample p-value.
- **Non-parametric bootstrap CI (scipy/numpy, 5,000 resamples)** on the raw
  rate difference between exposed and unexposed groups. All five outcomes'
  95% CIs exclude zero — consistent with the chi-square cross-check in
  script 03, i.e. every RAW bivariate difference is "significant" before
  controls are added. This is expected and is exactly why the adjusted
  regression (which does add controls) is the number that should be cited
  in the paper, not the raw bootstrap difference.

One honest discrepancy worth noting: the standardized scikit-learn
coefficient sign for `revolves_cc_balance` is negative, while the pooled
statsmodels odds ratio is very slightly above 1 (1.014, p=.52 — i.e.
essentially null). This isn't a contradiction; it's what you'd expect when
an effect is genuinely close to zero — trivial implementation differences
between two logistic-regression fits (regularization, standardization,
optimizer) can flip the sign of a near-zero coefficient without changing
the substantive conclusion, which is "no detectable effect on this outcome
either way."

## 10. The central causal-inference caveat

**Every model in this pipeline is correlational, not causal**, for two
compounding reasons:

- **Cross-sectional measurement.** Financial-education exposure and current
  financial behavior are measured in the same interview. There is no
  temporal ordering — we cannot tell whether education preceded the
  behavior, and there's no pre-treatment baseline.
- **No random assignment.** Respondents were not randomly assigned to
  receive financial education. Selection into education (or into schools/
  employers that offer it) is itself correlated with unobserved factors —
  family financial socialization, personality traits, or, per the reverse-
  causality finding below, existing financial difficulty.

The multi-wave replication of the overspending/overdraft finding (see
below) is a good illustration of why this caveat isn't just boilerplate.

## 11. The overspending/overdraft finding, and why it isn't buried

Financial-education exposure is associated with **higher**, not lower, odds
of overspending and overdrafting in the pooled model (both p<.001), and
this replicates independently in the 2018 and 2021 by-wave models (2024
alone is null on both). This is the opposite direction from the paper's
hypothesis.

The most plausible explanation is reverse causality: people already
experiencing financial difficulty may be more likely to seek out, or be
directed toward, financial education — not that education is causing worse
behavior. Whatever the explanation, replicating in two independent survey
waves means this is very unlikely to be sampling noise, and it is reported
explicitly (both in the `ByWave_Robustness` sheet, flagged in red, and in
the Methodology sheet) rather than omitted or averaged away in the pooled
headline number.
## 12. SCF: benchmarking role, and why it can't be pooled

The Survey of Consumer Finances publishes only aggregate summary
statistics (medians, means, percentages by characteristic group) in its
public bulletin — not respondent-level microdata. `analysis/07_scf_extraction.py`
extracts three of these summary tables programmatically from the bulletin
PDF (via `pdfplumber` + regex parsing of the bulletin's text-based tables,
not hand-typed values — see `docs/cleaning_log.md` for the extraction
audit trail). `analysis/08_scf_benchmarking.py` then uses those tables
purely as **national context**: how does the NFCS young-adult sample
compare to SCF's national income, net worth, and credit-behavior figures.

This is exactly the role the original dataset catalog assigned to SCF
("used primarily for benchmarking in results section"). It cannot enter
any regression model, and the `SCF_vs_NFCS_Comparison` table is explicitly
labeled as a descriptive juxtaposition, not a statistical comparison —
SCF and NFCS differ in population, survey year, and question wording, so
no significance test is implied or appropriate.

## 13. NFWBS: why it models a different construct, not formal education

The CFPB National Financial Well-Being Survey (2016 PUF, N=6,394) is real
respondent-level microdata, but — as flagged when this dataset was first
evaluated for the project — it has **no item equivalent to NFCS's `M20`**
(formal financial-education exposure). It cannot support the same
predictor and is never pooled with the NFCS models under any
circumstance.

What it does have is `FINSOC2_1` through `FINSOC2_7`: seven items on
whether a parent engaged in specific financial-socialization behaviors
(discussed money, taught budgeting, gave an allowance, provided a savings
account) while the respondent was growing up. `analysis/09_nfwbs_model.py`
sums these into a 0-7 "financial socialization score" and uses it as a
predictor of a related but **conceptually distinct** construct: informal
parental financial socialization, not formal school/employer-based
financial education. Every table and figure this script produces labels
it as such.

The result is a clean, consistent finding — socialization score predicts
all four outcomes modeled (financial well-being, savings habit, paying
credit cards in full, and difficulty making ends meet) in the expected
direction, all p<.0001 — but it should be read as suggestive triangulation
around a related idea, not as replication of the NFCS financial-education
finding. The two datasets are testing adjacent but different hypotheses.

The same age-proxy caveat that applies to NFCS's 18-24 bucket applies here
too: NFWBS's `agecat==1` (youngest bracket, n=414) is used as a disclosed,
imperfectly-bounded proxy for "youngest adults in the sample." The
codebook confirms `agecat` categories 6-8 correspond to the survey's
age-62+ oversample, which anchors the top of the scale, but the exact
upper bound of category 1 was not independently confirmed from the
codebook text available when this pipeline was built — flagged rather
than assumed.


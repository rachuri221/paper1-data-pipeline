"""
Paper 1 — data cleaning pipeline (Yousef, Assignment 2).

Implements the 6-step spec for the usable datasets:
  CFPB National Financial Well-Being Survey 2016, Federal Reserve SCF 2022,
  FINRA NFCS 2018, FINRA NFCS 2021.
(CFPB Youth Survey dropped — not public; NLSY97 pending re-pull — see cleaning_log.md.)

Decisions locked with the research lead / Lydia:
  B3  age filter = 18-24 (research lead changed target bracket from 13-22 to fit the data)
  B4  <=200% FPL indicator constructed from income + household size (option A)
  B5  NFCS literacy "Don't know" (98) scored as INCORRECT, not missing; anything still
      >=5% missing after that is HELD (not imputed) and surfaced for confirmation.

Nothing >20% missing is imputed; >3SD outliers are FLAGGED, never removed (spec items 13/26).
Raw files are never modified; all outputs go to data/cleaned/ and outputs/.
"""
from __future__ import annotations
import pandas as pd
import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
RAW = ROOT / "data" / "raw"
CLEAN = ROOT / "data" / "cleaned"
OUT = ROOT / "outputs"

# ---------------------------------------------------------------------------
# Reference constants
# ---------------------------------------------------------------------------
# CPI-U, annual average, 1982-84=100 (BLS). Used to deflate to 2020 dollars.
CPI = {1999: 166.6, 2000: 172.2, 2001: 177.1, 2002: 179.9, 2003: 184.0, 2004: 188.9,
       2016: 240.007, 2018: 251.107, 2020: 258.811, 2021: 270.970, 2022: 292.655}
CPI_BASE = CPI[2020]

# 200% of the federal poverty line by household size and year (HHS poverty
# guidelines x2, 48 contiguous states). size -> threshold.
FPL200 = {
    2016: {1: 23760, 2: 32040, 3: 40320, 4: 48600, 5: 56880, 6: 65160, 7: 73440, 8: 81720},
    2018: {1: 24280, 2: 32920, 3: 41560, 4: 50200, 5: 58840, 6: 67480, 7: 76120, 8: 84760},
    2021: {1: 25760, 2: 34840, 3: 43920, 4: 53000, 5: 62080, 6: 71160, 7: 80240, 8: 89320},
    2022: {1: 27180, 2: 36620, 3: 46060, 4: 55500, 5: 64940, 6: 74380, 7: 83820, 8: 93260},
}

def fpl200(year: int, size: float) -> float:
    tbl = FPL200[year]
    size = int(np.clip(np.nan_to_num(size, nan=1), 1, 8))
    return tbl[size]

# Income-band midpoints (nominal $ of survey year).
CFPB_PPINCIMP_MID = {1: 15000, 2: 25000, 3: 35000, 4: 45000, 5: 55000,
                     6: 67500, 7: 87500, 8: 125000, 9: 175000}  # 9=$150k+
NFCS_A8_MID = {1: 7500, 2: 20000, 3: 30000, 4: 42500, 5: 62500, 6: 87500,
               7: 125000, 8: 175000, 9: 250000, 10: 350000}  # 2018 tops at 8=$150k+

# NFCS Big-Five financial-literacy correct answers.
NFCS_CORRECT = {"M6": 1, "M7": 3, "M8": 2, "M9": 1, "M10": 2}

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------
def deflate(amount, year):
    return amount * (CPI_BASE / CPI[year])

def to01(s, yes=1, no=2, missing=(98, 99)):
    """Recode a yes/no survey item to 1/0; listed codes -> NaN."""
    s = pd.to_numeric(s, errors="coerce")
    out = pd.Series(np.nan, index=s.index, dtype="float")
    out[s == yes] = 1.0
    out[s == no] = 0.0
    return out

def minmax01(s, lo, hi):
    s = pd.to_numeric(s, errors="coerce")
    return (s.clip(lo, hi) - lo) / (hi - lo)

def index_0_100(components: dict[str, pd.Series]) -> pd.Series:
    """Row-mean over available 0-1 components, scaled to 0-100."""
    df = pd.DataFrame(components)
    return (df.mean(axis=1, skipna=True) * 100).round(2)

def impute_lt5(df, cols, kind):
    """Item 11: median (continuous) / mode (categorical) imputation for <5% missing."""
    log = []
    for c in cols:
        if c not in df: continue
        miss = df[c].isna().mean()
        if 0 < miss < 0.05:
            fill = df[c].median() if kind == "continuous" else df[c].mode(dropna=True).iloc[0]
            df[c] = df[c].fillna(fill)
            log.append(f"{c}: {miss*100:.2f}% -> {kind[:3]}-imputed ({fill:g})")
    return log

def validate(df, name, id_col, continuous, ranges):
    """Step 5: null / range / duplicate / outlier(>3SD, flag only) checks + histograms."""
    r = {"dataset": name, "n": len(df)}
    prim = ["financial_knowledge_score", "savings_behavior_index",
            "credit_behavior_index", "spending_behavior_index"]
    r["nulls_in_primary"] = {c: int(df[c].isna().sum()) for c in prim if c in df}
    r["dup_ids"] = int(df[id_col].duplicated().sum())
    r["range_violations"] = {}
    for c, (lo, hi) in ranges.items():
        if c in df:
            bad = int(((df[c] < lo) | (df[c] > hi)).sum())
            if bad: r["range_violations"][c] = bad
    # Outliers >3SD: FLAGGED and EXPORTED for review, never removed (spec item 26).
    r["outliers_gt3sd"] = {}
    flagged = pd.Series(False, index=df.index)
    for c in continuous:
        if c in df and df[c].notna().sum() > 2:
            z = (df[c] - df[c].mean()) / df[c].std(ddof=0)
            mask = z.abs() > 3
            n = int(mask.sum())
            if n:
                r["outliers_gt3sd"][c] = n
                flagged = flagged | mask.fillna(False)
    if flagged.any():
        od = OUT / "outlier_flags"; od.mkdir(parents=True, exist_ok=True)
        df.loc[flagged].to_csv(od / f"{name}_outliers.csv", index=False)
    # histograms (item 25)
    d = OUT / "histograms" / name
    d.mkdir(parents=True, exist_ok=True)
    for c in continuous:
        if c in df and df[c].notna().sum() > 0:
            plt.figure(figsize=(5, 3))
            df[c].dropna().hist(bins=30)
            plt.title(f"{name}: {c}"); plt.tight_layout()
            plt.savefig(d / f"{c}.png", dpi=80); plt.close()
    return r

def finish(df, name):
    outdir = CLEAN / name
    outdir.mkdir(parents=True, exist_ok=True)
    path = outdir / f"{name}_clean.csv"
    df.to_csv(path, index=False)
    return path

# ---------------------------------------------------------------------------
# CFPB National Financial Well-Being Survey 2016  (person, 18+)
# ---------------------------------------------------------------------------
def clean_cfpb():
    raw = pd.read_csv(RAW / "cfpb_financial_wellbeing" / "NFWBS_PUF_2016_data.csv", low_memory=False)
    steps = {"raw": len(raw)}
    df = raw.copy()

    # Step 1 — age filter 18-24 (agecat band 1). Banded age == exactly 18-24.
    df = df[df["agecat"] == 1].copy()
    steps["age_18_24"] = len(df)

    out = pd.DataFrame(index=df.index)
    out["source_dataset"] = "cfpb_nfwbs_2016"
    out["survey_year"] = 2016
    out["respondent_id"] = df["PUF_ID"]
    out["age"] = np.nan                       # only banded age available
    out["age_band"] = "18-24"
    out["female"] = to01(df["PPGENDER"], yes=2, no=1)   # 1=male,2=female
    out["education_level"] = df["PPEDUC"].clip(1, 5)     # 1<HS..5 grad
    out["census_region"] = df["PPREG4"]
    out["household_size"] = pd.to_numeric(df["PPHHSIZE"], errors="coerce")

    # Step 1 item 7 — underserved: direct CFPB flag (-5 refused -> held missing)
    fpl = pd.to_numeric(df["PCTLT200FPL"], errors="coerce")
    out["underserved_200fpl"] = fpl.where(fpl >= 0)
    out["underserved_method"] = "direct_PCTLT200FPL"

    # Step 3 item 17 — income to 2020 USD (band midpoint -> deflate)
    inc = pd.to_numeric(df["PPINCIMP"], errors="coerce").map(CFPB_PPINCIMP_MID)
    out["household_income_2020_usd"] = deflate(inc, 2016).round(0)
    out["income_is_banded"] = True

    # Step 4 — composites (0-100)
    kn = [c for c in ["FK1correct","FK2correct","FK3correct",
                      "KH1correct","KH2correct","KH3correct","KH4correct","KH5correct",
                      "KH6correct","KH7correct","KH8correct","KH9correct"] if c in df]
    knacc = df[kn].apply(pd.to_numeric, errors="coerce").where(lambda x: x >= 0)
    out["financial_knowledge_score"] = (knacc.mean(axis=1, skipna=True) * 100).round(2)

    out["savings_behavior_index"] = index_0_100({
        "save_habit": minmax01(df["SAVEHABIT"].where(df["SAVEHABIT"] > 0), 1, 6),     # regular saving
        "savings_amount": minmax01(df["SAVINGSRANGES"].where(df["SAVINGSRANGES"] > 0), 1, 8),  # ~account/balance
        "absorb_shock": minmax01(df["ABSORBSHOCK"].where(df["ABSORBSHOCK"] > 0), 1, 4),  # emergency fund capacity
    })
    # credit — EXCLUDED for CFPB (decision 2026-07-23): the only credit-adjacent items
    # (COLLECT/REJECTED) are asked of a small, non-random subset -> composite was 81% missing
    # and biased. Column kept (all NaN) for schema consistency; credit outcomes come from NFCS/SCF.
    out["credit_behavior_index"] = np.nan
    out["spending_behavior_index"] = index_0_100({
        "plan_ahead": minmax01(df[["PROPPLAN_1","PROPPLAN_2","PROPPLAN_3","PROPPLAN_4"]]
                               .apply(pd.to_numeric, errors="coerce").where(lambda x: x > 0).mean(axis=1), 1, 5),
        "money_management": minmax01(df[["MANAGE1_1","MANAGE1_2","MANAGE1_3","MANAGE1_4"]]
                               .apply(pd.to_numeric, errors="coerce").where(lambda x: x > 0).mean(axis=1), 1, 5),
        "self_control": minmax01(df[["SELFCONTROL_1","SELFCONTROL_2","SELFCONTROL_3"]]
                               .apply(pd.to_numeric, errors="coerce").where(lambda x: x > 0).mean(axis=1), 1, 5),
    })
    out["weight"] = df.get("finalwt")

    # Step 2 — <5% median/mode imputation on inputs already folded into composites/demographics
    imp = impute_lt5(out, ["household_size", "education_level", "census_region"], "categorical")
    imp += impute_lt5(out, ["household_income_2020_usd", "financial_knowledge_score",
                            "savings_behavior_index", "credit_behavior_index",
                            "spending_behavior_index"], "continuous")

    # Step 2 item 14 — drop only if ALL primary outcomes are missing
    prim = ["savings_behavior_index","credit_behavior_index","spending_behavior_index","financial_knowledge_score"]
    before = len(out); out = out[out[prim].notna().any(axis=1)]
    steps["outcome_present"] = len(out)
    steps["dropped_no_outcome"] = before - len(out)
    return out, steps, imp

# ---------------------------------------------------------------------------
# Federal Reserve SCF 2022  (household head; 5 imputation implicates)
# ---------------------------------------------------------------------------
def clean_scf():
    raw = pd.read_csv(RAW / "federal_reserve_scf" / "SCFP2022.csv", low_memory=False)
    steps = {"raw": len(raw)}
    df = raw[(raw["AGE"] >= 18) & (raw["AGE"] <= 24)].copy()   # continuous age -> exact 18-24
    steps["age_18_24"] = len(df)

    out = pd.DataFrame(index=df.index)
    out["source_dataset"] = "scf_2022"
    out["survey_year"] = 2022
    out["respondent_id"] = df["Y1"]
    out["household_id"] = df["YY1"]           # 5 implicates share YY1 (documented)
    out["age"] = df["AGE"].round().astype(int)
    out["age_band"] = "18-24"
    out["female"] = to01(df["HHSEX"], yes=2, no=1)
    edcl = df["EDCL"] if "EDCL" in df else df["EDUC"]
    out["education_level"] = pd.to_numeric(edcl, errors="coerce").clip(1, 5)
    out["census_region"] = np.nan             # not in summary extract
    out["household_size"] = 1 + (df["MARRIED"] == 1).astype(int) + pd.to_numeric(df["KIDS"], errors="coerce").fillna(0)

    # underserved — INCOME (2022 nominal) vs 200% FPL by household size
    thr = out["household_size"].map(lambda s: fpl200(2022, s))
    out["underserved_200fpl"] = (pd.to_numeric(df["INCOME"], errors="coerce") <= thr).astype(float)
    out["underserved_method"] = "income_vs_200fpl_by_hhsize"

    out["household_income_2020_usd"] = deflate(pd.to_numeric(df["INCOME"], errors="coerce"), 2022).round(0)
    out["income_is_banded"] = False

    # composites
    out["financial_knowledge_score"] = (pd.to_numeric(df["FINLIT"], errors="coerce") / 3 * 100).round(2)  # objective Big-3
    out["savings_behavior_index"] = index_0_100({
        "saved_last_year": pd.to_numeric(df["SAVED"], errors="coerce"),      # regular saving
        "has_savings_account": pd.to_numeric(df["HSAVING"], errors="coerce"),
        "emergency_savings": pd.to_numeric(df["EMERGSAV"], errors="coerce"),
    })
    out["credit_behavior_index"] = index_0_100({   # payment behaviour (card ownership/score awareness n/a in SCF)
        "no_revolving_balance": pd.to_numeric(df["NOCCBAL"], errors="coerce"),
        "not_late": 1 - pd.to_numeric(df["LATE"], errors="coerce"),
        "no_bankruptcy_5y": 1 - pd.to_numeric(df["BNKRUPLAST5"], errors="coerce"),
    })
    out["spending_behavior_index"] = index_0_100({
        "spent_less_than_income": minmax01(df["SPENDLESS"], 1, 5),
        "not_spent_more": 1 - minmax01(df["SPENDMOR"], 1, 5),
        "has_financial_plan": pd.to_numeric(df["BFINPLAN"], errors="coerce"),
    })
    out["weight"] = df.get("WGT")

    imp = impute_lt5(out, ["education_level"], "categorical")
    imp += impute_lt5(out, ["household_income_2020_usd","financial_knowledge_score",
                            "savings_behavior_index","credit_behavior_index","spending_behavior_index"], "continuous")
    prim = ["savings_behavior_index","credit_behavior_index","spending_behavior_index","financial_knowledge_score"]
    before = len(out); out = out[out[prim].notna().any(axis=1)]
    steps["outcome_present"] = len(out); steps["dropped_no_outcome"] = before - len(out)
    return out, steps, imp

# ---------------------------------------------------------------------------
# FINRA NFCS 2018 / 2021  (person, 18+)
# ---------------------------------------------------------------------------
def clean_nfcs(year):
    if year == 2018:
        raw = pd.read_csv(RAW / "finra_nfcs" / "NFCS 2018 State Data 190603.csv", low_memory=False)
        inc_col = "A8"
    else:
        raw = pd.read_csv(RAW / "finra_nfcs" / "NFCS 2021 State Data 220627.csv", low_memory=False)
        inc_col = "A8_2021"
    steps = {"raw": len(raw)}
    df = raw[raw["A3Ar_w"] == 1].copy()      # band 1 == 18-24 exactly
    steps["age_18_24"] = len(df)

    out = pd.DataFrame(index=df.index)
    out["source_dataset"] = f"nfcs_{year}"
    out["survey_year"] = year
    out["respondent_id"] = df["NFCSID"]
    out["age"] = np.nan
    out["age_band"] = "18-24"
    gender_col = "A50A" if "A50A" in df else ("A3" if "A3" in df else None)  # 2021 uses A50A, 2018 uses A3
    out["female"] = to01(df[gender_col], yes=2, no=1) if gender_col else np.nan
    out["education_level"] = pd.to_numeric(df["A5_2015"], errors="coerce").map(
        {1:1, 2:2, 3:2, 4:3, 5:3, 6:4, 7:5}).clip(1, 5)
    out["census_region"] = df["CENSUSREG"]

    # household size = 1 + partner(A7==2) + dependent children(A11: 1-4=count, 5/6=0)
    children = pd.to_numeric(df["A11"], errors="coerce").map({1:1, 2:2, 3:3, 4:4, 5:0, 6:0}).fillna(0)
    partner = (pd.to_numeric(df["A7"], errors="coerce") == 2).astype(int)
    out["household_size"] = 1 + partner + children

    # underserved — income band midpoint vs 200% FPL by hh size (coarse; caveat A7==3 = individual income)
    mid = pd.to_numeric(df[inc_col], errors="coerce").map(NFCS_A8_MID)
    thr = out["household_size"].map(lambda s: fpl200(year, s))
    out["underserved_200fpl"] = (mid <= thr).astype(float).where(mid.notna())
    out["underserved_method"] = "income_band_midpoint_vs_200fpl_by_hhsize(coarse)"
    out["lives_in_parents_home"] = (pd.to_numeric(df["A7"], errors="coerce") == 3).astype(int)

    out["household_income_2020_usd"] = deflate(mid, year).round(0)
    out["income_is_banded"] = True

    # knowledge — Big-Five, "Don't know"(98)/refused(99) scored INCORRECT (B5)
    correct = pd.DataFrame({q: (pd.to_numeric(df[q], errors="coerce") == a).astype(float)
                            for q, a in NFCS_CORRECT.items()})
    out["financial_knowledge_score"] = (correct.mean(axis=1) * 100).round(2)

    out["savings_behavior_index"] = index_0_100({   # 2/3 components (no clean saving-frequency item)
        "has_savings_account": to01(df["B2"]),
        "emergency_fund": to01(df["J5"]),
    })
    payment = to01(df["F2_1"].replace(r"^\s*$", np.nan, regex=True))  # blank = no card
    payment = payment.fillna(0)                                        # non-cardholder -> 0
    out["credit_behavior_index"] = index_0_100({
        "owns_credit_card": to01(df["G1"]),
        "pays_in_full": payment,
        "credit_score_aware": to01(df["G20"]),
    })
    out["spending_behavior_index"] = index_0_100({   # LOW confidence (no clean budget/impulse items)
        "covers_expenses_easily": minmax01(pd.to_numeric(df["J4"], errors="coerce").where(lambda x: x.isin([1,2,3])), 1, 3),
        "spending_le_income": minmax01(pd.to_numeric(df["J32"], errors="coerce").where(lambda x: x.between(1,5)), 1, 5),
    })
    out["weight"] = df.get("wgt_n2", df.get("weight"))

    imp = impute_lt5(out, ["female","education_level","census_region"], "categorical")
    imp += impute_lt5(out, ["household_income_2020_usd","savings_behavior_index",
                            "credit_behavior_index","spending_behavior_index"], "continuous")
    prim = ["savings_behavior_index","credit_behavior_index","spending_behavior_index","financial_knowledge_score"]
    before = len(out); out = out[out[prim].notna().any(axis=1)]
    steps["outcome_present"] = len(out); steps["dropped_no_outcome"] = before - len(out)
    return out, steps, imp

# ---------------------------------------------------------------------------
# NLSY97 (1997 cohort, born 1980-84) — age-20 cross-section  [full extract 2026-07-23]
# ---------------------------------------------------------------------------
# This extract adds the poverty ratio, household size, census region, YAST
# savings-account items, and ASVAB scores. Per the research lead: credit behavior
# and financial-literacy knowledge were NOT fielded at the 1997-2006 target years,
# so those composites stay NaN; spending behavior is also unavailable. NLSY97's
# real Paper-1 outcome here is SAVINGS behavior (checking/savings/money-market
# account ownership, YAST-4400). Per-survey-year reference numbers from NLSY97.cdb.
NLSY_POV   = {1997:"R1204900",1998:"R2563500",1999:"R3885100",2000:"R5464300",2001:"R7228000",2002:"S1541900",2003:"S2011700",2004:"S3812500",2005:"S5412900",2006:"S7513800"}
NLSY_SIZE  = {1997:"R1205400",1998:"R2563700",1999:"R3885300",2000:"R5464500",2001:"R7228200",2002:"S1542100",2003:"S2011900",2004:"S3813400",2005:"S5413000",2006:"S7513900"}
NLSY_REGION= {1997:"R1200300",1998:"R2558800",1999:"R3880300",2000:"R5459400",2001:"R7222400",2002:"S1535500",2003:"S2005400",2004:"S3805700",2005:"S5405600",2006:"S7506100"}
NLSY_SAVOWN= {1998:"R2370600",1999:"R3678300",2000:"R5128600",2001:"R6858400",2002:"S1092600",2003:"S3165000",2004:"S4822600",2005:"S6518400",2006:"S8516500"}  # YAST-4400
NLSY_INCOME= {1997:"R1204500",1998:"R2563300",1999:"R3884900",2000:"R5464100",2001:"R7227800",2002:"S1541700",2003:"S2011500",2004:"S3812400",2005:"S5412800",2006:"S7513700"}
NLSY_HGC   = {1998:"R2563201",1999:"R3884801",2000:"R5464001",2001:"R7227701",2002:"S1541601",2003:"S2011401",2004:"S3812301"}
NLSY_NW    = {2000:"R5464200",2001:"R7227900",2002:"S1541800",2003:"S2011600"}
NLSY_ASVAB_MVPCT = "R9829600"   # ASVAB math+verbal percentile 0-100 (numeracy proxy = CONTROL, not fin-literacy)
NLSY_ASVAB_MK    = "R9706000"   # ASVAB math-knowledge ability (3 implied decimals)
NLSY_APECON      = "R9831500"   # AP economics score (sparse — 13 respondents)
NLSY_FINASSETS20 = "Z9049700"
NLSY_DEBT20      = "Z9050100"

def _nls_missing(s):  # NLS negative codes (-1..-5) and 95 (HGC ungraded) -> NaN
    s = pd.to_numeric(s, errors="coerce")
    return s.where(s >= 0)

def _hgc_to_edu(h):
    if pd.isna(h) or h == 95: return np.nan
    if h < 12: return 1
    if h == 12: return 2
    if h <= 15: return 3
    if h == 16: return 4
    return 5

def clean_nlsy97():
    df = pd.read_csv(RAW / "nlsy97" / "nlsy97_20260723_full.csv", low_memory=False)
    steps = {"raw": len(df)}
    by = pd.to_numeric(df["R0536402"], errors="coerce")   # birth year 1980-84
    age20yr = by + 20                                       # everyone is 18-24 at age 20 (survey yrs 2000-2004)
    steps["age_18_24(age20 anchor)"] = int(age20yr.notna().sum())

    def pick(mapping):
        s = pd.Series(np.nan, index=df.index)
        for yr, col in mapping.items():
            if col in df:
                m = age20yr == yr
                s[m] = _nls_missing(df.loc[m, col])
        return s

    def deflate_by(nominal, ref_year):
        return pd.Series([deflate(v, int(y)) if pd.notna(v) and pd.notna(y) and int(y) in CPI else np.nan
                          for v, y in zip(nominal, ref_year)], index=df.index).round(0)

    out = pd.DataFrame(index=df.index)
    out["source_dataset"] = "nlsy97_1997cohort"
    out["survey_year"] = age20yr.astype("Int64")
    out["respondent_id"] = df["R0000100"]
    out["age"] = 20
    out["age_band"] = "18-24"
    out["female"] = to01(df["R0536300"], yes=2, no=1)
    out["race_ethnicity"] = df["R1482600"]                 # 1=Black,2=Hispanic,3=Mixed,4=NBNH
    out["education_level"] = pick(NLSY_HGC).map(_hgc_to_edu)
    out["census_region"] = pick(NLSY_REGION)               # 1=NE,2=NC,3=South,4=West
    out["household_size"] = pick(NLSY_SIZE)

    inc_ref_year = age20yr - 1                              # income is prior-year
    inc_nominal = pick(NLSY_INCOME)
    out["household_income_2020_usd"] = deflate_by(inc_nominal, inc_ref_year)
    out["income_is_banded"] = False

    # underserved — CLEAN: NLSY97 household-income-to-poverty ratio <= 200% (value has 2 implied decimals)
    pov = pick(NLSY_POV)
    out["underserved_200fpl"] = (pov <= 200).astype(float).where(pov.notna())
    out["underserved_method"] = "CV_HH_POV_RATIO<=200pct"
    out["pov_ratio"] = (pov / 100).round(2)                # exposed for controls (1.0 = at the poverty line)

    # SAVINGS behavior — checking/savings/money-market account ownership (YAST-4400: 1-4=yes, 0=no)
    savown = pick(NLSY_SAVOWN)
    has_account = pd.Series(np.nan, index=df.index)
    has_account[savown.isin([1, 2, 3, 4])] = 1.0
    has_account[savown == 0] = 0.0
    out["savings_behavior_index"] = (has_account * 100).round(2)   # account-ownership based (1 of 3 spec components)

    # NOT fielded at 1997-2006 target years -> left NaN (per research lead)
    out["financial_knowledge_score"] = np.nan
    out["credit_behavior_index"] = np.nan
    out["spending_behavior_index"] = np.nan

    # controls / position variables (extra columns)
    out["net_worth_2020_usd"] = deflate_by(pick(NLSY_NW), inc_ref_year)
    out["financial_assets_age20_2020_usd"] = deflate(_nls_missing(df[NLSY_FINASSETS20]), 2001).round(0)
    out["debt_age20_2020_usd"] = deflate(_nls_missing(df[NLSY_DEBT20]), 2001).round(0)
    out["asvab_math_verbal_pctile"] = (_nls_missing(df[NLSY_ASVAB_MVPCT]) / 1000).round(2)  # 0-100 pct (3 implied dec); numeracy control
    out["asvab_math_knowledge"] = (_nls_missing(df[NLSY_ASVAB_MK]) / 1000).round(3)
    out["ap_econ_score"] = _nls_missing(df[NLSY_APECON])                          # sparse fin-education signal
    out["sample_type"] = df["R1235800"]                    # 1=cross-sectional, 0=oversample

    # sampling weight (custom weight file, keyed by PUBID)
    w = pd.read_csv(RAW / "nlsy97" / "nlsy97_customweight_20260723.dat", sep=r"\s+",
                    header=None, names=["respondent_id", "weight"])
    wmap = dict(zip(w["respondent_id"], w["weight"]))
    out["weight"] = out["respondent_id"].map(wmap)

    # >=5% missingness HELD, not imputed (per B5): savings 21.3%, pov/income ~31%, hh_size 13%, educ 14%.
    imp = []
    steps["outcome_present"] = "savings only (~79%); knowledge/credit/spending not fielded — kept all records"
    steps["final_n"] = len(out)
    return out, steps, imp

# ---------------------------------------------------------------------------
# Orchestrate
# ---------------------------------------------------------------------------
def main():
    ranges = {"age": (18, 24), "household_income_2020_usd": (0, 1e7),
              "financial_knowledge_score": (0, 100), "savings_behavior_index": (0, 100),
              "credit_behavior_index": (0, 100), "spending_behavior_index": (0, 100),
              "underserved_200fpl": (0, 1), "female": (0, 1)}
    cont = ["household_income_2020_usd","financial_knowledge_score","savings_behavior_index",
            "credit_behavior_index","spending_behavior_index",
            "net_worth_2020_usd","financial_assets_age20_2020_usd","debt_age20_2020_usd"]
    jobs = [("cfpb_nfwbs_2016", clean_cfpb), ("scf_2022", clean_scf),
            ("nfcs_2018", lambda: clean_nfcs(2018)), ("nfcs_2021", lambda: clean_nfcs(2021)),
            ("nlsy97_1997cohort", clean_nlsy97)]
    report = {}
    for name, fn in jobs:
        out, steps, imp = fn()
        path = finish(out, name)
        val = validate(out, name, "respondent_id", cont, ranges)
        report[name] = {"steps": steps, "imputations": imp, "validation": val,
                        "path": str(path.relative_to(ROOT))}
        print("=" * 70); print(name)
        print("  filter counts:", steps)
        print("  <5% imputed:", imp if imp else "none")
        print("  validation:", val)
    import json
    (OUT / "validation_summary.json").write_text(json.dumps(report, indent=2, default=str))
    print("\nWrote outputs/validation_summary.json")
    return report

if __name__ == "__main__":
    main()

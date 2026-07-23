"""Step 2 (item 10) missing-value audit on key analysis variables.
Treats documented survey missing codes as missing. Buckets each variable into
<5% / 5-20% / >20% per the spec so the flag-and-discuss items can be surfaced.
Reports on FULL raw datasets (age filter is still an open decision).
"""
import pandas as pd
import numpy as np

def pct_missing(s, missing_vals):
    s = s.copy()
    # treat blanks / whitespace as missing
    if s.dtype == object:
        s = s.replace(r"^\s*$", np.nan, regex=True)
        s = pd.to_numeric(s, errors="coerce")
    mask = s.isna() | s.isin(missing_vals)
    return 100.0 * mask.sum() / len(s)

def audit(name, path, groups, missing_vals):
    df = pd.read_csv(path, low_memory=False)
    print("="*80)
    print(f"{name}  (n={len(df):,})   missing codes treated as missing: {missing_vals}")
    for grp, cols in groups.items():
        print(f"\n  [{grp}]")
        for c in cols:
            if c not in df.columns:
                print(f"    {c:<16} NOT FOUND"); continue
            p = pct_missing(df[c], missing_vals)
            bucket = "<5%" if p < 5 else ("5-20% FLAG" if p <= 20 else ">20% UNUSABLE?")
            print(f"    {c:<16} {p:6.2f}%   {bucket}")

# ---- CFPB NFWBS 2016 ----
audit("CFPB NFWBS 2016", "data/raw/cfpb_financial_wellbeing/NFWBS_PUF_2016_data.csv",
      {"age/pop": ["agecat","PPINCIMP","PCTLT200FPL","PPEDUC","PPREG4"],
       "fin_knowledge": ["FWBscore","FSscore","LMscore","FINKNOWL1","FINKNOWL2","FINKNOWL3"],
       "savings": ["SAVINGSRANGES","SAVEHABIT"],
       "spending": ["PROPPLAN_1","PROPPLAN_2","PROPPLAN_3","PROPPLAN_4"]},
      missing_vals=[-1,-2,-3,-4,-5])

# ---- SCF 2022 ----
audit("SCF 2022", "data/raw/federal_reserve_scf/SCFP2022.csv",
      {"age/income": ["AGE","INCOME","EDUC"],
       "knowledge": ["KNOWL"],
       "savings": ["SAVED","HLIQ","EMERGSAV"],
       "credit": ["CCBAL","HCCBAL","CREDIT"]},
      missing_vals=[-1])

# ---- NFCS 2018 ----
audit("NFCS 2018", "data/raw/finra_nfcs/NFCS 2018 State Data 190603.csv",
      {"age/income/geo": ["A3Ar_w","A8","A5_2015","CENSUSREG"],
       "fin_literacy": ["M6","M7","M8","M9","M10","M1_1"],
       "savings": ["J5","B1","B2"],
       "credit": ["F2_1","G1","G20"]},
      missing_vals=[98,99])

# ---- NFCS 2021 ----
audit("NFCS 2021", "data/raw/finra_nfcs/NFCS 2021 State Data 220627.csv",
      {"age/income/geo": ["A3Ar_w","A8_2021","A5_2015","CENSUSREG"],
       "fin_literacy": ["M6","M7","M8","M9","M10","M1_1"],
       "savings": ["J5","B1","B2"],
       "credit": ["F2_1","G1","G20"]},
      missing_vals=[98,99])

"""Exploratory audit of Paper 1 raw datasets — identify key variables.
Not part of the cleaning pipeline; used to ground cleaning decisions.
"""
import pandas as pd
import re

pd.set_option("display.max_columns", 200)

DATASETS = {
    "cfpb_financial_wellbeing": "data/raw/cfpb_financial_wellbeing/NFWBS_PUF_2016_data.csv",
    "federal_reserve_scf": "data/raw/federal_reserve_scf/SCFP2022.csv",
    "nlsy97": "data/raw/nlsy97/default.csv",
    "finra_nfcs_2018": "data/raw/finra_nfcs/NFCS 2018 State Data 190603.csv",
    "finra_nfcs_2021": "data/raw/finra_nfcs/NFCS 2021 State Data 220627.csv",
}

# patterns that hint at key concepts
PATTERNS = {
    "age": r"age|yob|birth|ppage|cyrb|a3a?r?_?w?$",
    "income/poverty": r"income|ppinc|fpl|poverty|hhinc|a8|wage|earn",
    "id": r"id$|_id|pubid|caseid|nfcsid|puf",
    "fin_literacy": r"know|liter|lm|kh|m6|m7|m8|m9|m10|m1_|quiz|score",
    "savings": r"sav|emerg|rainy|j5|b1|b2",
    "credit": r"credit|card|ccbal|f2|g1|g20|debt|loan",
    "spend": r"spend|budget|impuls|plan|track|b41|j",
    "education": r"educ|ppeduc|a5|degree|school",
    "region/geo": r"region|state|census|zip|geo|ppreg",
}

for name, path in DATASETS.items():
    print("=" * 90)
    print(name, "->", path)
    try:
        df = pd.read_csv(path, nrows=5, low_memory=False)
    except Exception as e:
        print("  READ ERROR:", e)
        continue
    cols = list(df.columns)
    print(f"  shape(head): cols={len(cols)}")
    for concept, pat in PATTERNS.items():
        hits = [c for c in cols if re.search(pat, str(c), re.I)]
        if hits:
            print(f"  [{concept}]: {hits[:25]}")
    print()

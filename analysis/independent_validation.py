"""
Rohan — Task 1: INDEPENDENT validation of Yousef's cleaned Paper 1 data.

Re-derives every check straight from the RAW files (does NOT import the cleaning
pipeline — that would be circular). Compares against the cleaned outputs and
Yousef's recorded validation_summary.json.

Checks (spec items 1-3):
  1. Null-count check on primary variables — independent recount vs Yousef's output.
  2. 50 random records — verify the 18-24 age filter was applied correctly, AND
     confirm exact set-equality between cleaned IDs and raw IDs that pass the filter.
  3. 10 random records — recompute a composite from raw components by hand and compare.
Per spec item 4: discrepancies are REPORTED, not fixed.
"""
import pandas as pd, numpy as np, json
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
RAW, CLEAN, OUT = ROOT/"data"/"raw", ROOT/"data"/"cleaned", ROOT/"outputs"
rng = np.random.default_rng(42)
PRIM = ["financial_knowledge_score","savings_behavior_index","credit_behavior_index","spending_behavior_index"]
findings = []   # discrepancies to report (not fix)

def load_clean(name):
    return pd.read_csv(CLEAN/name/f"{name}_clean.csv")

# raw loaders + the independent age-filter predicate (returns the set of raw IDs that SHOULD be kept)
def raw_cfpb():
    d = pd.read_csv(RAW/"cfpb_financial_wellbeing"/"NFWBS_PUF_2016_data.csv", low_memory=False)
    keep = set(d.loc[d["agecat"]==1, "PUF_ID"].astype(int))
    return d, "PUF_ID", keep
def raw_scf():
    d = pd.read_csv(RAW/"federal_reserve_scf"/"SCFP2022.csv", low_memory=False)
    keep = set(d.loc[(d["AGE"]>=18)&(d["AGE"]<=24), "Y1"].astype(int))
    return d, "Y1", keep
def raw_nfcs(year):
    f = "NFCS 2018 State Data 190603.csv" if year==2018 else "NFCS 2021 State Data 220627.csv"
    d = pd.read_csv(RAW/"finra_nfcs"/f, low_memory=False)
    keep = set(d.loc[d["A3Ar_w"]==1, "NFCSID"].astype(int))
    return d, "NFCSID", keep
def raw_nlsy():
    d = pd.read_csv(RAW/"nlsy97"/"nlsy97_20260723_full.csv", low_memory=False)
    keep = set(d["R0000100"].astype(int))   # age-20 anchor -> whole cohort qualifies
    return d, "R0000100", keep

RAW_SPECS = {"cfpb_nfwbs_2016": raw_cfpb, "scf_2022": raw_scf,
             "nfcs_2018": lambda: raw_nfcs(2018), "nfcs_2021": lambda: raw_nfcs(2021),
             "nlsy97_1997cohort": raw_nlsy}

print("="*78, "\nCHECK 1 — NULL COUNTS (independent recount vs Yousef's validation_summary.json)\n", "="*78)
yousef = json.loads((OUT/"validation_summary.json").read_text())
for name in RAW_SPECS:
    cl = load_clean(name)
    mine = {c:int(cl[c].isna().sum()) for c in PRIM if c in cl}
    his = yousef[name]["validation"]["nulls_in_primary"]
    match = mine == his
    print(f"{name:20} mine={mine}  match={'OK' if match else 'MISMATCH'}")
    if not match: findings.append(f"[null-count] {name}: mine={mine} vs Yousef={his}")

print("\n"+"="*78, "\nCHECK 2 — FILTERING (50 random cleaned records + exact ID set-equality)\n", "="*78)
for name, spec in RAW_SPECS.items():
    d, idcol, keep = spec()
    cl = load_clean(name)
    clean_ids = set(cl["respondent_id"].astype(int))
    # exact set equality (covers all records, not just 50)
    extra = clean_ids - keep       # in cleaned but should NOT be
    missing = keep - clean_ids     # should be kept but absent from cleaned
    # 50-record spot check: sample 50 cleaned ids, confirm each passes the raw age predicate
    sample = list(rng.choice(sorted(clean_ids), size=min(50,len(clean_ids)), replace=False))
    bad = [i for i in sample if i not in keep]
    status = "OK" if not extra and not missing and not bad else "MISMATCH"
    print(f"{name:20} clean_n={len(clean_ids)} raw_pass={len(keep)} extra={len(extra)} missing={len(missing)} sample50_bad={len(bad)}  {status}")
    if extra or missing or bad:
        findings.append(f"[filter] {name}: extra={len(extra)} missing={len(missing)} sample_bad={len(bad)}")

print("\n"+"="*78, "\nCHECK 3 — COMPOSITE ARITHMETIC (recompute 10 records from raw, compare)\n", "="*78)

def check_records(name, idcol, d, cl, target, recompute, k=10):
    """recompute(rawrow)->expected value for `target`; compare on k random valid records."""
    merged = cl.merge(d, left_on="respondent_id", right_on=idcol, how="left")
    valid = merged[merged[target].notna()]
    if valid.empty:
        print(f"  {name}.{target}: (all NaN — skipped)"); return
    idx = rng.choice(valid.index, size=min(k,len(valid)), replace=False)
    mism = 0
    for i in idx:
        exp = recompute(merged.loc[i]); got = merged.loc[i, target]
        if pd.isna(exp) or abs(exp-got) > 0.05:
            mism += 1
            findings.append(f"[composite] {name}.{target} id={merged.loc[i,'respondent_id']}: recomputed {exp} vs cleaned {got}")
    print(f"  {name:18}.{target:26} checked {len(idx)}  mismatches={mism}  {'OK' if mism==0 else 'MISMATCH'}")

# --- CFPB knowledge = mean of 12 correct flags (>=0) *100
cf, cfid, _ = raw_cfpb(); cfc = load_clean("cfpb_nfwbs_2016")
KFLAGS = ["FK1correct","FK2correct","FK3correct"]+[f"KH{i}correct" for i in range(1,10)]
def cfpb_know(r):
    v = pd.to_numeric(pd.Series([r[c] for c in KFLAGS]), errors="coerce")
    v = v[v>=0]
    return round(v.mean()*100,2) if len(v) else np.nan
check_records("cfpb", "PUF_ID", cf, cfc, "financial_knowledge_score", cfpb_know)

# --- SCF knowledge = FINLIT/3*100
sc, scid, _ = raw_scf(); scc = load_clean("scf_2022")
check_records("scf", "Y1", sc, scc, "financial_knowledge_score", lambda r: round(r["FINLIT"]/3*100,2))

# --- NFCS knowledge = Big-Five correct (DK/refused wrong) mean*100 ; savings = (B2 + J5)/2*100
CORR = {"M6":1,"M7":3,"M8":2,"M9":1,"M10":2}
def nfcs_know(r): return round(np.mean([1.0 if r[q]==a else 0.0 for q,a in CORR.items()])*100,2)
def yn(v):  # NFCS 1=yes->1, 2=no->0, else nan
    return 1.0 if v==1 else (0.0 if v==2 else np.nan)
def nfcs_sav(r):
    comps=[yn(r["B2"]), yn(r["J5"])]; comps=[c for c in comps if pd.notna(c)]
    return round(np.mean(comps)*100,2) if comps else np.nan
for yr in (2018,2021):
    d,idc,_ = raw_nfcs(yr); cl = load_clean(f"nfcs_{yr}")
    check_records(f"nfcs_{yr}", "NFCSID", d, cl, "financial_knowledge_score", nfcs_know)
    check_records(f"nfcs_{yr}", "NFCSID", d, cl, "savings_behavior_index", nfcs_sav)

# --- NLSY97 savings = YAST-4400 ownership (1-4 -> 100, 0 -> 0), by age-20 survey year
nl, nlid, _ = raw_nlsy(); nlc = load_clean("nlsy97_1997cohort")
SAVOWN = {1998:"R2370600",1999:"R3678300",2000:"R5128600",2001:"R6858400",2002:"S1092600",
          2003:"S3165000",2004:"S4822600",2005:"S6518400",2006:"S8516500"}
def nlsy_sav(r):
    yr = int(r["R0536402"])+20; col = SAVOWN.get(yr)
    if col is None or col not in r: return np.nan
    v = r[col]
    if v in (1,2,3,4): return 100.0
    if v == 0: return 0.0
    return np.nan
check_records("nlsy97", "R0000100", nl, nlc, "savings_behavior_index", nlsy_sav)

print("\n"+"="*78, "\nSUMMARY\n", "="*78)
if findings:
    print(f"{len(findings)} DISCREPANCY(IES) FOUND — reporting, not fixing (spec item 4):")
    for f in findings: print("  -", f)
else:
    print("ALL INDEPENDENT CHECKS PASSED — no discrepancies. Cleaned data reproduces from raw.")

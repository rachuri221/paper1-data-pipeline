
file handle pcdat/name='NLSY97.dat' /lrecl=475.
data list file pcdat free /
  R0000100 (F4)
  R0041603 (F2)
  R0507500 (F2)
  R0507600 (F4)
  R0507700 (F2)
  R0536300 (F2)
  R0536401 (F2)
  R0536402 (F4)
  R1200300 (F2)
  R1204500 (F6)
  R1204700 (F7)
  R1204800 (F6)
  R1204900 (F4)
  R1205400 (F2)
  R1217500 (F2)
  R1235800 (F2)
  R1482600 (F2)
  R1704004 (F2)
  R2370600 (F2)
  R2370700 (F2)
  R2370900 (F2)
  R2558800 (F2)
  R2563201 (F2)
  R2563300 (F6)
  R2563400 (F6)
  R2563500 (F4)
  R2563700 (F2)
  R2576800 (F2)
  R2996504 (F2)
  R3678300 (F2)
  R3678400 (F2)
  R3678600 (F2)
  R3880300 (F2)
  R3884801 (F2)
  R3884900 (F6)
  R3885000 (F6)
  R3885100 (F4)
  R3885300 (F2)
  R3899100 (F2)
  R4262104 (F2)
  R5128600 (F2)
  R5128700 (F2)
  R5128900 (F2)
  R5459400 (F2)
  R5464001 (F2)
  R5464100 (F6)
  R5464200 (F6)
  R5464300 (F4)
  R5464500 (F2)
  R5484100 (F2)
  R5919804 (F2)
  R6858400 (F2)
  R6858500 (F2)
  R6858700 (F2)
  R7222400 (F2)
  R7227701 (F2)
  R7227800 (F6)
  R7227900 (F6)
  R7228000 (F4)
  R7228200 (F2)
  R7248400 (F2)
  R9705300 (F4)
  R9706000 (F4)
  R9829600 (F6)
  R9831500 (F2)
  S0294104 (F2)
  S1092600 (F2)
  S1092700 (F2)
  S1093100 (F2)
  S1535500 (F2)
  S1541601 (F2)
  S1541700 (F6)
  S1541800 (F7)
  S1541900 (F4)
  S1542100 (F2)
  S1564300 (F2)
  S2005400 (F2)
  S2011401 (F2)
  S2011500 (F6)
  S2011600 (F6)
  S2011700 (F4)
  S2011900 (F2)
  S2034400 (F2)
  S2332904 (F2)
  S3165000 (F2)
  S3165100 (F2)
  S3165500 (F2)
  S3805700 (F2)
  S3812301 (F2)
  S3812400 (F6)
  S3812500 (F4)
  S3813400 (F2)
  S3835800 (F2)
  S4104604 (F2)
  S4822600 (F2)
  S4822700 (F2)
  S4823100 (F2)
  S5405600 (F2)
  S5412700 (F2)
  S5412800 (F6)
  S5412900 (F4)
  S5413000 (F2)
  S5436300 (F2)
  S5664704 (F2)
  S6518400 (F2)
  S6518500 (F2)
  S6518900 (F2)
  S7506100 (F2)
  S7513600 (F2)
  S7513700 (F6)
  S7513800 (F4)
  S7513900 (F2)
  S7537100 (F2)
  S7740704 (F2)
  S8516500 (F2)
  S8516600 (F2)
  S8517000 (F2)
  Z9049700 (F6)
  Z9050100 (F6)
.

* The following code works with current versions of SPSS.

missing values all (-5 thru -1).
* older versions of SPSS may require this:
* recode all (-5,-3,-2,-1=-4).
* missing values all (-4).



variable labels
  R0000100  "PUBID - YTH ID CODE 1997"
  R0041603  "SUBJECTS TOOK AP EXAMS (COLL) - ECONOMICS 1997"
  R0507500  "CHECKING SAVING MONEY MKT ACCTS? 1997"
  R0507600  "MKT VAL CHK, SAV, MONEY MKT ACCT 1997"
  R0507700  "EST MKT VAL CHK, SAV, MONEY MKT 1997"
  R0536300  "KEY!SEX (SYMBOL) 1997"
  R0536401  "KEY!BDATE M/Y (SYMBOL) 1997"
  R0536402  "KEY!BDATE M/Y (SYMBOL) 1997"
  R1200300  "CV_CENSUS_REGION 1997"
  R1204500  "CV_INCOME_GROSS_YR 1997"
  R1204700  "CV_HH_NET_WORTH_P 1997"
  R1204800  "CV_HH_NET_WORTH_Y 1997"
  R1204900  "CV_HH_POV_RATIO 1997"
  R1205400  "CV_HH_SIZE 1997"
  R1217500  "CV_URBAN-RURAL 1997"
  R1235800  "CV_SAMPLE_TYPE 1997"
  R1482600  "KEY!RACE_ETHNICITY (SYMBOL) 1997"
  R1704004  "SUBJECTS R TOOK AP EXAMS - ECONOMICS 1998"
  R2370600  "CHECKING SAVING MONEY MKT ACCTS? 1998"
  R2370700  "MKT VAL CHK, SAV, MONEY MKT ACCT 1998"
  R2370900  "EST VAL CHK SAV MONEY MKT ACCT 1998"
  R2558800  "CV_CENSUS_REGION 1998"
  R2563201  "CV_HGC_9899 1998"
  R2563300  "CV_INCOME_GROSS_YR 1998"
  R2563400  "CV_HH_NET_WORTH_Y 1998"
  R2563500  "CV_HH_POV_RATIO 1998"
  R2563700  "CV_HH_SIZE 1998"
  R2576800  "CV_URBAN-RURAL 1998"
  R2996504  "SUBJECTS R TOOK AP EXAMS - ECONOMICS 1999"
  R3678300  "CHECKING SAVING MONEY MKT ACCTS? 1999"
  R3678400  "MKT VAL CHK, SAV, MONEY MKT ACCT 1999"
  R3678600  "EST VAL CHK SAV MONEY MKT ACCT 1999"
  R3880300  "CV_CENSUS_REGION 1999"
  R3884801  "CV_HGC_9900 1999"
  R3884900  "CV_INCOME_GROSS_YR 1999"
  R3885000  "CV_HH_NET_WORTH_Y 1999"
  R3885100  "CV_HH_POV_RATIO 1999"
  R3885300  "CV_HH_SIZE 1999"
  R3899100  "CV_URBAN-RURAL 1999"
  R4262104  "SUBJECTS R TOOK AP EXAMS - ECONOMICS 2000"
  R5128600  "CHECKING SAVING MONEY MKT ACCTS? 2000"
  R5128700  "MKT VAL CHK, SAV, MONEY MKT ACCT 2000"
  R5128900  "EST VAL CHK SAV MONEY MKT ACCT 2000"
  R5459400  "CV_CENSUS_REGION 2000"
  R5464001  "CV_HGC_0001 2000"
  R5464100  "CV_INCOME_GROSS_YR 2000"
  R5464200  "CV_HH_NET_WORTH_Y 2000"
  R5464300  "CV_HH_POV_RATIO 2000"
  R5464500  "CV_HH_SIZE 2000"
  R5484100  "CV_URBAN-RURAL 2000"
  R5919804  "SUBJECTS R TOOK AP EXAMS - ECONOMICS 2001"
  R6858400  "CHECKING SAVING MONEY MKT ACCTS? 2001"
  R6858500  "MKT VAL CHK, SAV, MONEY MKT ACCT 2001"
  R6858700  "EST VAL CHK SAV MONEY MKT ACCT 2001"
  R7222400  "CV_CENSUS_REGION 2001"
  R7227701  "CV_HGC_0102 2001"
  R7227800  "CV_INCOME_GROSS_YR 2001"
  R7227900  "CV_HH_NET_WORTH_Y 2001"
  R7228000  "CV_HH_POV_RATIO 2001"
  R7228200  "CV_HH_SIZE 2001"
  R7248400  "CV_URBAN-RURAL 2001"
  R9705300  "ASVAB_AR_ABILITY_EST_POS XRND"
  R9706000  "ASVAB_MK_ABILITY_EST_POS XRND"
  R9829600  "ASVAB_MATH_VERBAL_SCORE_PCT XRND"
  R9831500  "TRANS_AP_ECON HSTR"
  S0294104  "SUBJECTS R TOOK AP EXAMS - ECONOMICS 2002"
  S1092600  "CHECKING SAVING MONEY MKT ACCTS? 2002"
  S1092700  "MKT VAL CHK, SAV, MONEY MKT ACCT 2002"
  S1093100  "EST VAL CHK SAV MONEY MKT ACCT 2002"
  S1535500  "CV_CENSUS_REGION 2002"
  S1541601  "CV_HGC_0203 2002"
  S1541700  "CV_INCOME_GROSS_YR 2002"
  S1541800  "CV_HH_NET_WORTH_Y 2002"
  S1541900  "CV_HH_POV_RATIO 2002"
  S1542100  "CV_HH_SIZE 2002"
  S1564300  "CV_URBAN-RURAL 2002"
  S2005400  "CV_CENSUS_REGION 2003"
  S2011401  "CV_HGC_0304 2003"
  S2011500  "CV_INCOME_GROSS_YR 2003"
  S2011600  "CV_HH_NET_WORTH_Y 2003"
  S2011700  "CV_HH_POV_RATIO 2003"
  S2011900  "CV_HH_SIZE 2003"
  S2034400  "CV_URBAN-RURAL 2003"
  S2332904  "SUBJECTS R TOOK AP EXAMS - ECONOMICS 2003"
  S3165000  "CHECKING SAVING MONEY MKT ACCTS? 2003"
  S3165100  "MKT VAL CHK, SAV, MONEY MKT ACCT 2003"
  S3165500  "EST VAL CHK SAV MONEY MKT ACCT 2003"
  S3805700  "CV_CENSUS_REGION 2004"
  S3812301  "CV_HGC_0405 2004"
  S3812400  "CV_INCOME_FAMILY 2004"
  S3812500  "CV_HH_POV_RATIO 2004"
  S3813400  "CV_HH_SIZE 2004"
  S3835800  "CV_URBAN-RURAL 2004"
  S4104604  "SUBJECTS R TOOK AP EXAMS - ECONOMICS 2004"
  S4822600  "CHECKING SAVING MONEY MKT ACCTS? 2004"
  S4822700  "MKT VAL CHK, SAV, MONEY MKT ACCT 2004"
  S4823100  "EST VAL CHK SAV MONEY MKT ACCT 2004"
  S5405600  "CV_CENSUS_REGION 2005"
  S5412700  "CV_HGC_0506 2005"
  S5412800  "CV_INCOME_FAMILY 2005"
  S5412900  "CV_HH_POV_RATIO 2005"
  S5413000  "CV_HH_SIZE 2005"
  S5436300  "CV_URBAN-RURAL 2005"
  S5664704  "SUBJECTS R TOOK AP EXAMS - ECONOMICS 2005"
  S6518400  "CHECKING SAVING MONEY MKT ACCTS? 2005"
  S6518500  "MKT VAL CHK, SAV, MONEY MKT ACCT 2005"
  S6518900  "EST VAL CHK SAV MONEY MKT ACCT 2005"
  S7506100  "CV_CENSUS_REGION 2006"
  S7513600  "CV_HGC_0607 2006"
  S7513700  "CV_INCOME_FAMILY 2006"
  S7513800  "CV_HH_POV_RATIO 2006"
  S7513900  "CV_HH_SIZE 2006"
  S7537100  "CV_URBAN-RURAL 2006"
  S7740704  "SUBJECTS R TOOK AP EXAMS - ECONOMICS 2006"
  S8516500  "CHECKING SAVING MONEY MKT ACCTS? 2006"
  S8516600  "MKT VAL CHK, SAV, MONEY MKT ACCT 2006"
  S8517000  "EST VAL CHK SAV MONEY MKT ACCT 2006"
  Z9049700  "CVC_ASSETS_FINANCIAL_20"
  Z9050100  "CVC_ASSETS_DEBT_20"
.

* Recode continuous values.
* recode
  R0000100
    (0 thru 0 eq 0)
    /
    (1 thru 999 eq 1)
    /
    (1000 thru 1999 eq 1000)
    /
    (2000 thru 2999 eq 2000)
    /
    (3000 thru 3999 eq 3000)
    /
    (4000 thru 4999 eq 4000)
    /
    (5000 thru 5999 eq 5000)
    /
    (6000 thru 6999 eq 6000)
    /
    (7000 thru 7999 eq 7000)
    /
    (8000 thru 8999 eq 8000)
    /
    (9000 thru 9999 eq 9000)
    /
  R0041603
    (1 thru 4 eq 1)
    /
    (0 thru 0 eq 0)
    /
  R0507600
    (0 thru 0 eq 0)
    /
    (1 thru 4999 eq 1)
    /
    (5000 thru 9999 eq 5000)
    /
    (10000 thru 14999 eq 10000)
    /
    (15000 thru 19999 eq 15000)
    /
    (20000 thru 24999 eq 20000)
    /
    (25000 thru 29999 eq 25000)
    /
    (30000 thru 39999 eq 30000)
    /
    (40000 thru 49999 eq 40000)
    /
    (50000 thru 59999 eq 50000)
    /
    (60000 thru 69999 eq 60000)
    /
    (70000 thru 79999 eq 70000)
    /
    (80000 thru 89999 eq 80000)
    /
    (90000 thru 99999 eq 90000)
    /
    (100000 thru 149999 eq 100000)
    /
    (150000 thru 99999999 eq 150000)
    /
  R1204500
    (-999999 thru -3000 eq -999999)
    /
    (-2999 thru -2000 eq -2999)
    /
    (-1999 thru -1000 eq -1999)
    /
    (-999 thru -1 eq -999)
    /
    (0 thru 0 eq 0)
    /
    (1 thru 1000 eq 1)
    /
    (1001 thru 2000 eq 1001)
    /
    (2001 thru 3000 eq 2001)
    /
    (3001 thru 5000 eq 3001)
    /
    (5001 thru 10000 eq 5001)
    /
    (10001 thru 20000 eq 10001)
    /
    (20001 thru 30000 eq 20001)
    /
    (30001 thru 40000 eq 30001)
    /
    (40001 thru 50000 eq 40001)
    /
    (50001 thru 65000 eq 50001)
    /
    (65001 thru 80000 eq 65001)
    /
    (80001 thru 100000 eq 80001)
    /
    (100001 thru 150000 eq 100001)
    /
    (150001 thru 200000 eq 150001)
    /
    (200001 thru 999999 eq 200001)
    /
  R1204700
    (-999999 thru -3000 eq -999999)
    /
    (-2999 thru -2000 eq -2999)
    /
    (-1999 thru -1000 eq -1999)
    /
    (-999 thru -6 eq -999)
    /
    (0 thru 0 eq 0)
    /
    (1 thru 1000 eq 1)
    /
    (1001 thru 2000 eq 1001)
    /
    (2001 thru 3000 eq 2001)
    /
    (3001 thru 5000 eq 3001)
    /
    (5001 thru 10000 eq 5001)
    /
    (10001 thru 20000 eq 10001)
    /
    (20001 thru 30000 eq 20001)
    /
    (30001 thru 40000 eq 30001)
    /
    (40001 thru 50000 eq 40001)
    /
    (50001 thru 65000 eq 50001)
    /
    (65001 thru 80000 eq 65001)
    /
    (80001 thru 100000 eq 80001)
    /
    (100001 thru 150000 eq 100001)
    /
    (150001 thru 200000 eq 150001)
    /
    (200001 thru 500000 eq 200001)
    /
    (500001 thru 1000000 eq 500001)
    /
    (1000001 thru 1500000 eq 1000001)
    /
    (1500001 thru 2000000 eq 1500001)
    /
    (2000001 thru 999999999 eq 2000001)
    /
  R1204800
    (-999999 thru -3000 eq -999999)
    /
    (-2999 thru -2000 eq -2999)
    /
    (-1999 thru -1000 eq -1999)
    /
    (-999 thru -6 eq -999)
    /
    (0 thru 0 eq 0)
    /
    (1 thru 1000 eq 1)
    /
    (1001 thru 2000 eq 1001)
    /
    (2001 thru 3000 eq 2001)
    /
    (3001 thru 5000 eq 3001)
    /
    (5001 thru 10000 eq 5001)
    /
    (10001 thru 20000 eq 10001)
    /
    (20001 thru 30000 eq 20001)
    /
    (30001 thru 40000 eq 30001)
    /
    (40001 thru 50000 eq 40001)
    /
    (50001 thru 65000 eq 50001)
    /
    (65001 thru 80000 eq 65001)
    /
    (80001 thru 100000 eq 80001)
    /
    (100001 thru 150000 eq 100001)
    /
    (150001 thru 200000 eq 150001)
    /
    (200001 thru 500000 eq 200001)
    /
    (500001 thru 1000000 eq 500001)
    /
    (1000001 thru 1500000 eq 1000001)
    /
    (1500001 thru 2000000 eq 1500001)
    /
    (2000001 thru 999999999 eq 2000001)
    /
  R1204900
    (0 thru 0 eq 0)
    /
    (1 thru 99 eq 1)
    /
    (100 thru 199 eq 100)
    /
    (200 thru 299 eq 200)
    /
    (300 thru 399 eq 300)
    /
    (400 thru 499 eq 400)
    /
    (500 thru 599 eq 500)
    /
    (600 thru 699 eq 600)
    /
    (700 thru 799 eq 700)
    /
    (800 thru 899 eq 800)
    /
    (900 thru 999 eq 900)
    /
    (1000 thru 1099 eq 1000)
    /
    (1100 thru 1199 eq 1100)
    /
    (1200 thru 1299 eq 1200)
    /
    (1300 thru 1399 eq 1300)
    /
    (1400 thru 1499 eq 1400)
    /
    (1500 thru 1599 eq 1500)
    /
    (1600 thru 1699 eq 1600)
    /
    (1700 thru 1799 eq 1700)
    /
    (1800 thru 1899 eq 1800)
    /
    (1900 thru 1999 eq 1900)
    /
    (2000 thru 2999 eq 2000)
    /
    (3000 thru 9999 eq 3000)
    /
  R1205400
    (0 thru 0 eq 0)
    /
    (1 thru 1 eq 1)
    /
    (2 thru 2 eq 2)
    /
    (3 thru 3 eq 3)
    /
    (4 thru 4 eq 4)
    /
    (5 thru 5 eq 5)
    /
    (6 thru 6 eq 6)
    /
    (7 thru 7 eq 7)
    /
    (8 thru 8 eq 8)
    /
    (9 thru 9 eq 9)
    /
    (10 thru 10 eq 10)
    /
    (11 thru 11 eq 11)
    /
    (12 thru 12 eq 12)
    /
    (13 thru 13 eq 13)
    /
    (14 thru 14 eq 14)
    /
    (15 thru 15 eq 15)
    /
    (16 thru 16 eq 16)
    /
    (17 thru 17 eq 17)
    /
    (18 thru 18 eq 18)
    /
    (19 thru 19 eq 19)
    /
    (20 thru 99 eq 20)
    /
  R1704004
    (1 thru 5 eq 1)
    /
    (0 thru 0 eq 0)
    /
  R2563300
    (-999999 thru -3000 eq -999999)
    /
    (-2999 thru -2000 eq -2999)
    /
    (-1999 thru -1000 eq -1999)
    /
    (-999 thru -1 eq -999)
    /
    (0 thru 0 eq 0)
    /
    (1 thru 1000 eq 1)
    /
    (1001 thru 2000 eq 1001)
    /
    (2001 thru 3000 eq 2001)
    /
    (3001 thru 5000 eq 3001)
    /
    (5001 thru 10000 eq 5001)
    /
    (10001 thru 20000 eq 10001)
    /
    (20001 thru 30000 eq 20001)
    /
    (30001 thru 40000 eq 30001)
    /
    (40001 thru 50000 eq 40001)
    /
    (50001 thru 65000 eq 50001)
    /
    (65001 thru 80000 eq 65001)
    /
    (80001 thru 100000 eq 80001)
    /
    (100001 thru 150000 eq 100001)
    /
    (150001 thru 200000 eq 150001)
    /
    (200001 thru 999999 eq 200001)
    /
  R2563400
    (-999999 thru -3000 eq -999999)
    /
    (-2999 thru -2000 eq -2999)
    /
    (-1999 thru -1000 eq -1999)
    /
    (-999 thru -1 eq -999)
    /
    (0 thru 0 eq 0)
    /
    (1 thru 1000 eq 1)
    /
    (1001 thru 2000 eq 1001)
    /
    (2001 thru 3000 eq 2001)
    /
    (3001 thru 5000 eq 3001)
    /
    (5001 thru 10000 eq 5001)
    /
    (10001 thru 20000 eq 10001)
    /
    (20001 thru 30000 eq 20001)
    /
    (30001 thru 40000 eq 30001)
    /
    (40001 thru 50000 eq 40001)
    /
    (50001 thru 65000 eq 50001)
    /
    (65001 thru 80000 eq 65001)
    /
    (80001 thru 100000 eq 80001)
    /
    (100001 thru 150000 eq 100001)
    /
    (150001 thru 200000 eq 150001)
    /
    (200001 thru 999999999 eq 200001)
    /
  R2563500
    (0 thru 0 eq 0)
    /
    (1 thru 99 eq 1)
    /
    (100 thru 199 eq 100)
    /
    (200 thru 299 eq 200)
    /
    (300 thru 399 eq 300)
    /
    (400 thru 499 eq 400)
    /
    (500 thru 599 eq 500)
    /
    (600 thru 699 eq 600)
    /
    (700 thru 799 eq 700)
    /
    (800 thru 899 eq 800)
    /
    (900 thru 999 eq 900)
    /
    (1000 thru 1099 eq 1000)
    /
    (1100 thru 1199 eq 1100)
    /
    (1200 thru 1299 eq 1200)
    /
    (1300 thru 1399 eq 1300)
    /
    (1400 thru 1499 eq 1400)
    /
    (1500 thru 1599 eq 1500)
    /
    (1600 thru 1699 eq 1600)
    /
    (1700 thru 1799 eq 1700)
    /
    (1800 thru 1899 eq 1800)
    /
    (1900 thru 1999 eq 1900)
    /
    (2000 thru 2999 eq 2000)
    /
    (3000 thru 9999 eq 3000)
    /
  R2563700
    (0 thru 0 eq 0)
    /
    (1 thru 1 eq 1)
    /
    (2 thru 2 eq 2)
    /
    (3 thru 3 eq 3)
    /
    (4 thru 4 eq 4)
    /
    (5 thru 5 eq 5)
    /
    (6 thru 6 eq 6)
    /
    (7 thru 7 eq 7)
    /
    (8 thru 8 eq 8)
    /
    (9 thru 9 eq 9)
    /
    (10 thru 10 eq 10)
    /
    (11 thru 11 eq 11)
    /
    (12 thru 12 eq 12)
    /
    (13 thru 13 eq 13)
    /
    (14 thru 14 eq 14)
    /
    (15 thru 15 eq 15)
    /
    (16 thru 16 eq 16)
    /
    (17 thru 17 eq 17)
    /
    (18 thru 18 eq 18)
    /
    (19 thru 19 eq 19)
    /
    (20 thru 99 eq 20)
    /
  R2996504
    (1 thru 5 eq 1)
    /
    (0 thru 0 eq 0)
    /
  R3884900
    (-999999 thru -3000 eq -999999)
    /
    (-2999 thru -2000 eq -2999)
    /
    (-1999 thru -1000 eq -1999)
    /
    (-999 thru -1 eq -999)
    /
    (0 thru 0 eq 0)
    /
    (1 thru 1000 eq 1)
    /
    (1001 thru 2000 eq 1001)
    /
    (2001 thru 3000 eq 2001)
    /
    (3001 thru 5000 eq 3001)
    /
    (5001 thru 10000 eq 5001)
    /
    (10001 thru 20000 eq 10001)
    /
    (20001 thru 30000 eq 20001)
    /
    (30001 thru 40000 eq 30001)
    /
    (40001 thru 50000 eq 40001)
    /
    (50001 thru 65000 eq 50001)
    /
    (65001 thru 80000 eq 65001)
    /
    (80001 thru 100000 eq 80001)
    /
    (100001 thru 150000 eq 100001)
    /
    (150001 thru 200000 eq 150001)
    /
    (200001 thru 999999 eq 200001)
    /
  R3885000
    (-999999 thru -3000 eq -999999)
    /
    (-2999 thru -2000 eq -2999)
    /
    (-1999 thru -1000 eq -1999)
    /
    (-999 thru -1 eq -999)
    /
    (0 thru 0 eq 0)
    /
    (1 thru 1000 eq 1)
    /
    (1001 thru 2000 eq 1001)
    /
    (2001 thru 3000 eq 2001)
    /
    (3001 thru 5000 eq 3001)
    /
    (5001 thru 10000 eq 5001)
    /
    (10001 thru 20000 eq 10001)
    /
    (20001 thru 30000 eq 20001)
    /
    (30001 thru 40000 eq 30001)
    /
    (40001 thru 50000 eq 40001)
    /
    (50001 thru 65000 eq 50001)
    /
    (65001 thru 80000 eq 65001)
    /
    (80001 thru 100000 eq 80001)
    /
    (100001 thru 150000 eq 100001)
    /
    (150001 thru 200000 eq 150001)
    /
    (200001 thru 999999999 eq 200001)
    /
  R3885100
    (0 thru 0 eq 0)
    /
    (1 thru 99 eq 1)
    /
    (100 thru 199 eq 100)
    /
    (200 thru 299 eq 200)
    /
    (300 thru 399 eq 300)
    /
    (400 thru 499 eq 400)
    /
    (500 thru 599 eq 500)
    /
    (600 thru 699 eq 600)
    /
    (700 thru 799 eq 700)
    /
    (800 thru 899 eq 800)
    /
    (900 thru 999 eq 900)
    /
    (1000 thru 1099 eq 1000)
    /
    (1100 thru 1199 eq 1100)
    /
    (1200 thru 1299 eq 1200)
    /
    (1300 thru 1399 eq 1300)
    /
    (1400 thru 1499 eq 1400)
    /
    (1500 thru 1599 eq 1500)
    /
    (1600 thru 1699 eq 1600)
    /
    (1700 thru 1799 eq 1700)
    /
    (1800 thru 1899 eq 1800)
    /
    (1900 thru 1999 eq 1900)
    /
    (2000 thru 2999 eq 2000)
    /
    (3000 thru 9999 eq 3000)
    /
  R3885300
    (0 thru 0 eq 0)
    /
    (1 thru 1 eq 1)
    /
    (2 thru 2 eq 2)
    /
    (3 thru 3 eq 3)
    /
    (4 thru 4 eq 4)
    /
    (5 thru 5 eq 5)
    /
    (6 thru 6 eq 6)
    /
    (7 thru 7 eq 7)
    /
    (8 thru 8 eq 8)
    /
    (9 thru 9 eq 9)
    /
    (10 thru 10 eq 10)
    /
    (11 thru 11 eq 11)
    /
    (12 thru 12 eq 12)
    /
    (13 thru 13 eq 13)
    /
    (14 thru 14 eq 14)
    /
    (15 thru 15 eq 15)
    /
    (16 thru 16 eq 16)
    /
    (17 thru 17 eq 17)
    /
    (18 thru 18 eq 18)
    /
    (19 thru 19 eq 19)
    /
    (20 thru 99 eq 20)
    /
  R4262104
    (1 thru 5 eq 1)
    /
    (0 thru 0 eq 0)
    /
  R5464100
    (-999999 thru -3000 eq -999999)
    /
    (-2999 thru -2000 eq -2999)
    /
    (-1999 thru -1000 eq -1999)
    /
    (-999 thru -1 eq -999)
    /
    (0 thru 0 eq 0)
    /
    (1 thru 1000 eq 1)
    /
    (1001 thru 2000 eq 1001)
    /
    (2001 thru 3000 eq 2001)
    /
    (3001 thru 5000 eq 3001)
    /
    (5001 thru 10000 eq 5001)
    /
    (10001 thru 20000 eq 10001)
    /
    (20001 thru 30000 eq 20001)
    /
    (30001 thru 40000 eq 30001)
    /
    (40001 thru 50000 eq 40001)
    /
    (50001 thru 65000 eq 50001)
    /
    (65001 thru 80000 eq 65001)
    /
    (80001 thru 100000 eq 80001)
    /
    (100001 thru 150000 eq 100001)
    /
    (150001 thru 200000 eq 150001)
    /
    (200001 thru 999999 eq 200001)
    /
  R5464200
    (-999999 thru -3000 eq -999999)
    /
    (-2999 thru -2000 eq -2999)
    /
    (-1999 thru -1000 eq -1999)
    /
    (-999 thru -1 eq -999)
    /
    (0 thru 0 eq 0)
    /
    (1 thru 1000 eq 1)
    /
    (1001 thru 2000 eq 1001)
    /
    (2001 thru 3000 eq 2001)
    /
    (3001 thru 5000 eq 3001)
    /
    (5001 thru 10000 eq 5001)
    /
    (10001 thru 20000 eq 10001)
    /
    (20001 thru 30000 eq 20001)
    /
    (30001 thru 40000 eq 30001)
    /
    (40001 thru 50000 eq 40001)
    /
    (50001 thru 65000 eq 50001)
    /
    (65001 thru 80000 eq 65001)
    /
    (80001 thru 100000 eq 80001)
    /
    (100001 thru 150000 eq 100001)
    /
    (150001 thru 200000 eq 150001)
    /
    (200001 thru 999999999 eq 200001)
    /
  R5464300
    (0 thru 0 eq 0)
    /
    (1 thru 99 eq 1)
    /
    (100 thru 199 eq 100)
    /
    (200 thru 299 eq 200)
    /
    (300 thru 399 eq 300)
    /
    (400 thru 499 eq 400)
    /
    (500 thru 599 eq 500)
    /
    (600 thru 699 eq 600)
    /
    (700 thru 799 eq 700)
    /
    (800 thru 899 eq 800)
    /
    (900 thru 999 eq 900)
    /
    (1000 thru 1099 eq 1000)
    /
    (1100 thru 1199 eq 1100)
    /
    (1200 thru 1299 eq 1200)
    /
    (1300 thru 1399 eq 1300)
    /
    (1400 thru 1499 eq 1400)
    /
    (1500 thru 1599 eq 1500)
    /
    (1600 thru 1699 eq 1600)
    /
    (1700 thru 1799 eq 1700)
    /
    (1800 thru 1899 eq 1800)
    /
    (1900 thru 1999 eq 1900)
    /
    (2000 thru 2999 eq 2000)
    /
    (3000 thru 9999 eq 3000)
    /
  R5464500
    (0 thru 0 eq 0)
    /
    (1 thru 1 eq 1)
    /
    (2 thru 2 eq 2)
    /
    (3 thru 3 eq 3)
    /
    (4 thru 4 eq 4)
    /
    (5 thru 5 eq 5)
    /
    (6 thru 6 eq 6)
    /
    (7 thru 7 eq 7)
    /
    (8 thru 8 eq 8)
    /
    (9 thru 9 eq 9)
    /
    (10 thru 10 eq 10)
    /
    (11 thru 11 eq 11)
    /
    (12 thru 12 eq 12)
    /
    (13 thru 13 eq 13)
    /
    (14 thru 14 eq 14)
    /
    (15 thru 15 eq 15)
    /
    (16 thru 16 eq 16)
    /
    (17 thru 17 eq 17)
    /
    (18 thru 18 eq 18)
    /
    (19 thru 19 eq 19)
    /
    (20 thru 99 eq 20)
    /
  R5919804
    (1 thru 5 eq 1)
    /
    (0 thru 0 eq 0)
    /
  R7227800
    (-999999 thru -3000 eq -999999)
    /
    (-2999 thru -2000 eq -2999)
    /
    (-1999 thru -1000 eq -1999)
    /
    (-999 thru -1 eq -999)
    /
    (0 thru 0 eq 0)
    /
    (1 thru 1000 eq 1)
    /
    (1001 thru 2000 eq 1001)
    /
    (2001 thru 3000 eq 2001)
    /
    (3001 thru 5000 eq 3001)
    /
    (5001 thru 10000 eq 5001)
    /
    (10001 thru 20000 eq 10001)
    /
    (20001 thru 30000 eq 20001)
    /
    (30001 thru 40000 eq 30001)
    /
    (40001 thru 50000 eq 40001)
    /
    (50001 thru 65000 eq 50001)
    /
    (65001 thru 80000 eq 65001)
    /
    (80001 thru 100000 eq 80001)
    /
    (100001 thru 150000 eq 100001)
    /
    (150001 thru 200000 eq 150001)
    /
    (200001 thru 999999 eq 200001)
    /
  R7227900
    (-999999 thru -3000 eq -999999)
    /
    (-2999 thru -2000 eq -2999)
    /
    (-1999 thru -1000 eq -1999)
    /
    (-999 thru -1 eq -999)
    /
    (0 thru 0 eq 0)
    /
    (1 thru 1000 eq 1)
    /
    (1001 thru 2000 eq 1001)
    /
    (2001 thru 3000 eq 2001)
    /
    (3001 thru 5000 eq 3001)
    /
    (5001 thru 10000 eq 5001)
    /
    (10001 thru 20000 eq 10001)
    /
    (20001 thru 30000 eq 20001)
    /
    (30001 thru 40000 eq 30001)
    /
    (40001 thru 50000 eq 40001)
    /
    (50001 thru 65000 eq 50001)
    /
    (65001 thru 80000 eq 65001)
    /
    (80001 thru 100000 eq 80001)
    /
    (100001 thru 150000 eq 100001)
    /
    (150001 thru 200000 eq 150001)
    /
    (200001 thru 999999999 eq 200001)
    /
  R7228000
    (0 thru 0 eq 0)
    /
    (1 thru 99 eq 1)
    /
    (100 thru 199 eq 100)
    /
    (200 thru 299 eq 200)
    /
    (300 thru 399 eq 300)
    /
    (400 thru 499 eq 400)
    /
    (500 thru 599 eq 500)
    /
    (600 thru 699 eq 600)
    /
    (700 thru 799 eq 700)
    /
    (800 thru 899 eq 800)
    /
    (900 thru 999 eq 900)
    /
    (1000 thru 1099 eq 1000)
    /
    (1100 thru 1199 eq 1100)
    /
    (1200 thru 1299 eq 1200)
    /
    (1300 thru 1399 eq 1300)
    /
    (1400 thru 1499 eq 1400)
    /
    (1500 thru 1599 eq 1500)
    /
    (1600 thru 1699 eq 1600)
    /
    (1700 thru 1799 eq 1700)
    /
    (1800 thru 1899 eq 1800)
    /
    (1900 thru 1999 eq 1900)
    /
    (2000 thru 2999 eq 2000)
    /
    (3000 thru 9999 eq 3000)
    /
  R7228200
    (0 thru 0 eq 0)
    /
    (1 thru 1 eq 1)
    /
    (2 thru 2 eq 2)
    /
    (3 thru 3 eq 3)
    /
    (4 thru 4 eq 4)
    /
    (5 thru 5 eq 5)
    /
    (6 thru 6 eq 6)
    /
    (7 thru 7 eq 7)
    /
    (8 thru 8 eq 8)
    /
    (9 thru 9 eq 9)
    /
    (10 thru 10 eq 10)
    /
    (11 thru 11 eq 11)
    /
    (12 thru 12 eq 12)
    /
    (13 thru 13 eq 13)
    /
    (14 thru 14 eq 14)
    /
    (15 thru 15 eq 15)
    /
    (16 thru 16 eq 16)
    /
    (17 thru 17 eq 17)
    /
    (18 thru 18 eq 18)
    /
    (19 thru 19 eq 19)
    /
    (20 thru 99 eq 20)
    /
  R9705300
    (0 thru 500 eq 0)
    /
    (501 thru 1000 eq 501)
    /
    (1001 thru 1500 eq 1001)
    /
    (1501 thru 2000 eq 1501)
    /
    (2001 thru 2500 eq 2001)
    /
    (2501 thru 3000 eq 2501)
    /
    (3001 thru 3500 eq 3001)
    /
  R9706000
    (0 thru 500 eq 0)
    /
    (501 thru 1000 eq 501)
    /
    (1001 thru 1500 eq 1001)
    /
    (1501 thru 2000 eq 1501)
    /
    (2001 thru 2500 eq 2001)
    /
    (2501 thru 3000 eq 2501)
    /
    (3001 thru 3500 eq 3001)
    /
  R9829600
    (0 thru 0 eq 0)
    /
    (1 thru 999 eq 1)
    /
    (1000 thru 19999 eq 1000)
    /
    (20000 thru 39999 eq 20000)
    /
    (40000 thru 59999 eq 40000)
    /
    (60000 thru 79999 eq 60000)
    /
    (80000 thru 100000 eq 80000)
    /
  S0294104
    (1 thru 5 eq 1)
    /
    (0 thru 0 eq 0)
    /
  S1541700
    (-999999 thru -3000 eq -999999)
    /
    (-2999 thru -2000 eq -2999)
    /
    (-1999 thru -1000 eq -1999)
    /
    (-999 thru -1 eq -999)
    /
    (0 thru 0 eq 0)
    /
    (1 thru 1000 eq 1)
    /
    (1001 thru 2000 eq 1001)
    /
    (2001 thru 3000 eq 2001)
    /
    (3001 thru 5000 eq 3001)
    /
    (5001 thru 10000 eq 5001)
    /
    (10001 thru 20000 eq 10001)
    /
    (20001 thru 30000 eq 20001)
    /
    (30001 thru 40000 eq 30001)
    /
    (40001 thru 50000 eq 40001)
    /
    (50001 thru 65000 eq 50001)
    /
    (65001 thru 80000 eq 65001)
    /
    (80001 thru 100000 eq 80001)
    /
    (100001 thru 150000 eq 100001)
    /
    (150001 thru 200000 eq 150001)
    /
    (200001 thru 999999 eq 200001)
    /
  S1541800
    (-999999 thru -3000 eq -999999)
    /
    (-2999 thru -2000 eq -2999)
    /
    (-1999 thru -1000 eq -1999)
    /
    (-999 thru -1 eq -999)
    /
    (0 thru 0 eq 0)
    /
    (1 thru 1000 eq 1)
    /
    (1001 thru 2000 eq 1001)
    /
    (2001 thru 3000 eq 2001)
    /
    (3001 thru 5000 eq 3001)
    /
    (5001 thru 10000 eq 5001)
    /
    (10001 thru 20000 eq 10001)
    /
    (20001 thru 30000 eq 20001)
    /
    (30001 thru 40000 eq 30001)
    /
    (40001 thru 50000 eq 40001)
    /
    (50001 thru 65000 eq 50001)
    /
    (65001 thru 80000 eq 65001)
    /
    (80001 thru 100000 eq 80001)
    /
    (100001 thru 150000 eq 100001)
    /
    (150001 thru 200000 eq 150001)
    /
    (200001 thru 999999999 eq 200001)
    /
  S1541900
    (0 thru 0 eq 0)
    /
    (1 thru 99 eq 1)
    /
    (100 thru 199 eq 100)
    /
    (200 thru 299 eq 200)
    /
    (300 thru 399 eq 300)
    /
    (400 thru 499 eq 400)
    /
    (500 thru 599 eq 500)
    /
    (600 thru 699 eq 600)
    /
    (700 thru 799 eq 700)
    /
    (800 thru 899 eq 800)
    /
    (900 thru 999 eq 900)
    /
    (1000 thru 1099 eq 1000)
    /
    (1100 thru 1199 eq 1100)
    /
    (1200 thru 1299 eq 1200)
    /
    (1300 thru 1399 eq 1300)
    /
    (1400 thru 1499 eq 1400)
    /
    (1500 thru 1599 eq 1500)
    /
    (1600 thru 1699 eq 1600)
    /
    (1700 thru 1799 eq 1700)
    /
    (1800 thru 1899 eq 1800)
    /
    (1900 thru 1999 eq 1900)
    /
    (2000 thru 2999 eq 2000)
    /
    (3000 thru 9999 eq 3000)
    /
  S1542100
    (0 thru 0 eq 0)
    /
    (1 thru 1 eq 1)
    /
    (2 thru 2 eq 2)
    /
    (3 thru 3 eq 3)
    /
    (4 thru 4 eq 4)
    /
    (5 thru 5 eq 5)
    /
    (6 thru 6 eq 6)
    /
    (7 thru 7 eq 7)
    /
    (8 thru 8 eq 8)
    /
    (9 thru 9 eq 9)
    /
    (10 thru 10 eq 10)
    /
    (11 thru 11 eq 11)
    /
    (12 thru 12 eq 12)
    /
    (13 thru 13 eq 13)
    /
    (14 thru 14 eq 14)
    /
    (15 thru 15 eq 15)
    /
    (16 thru 16 eq 16)
    /
    (17 thru 17 eq 17)
    /
    (18 thru 18 eq 18)
    /
    (19 thru 19 eq 19)
    /
    (20 thru 99 eq 20)
    /
  S2011500
    (-999999 thru -3000 eq -999999)
    /
    (-2999 thru -2000 eq -2999)
    /
    (-1999 thru -1000 eq -1999)
    /
    (-999 thru -1 eq -999)
    /
    (0 thru 0 eq 0)
    /
    (1 thru 1000 eq 1)
    /
    (1001 thru 2000 eq 1001)
    /
    (2001 thru 3000 eq 2001)
    /
    (3001 thru 5000 eq 3001)
    /
    (5001 thru 10000 eq 5001)
    /
    (10001 thru 20000 eq 10001)
    /
    (20001 thru 30000 eq 20001)
    /
    (30001 thru 40000 eq 30001)
    /
    (40001 thru 50000 eq 40001)
    /
    (50001 thru 65000 eq 50001)
    /
    (65001 thru 80000 eq 65001)
    /
    (80001 thru 100000 eq 80001)
    /
    (100001 thru 150000 eq 100001)
    /
    (150001 thru 200000 eq 150001)
    /
    (200001 thru 999999 eq 200001)
    /
  S2011600
    (-999999 thru -3000 eq -999999)
    /
    (-2999 thru -2000 eq -2999)
    /
    (-1999 thru -1000 eq -1999)
    /
    (-999 thru -1 eq -999)
    /
    (0 thru 0 eq 0)
    /
    (1 thru 1000 eq 1)
    /
    (1001 thru 2000 eq 1001)
    /
    (2001 thru 3000 eq 2001)
    /
    (3001 thru 5000 eq 3001)
    /
    (5001 thru 10000 eq 5001)
    /
    (10001 thru 20000 eq 10001)
    /
    (20001 thru 30000 eq 20001)
    /
    (30001 thru 40000 eq 30001)
    /
    (40001 thru 50000 eq 40001)
    /
    (50001 thru 65000 eq 50001)
    /
    (65001 thru 80000 eq 65001)
    /
    (80001 thru 100000 eq 80001)
    /
    (100001 thru 150000 eq 100001)
    /
    (150001 thru 200000 eq 150001)
    /
    (200001 thru 999999999 eq 200001)
    /
  S2011700
    (0 thru 0 eq 0)
    /
    (1 thru 99 eq 1)
    /
    (100 thru 199 eq 100)
    /
    (200 thru 299 eq 200)
    /
    (300 thru 399 eq 300)
    /
    (400 thru 499 eq 400)
    /
    (500 thru 599 eq 500)
    /
    (600 thru 699 eq 600)
    /
    (700 thru 799 eq 700)
    /
    (800 thru 899 eq 800)
    /
    (900 thru 999 eq 900)
    /
    (1000 thru 1099 eq 1000)
    /
    (1100 thru 1199 eq 1100)
    /
    (1200 thru 1299 eq 1200)
    /
    (1300 thru 1399 eq 1300)
    /
    (1400 thru 1499 eq 1400)
    /
    (1500 thru 1599 eq 1500)
    /
    (1600 thru 1699 eq 1600)
    /
    (1700 thru 1799 eq 1700)
    /
    (1800 thru 1899 eq 1800)
    /
    (1900 thru 1999 eq 1900)
    /
    (2000 thru 2999 eq 2000)
    /
    (3000 thru 9999 eq 3000)
    /
  S2011900
    (0 thru 0 eq 0)
    /
    (1 thru 1 eq 1)
    /
    (2 thru 2 eq 2)
    /
    (3 thru 3 eq 3)
    /
    (4 thru 4 eq 4)
    /
    (5 thru 5 eq 5)
    /
    (6 thru 6 eq 6)
    /
    (7 thru 7 eq 7)
    /
    (8 thru 8 eq 8)
    /
    (9 thru 9 eq 9)
    /
    (10 thru 10 eq 10)
    /
    (11 thru 11 eq 11)
    /
    (12 thru 12 eq 12)
    /
    (13 thru 13 eq 13)
    /
    (14 thru 14 eq 14)
    /
    (15 thru 15 eq 15)
    /
    (16 thru 16 eq 16)
    /
    (17 thru 17 eq 17)
    /
    (18 thru 18 eq 18)
    /
    (19 thru 19 eq 19)
    /
    (20 thru 99 eq 20)
    /
  S2332904
    (1 thru 5 eq 1)
    /
    (0 thru 0 eq 0)
    /
  S3812400
    (-999999 thru -3000 eq -999999)
    /
    (-2999 thru -2000 eq -2999)
    /
    (-1999 thru -1000 eq -1999)
    /
    (-999 thru -1 eq -999)
    /
    (0 thru 0 eq 0)
    /
    (1 thru 1000 eq 1)
    /
    (1001 thru 2000 eq 1001)
    /
    (2001 thru 3000 eq 2001)
    /
    (3001 thru 5000 eq 3001)
    /
    (5001 thru 10000 eq 5001)
    /
    (10001 thru 20000 eq 10001)
    /
    (20001 thru 30000 eq 20001)
    /
    (30001 thru 40000 eq 30001)
    /
    (40001 thru 50000 eq 40001)
    /
    (50001 thru 65000 eq 50001)
    /
    (65001 thru 80000 eq 65001)
    /
    (80001 thru 100000 eq 80001)
    /
    (100001 thru 150000 eq 100001)
    /
    (150001 thru 200000 eq 150001)
    /
    (200001 thru 999999 eq 200001)
    /
  S3812500
    (0 thru 0 eq 0)
    /
    (1 thru 99 eq 1)
    /
    (100 thru 199 eq 100)
    /
    (200 thru 299 eq 200)
    /
    (300 thru 399 eq 300)
    /
    (400 thru 499 eq 400)
    /
    (500 thru 599 eq 500)
    /
    (600 thru 699 eq 600)
    /
    (700 thru 799 eq 700)
    /
    (800 thru 899 eq 800)
    /
    (900 thru 999 eq 900)
    /
    (1000 thru 1099 eq 1000)
    /
    (1100 thru 1199 eq 1100)
    /
    (1200 thru 1299 eq 1200)
    /
    (1300 thru 1399 eq 1300)
    /
    (1400 thru 1499 eq 1400)
    /
    (1500 thru 1599 eq 1500)
    /
    (1600 thru 1699 eq 1600)
    /
    (1700 thru 1799 eq 1700)
    /
    (1800 thru 1899 eq 1800)
    /
    (1900 thru 1999 eq 1900)
    /
    (2000 thru 2999 eq 2000)
    /
    (3000 thru 9999 eq 3000)
    /
  S3813400
    (0 thru 0 eq 0)
    /
    (1 thru 1 eq 1)
    /
    (2 thru 2 eq 2)
    /
    (3 thru 3 eq 3)
    /
    (4 thru 4 eq 4)
    /
    (5 thru 5 eq 5)
    /
    (6 thru 6 eq 6)
    /
    (7 thru 7 eq 7)
    /
    (8 thru 8 eq 8)
    /
    (9 thru 9 eq 9)
    /
    (10 thru 10 eq 10)
    /
    (11 thru 11 eq 11)
    /
    (12 thru 12 eq 12)
    /
    (13 thru 13 eq 13)
    /
    (14 thru 14 eq 14)
    /
    (15 thru 15 eq 15)
    /
    (16 thru 16 eq 16)
    /
    (17 thru 17 eq 17)
    /
    (18 thru 18 eq 18)
    /
    (19 thru 19 eq 19)
    /
    (20 thru 99 eq 20)
    /
  S4104604
    (1 thru 5 eq 1)
    /
    (0 thru 0 eq 0)
    /
  S5412800
    (-999999 thru -3000 eq -999999)
    /
    (-2999 thru -2000 eq -2999)
    /
    (-1999 thru -1000 eq -1999)
    /
    (-999 thru -1 eq -999)
    /
    (0 thru 0 eq 0)
    /
    (1 thru 1000 eq 1)
    /
    (1001 thru 2000 eq 1001)
    /
    (2001 thru 3000 eq 2001)
    /
    (3001 thru 5000 eq 3001)
    /
    (5001 thru 10000 eq 5001)
    /
    (10001 thru 20000 eq 10001)
    /
    (20001 thru 30000 eq 20001)
    /
    (30001 thru 40000 eq 30001)
    /
    (40001 thru 50000 eq 40001)
    /
    (50001 thru 65000 eq 50001)
    /
    (65001 thru 80000 eq 65001)
    /
    (80001 thru 100000 eq 80001)
    /
    (100001 thru 150000 eq 100001)
    /
    (150001 thru 200000 eq 150001)
    /
    (200001 thru 999999 eq 200001)
    /
  S5412900
    (0 thru 0 eq 0)
    /
    (1 thru 99 eq 1)
    /
    (100 thru 199 eq 100)
    /
    (200 thru 299 eq 200)
    /
    (300 thru 399 eq 300)
    /
    (400 thru 499 eq 400)
    /
    (500 thru 599 eq 500)
    /
    (600 thru 699 eq 600)
    /
    (700 thru 799 eq 700)
    /
    (800 thru 899 eq 800)
    /
    (900 thru 999 eq 900)
    /
    (1000 thru 1099 eq 1000)
    /
    (1100 thru 1199 eq 1100)
    /
    (1200 thru 1299 eq 1200)
    /
    (1300 thru 1399 eq 1300)
    /
    (1400 thru 1499 eq 1400)
    /
    (1500 thru 1599 eq 1500)
    /
    (1600 thru 1699 eq 1600)
    /
    (1700 thru 1799 eq 1700)
    /
    (1800 thru 1899 eq 1800)
    /
    (1900 thru 1999 eq 1900)
    /
    (2000 thru 2999 eq 2000)
    /
    (3000 thru 9999 eq 3000)
    /
  S5413000
    (0 thru 0 eq 0)
    /
    (1 thru 1 eq 1)
    /
    (2 thru 2 eq 2)
    /
    (3 thru 3 eq 3)
    /
    (4 thru 4 eq 4)
    /
    (5 thru 5 eq 5)
    /
    (6 thru 6 eq 6)
    /
    (7 thru 7 eq 7)
    /
    (8 thru 8 eq 8)
    /
    (9 thru 9 eq 9)
    /
    (10 thru 10 eq 10)
    /
    (11 thru 11 eq 11)
    /
    (12 thru 12 eq 12)
    /
    (13 thru 13 eq 13)
    /
    (14 thru 14 eq 14)
    /
    (15 thru 15 eq 15)
    /
    (16 thru 16 eq 16)
    /
    (17 thru 17 eq 17)
    /
    (18 thru 18 eq 18)
    /
    (19 thru 19 eq 19)
    /
    (20 thru 99 eq 20)
    /
  S5664704
    (1 thru 5 eq 1)
    /
    (0 thru 0 eq 0)
    /
  S7513700
    (-999999 thru -3000 eq -999999)
    /
    (-2999 thru -2000 eq -2999)
    /
    (-1999 thru -1000 eq -1999)
    /
    (-999 thru -1 eq -999)
    /
    (0 thru 0 eq 0)
    /
    (1 thru 1000 eq 1)
    /
    (1001 thru 2000 eq 1001)
    /
    (2001 thru 3000 eq 2001)
    /
    (3001 thru 5000 eq 3001)
    /
    (5001 thru 10000 eq 5001)
    /
    (10001 thru 20000 eq 10001)
    /
    (20001 thru 30000 eq 20001)
    /
    (30001 thru 40000 eq 30001)
    /
    (40001 thru 50000 eq 40001)
    /
    (50001 thru 65000 eq 50001)
    /
    (65001 thru 80000 eq 65001)
    /
    (80001 thru 100000 eq 80001)
    /
    (100001 thru 150000 eq 100001)
    /
    (150001 thru 200000 eq 150001)
    /
    (200001 thru 999999 eq 200001)
    /
  S7513800
    (0 thru 0 eq 0)
    /
    (1 thru 99 eq 1)
    /
    (100 thru 199 eq 100)
    /
    (200 thru 299 eq 200)
    /
    (300 thru 399 eq 300)
    /
    (400 thru 499 eq 400)
    /
    (500 thru 599 eq 500)
    /
    (600 thru 699 eq 600)
    /
    (700 thru 799 eq 700)
    /
    (800 thru 899 eq 800)
    /
    (900 thru 999 eq 900)
    /
    (1000 thru 1099 eq 1000)
    /
    (1100 thru 1199 eq 1100)
    /
    (1200 thru 1299 eq 1200)
    /
    (1300 thru 1399 eq 1300)
    /
    (1400 thru 1499 eq 1400)
    /
    (1500 thru 1599 eq 1500)
    /
    (1600 thru 1699 eq 1600)
    /
    (1700 thru 1799 eq 1700)
    /
    (1800 thru 1899 eq 1800)
    /
    (1900 thru 1999 eq 1900)
    /
    (2000 thru 2999 eq 2000)
    /
    (3000 thru 9999 eq 3000)
    /
  S7513900
    (0 thru 0 eq 0)
    /
    (1 thru 1 eq 1)
    /
    (2 thru 2 eq 2)
    /
    (3 thru 3 eq 3)
    /
    (4 thru 4 eq 4)
    /
    (5 thru 5 eq 5)
    /
    (6 thru 6 eq 6)
    /
    (7 thru 7 eq 7)
    /
    (8 thru 8 eq 8)
    /
    (9 thru 9 eq 9)
    /
    (10 thru 10 eq 10)
    /
    (11 thru 11 eq 11)
    /
    (12 thru 12 eq 12)
    /
    (13 thru 13 eq 13)
    /
    (14 thru 14 eq 14)
    /
    (15 thru 15 eq 15)
    /
    (16 thru 16 eq 16)
    /
    (17 thru 17 eq 17)
    /
    (18 thru 18 eq 18)
    /
    (19 thru 19 eq 19)
    /
    (20 thru 99 eq 20)
    /
  S7740704
    (1 thru 5 eq 1)
    /
    (0 thru 0 eq 0)
    /
  Z9049700
    (-9999999 thru -3000 eq -9999999)
    /
    (-2999 thru -2000 eq -2999)
    /
    (-1999 thru -1000 eq -1999)
    /
    (-999 thru -1 eq -999)
    /
    (0 thru 0 eq 0)
    /
    (1 thru 1000 eq 1)
    /
    (1001 thru 2000 eq 1001)
    /
    (2001 thru 3000 eq 2001)
    /
    (3001 thru 5000 eq 3001)
    /
    (5001 thru 10000 eq 5001)
    /
    (10001 thru 20000 eq 10001)
    /
    (20001 thru 30000 eq 20001)
    /
    (30001 thru 40000 eq 30001)
    /
    (40001 thru 50000 eq 40001)
    /
    (50001 thru 65000 eq 50001)
    /
    (65001 thru 80000 eq 65001)
    /
    (80001 thru 100000 eq 80001)
    /
    (100001 thru 150000 eq 100001)
    /
    (150001 thru 200000 eq 150001)
    /
    (200001 thru 999999999 eq 200001)
    /
  Z9050100
    (-9999999 thru -3000 eq -9999999)
    (-2999 thru -2000 eq -2999)
    (-1999 thru -1000 eq -1999)
    (-999 thru -1 eq -999)
    (0 thru 0 eq 0)
    (1 thru 1000 eq 1)
    (1001 thru 2000 eq 1001)
    (2001 thru 3000 eq 2001)
    (3001 thru 5000 eq 3001)
    (5001 thru 10000 eq 5001)
    (10001 thru 20000 eq 10001)
    (20001 thru 30000 eq 20001)
    (30001 thru 40000 eq 30001)
    (40001 thru 50000 eq 40001)
    (50001 thru 65000 eq 50001)
    (65001 thru 80000 eq 65001)
    (80001 thru 100000 eq 80001)
    (100001 thru 150000 eq 100001)
    (150001 thru 200000 eq 150001)
    (200001 thru 999999999 eq 200001)
.

* value labels
 R0000100
    0 "0"
    1 "1 TO 999"
    1000 "1000 TO 1999"
    2000 "2000 TO 2999"
    3000 "3000 TO 3999"
    4000 "4000 TO 4999"
    5000 "5000 TO 5999"
    6000 "6000 TO 6999"
    7000 "7000 TO 7999"
    8000 "8000 TO 8999"
    9000 "9000 TO 9999"
    /
 R0041603
    1 "Computer Science (A,AB)"
    0 "NOT SELECTED"
    /
 R0507500
    1 "YES"
    0 "NO"
    /
 R0507600
    0 "0"
    1 "1 TO 4999"
    5000 "5000 TO 9999"
    10000 "10000 TO 14999"
    15000 "15000 TO 19999"
    20000 "20000 TO 24999"
    25000 "25000 TO 29999"
    30000 "30000 TO 39999"
    40000 "40000 TO 49999"
    50000 "50000 TO 59999"
    60000 "60000 TO 69999"
    70000 "70000 TO 79999"
    80000 "80000 TO 89999"
    90000 "90000 TO 99999"
    100000 "100000 TO 149999"
    150000 "150000 TO 99999999: 150000+"
    /
 R0507700
    1 "A. $1              -        $1,000"
    2 "B.  $1,001      -       $2,500"
    3 "C.  $2,501      -       $5,000"
    4 "D.  $5,001      -     $10,000"
    5 "E.   $10,001    -     $25,000"
    6 "F.   $25,001    -     $50,000"
    7 "G.   More than   $50,000"
    /
 R0536300
    1 "Male"
    2 "Female"
    0 "No Information"
    /
 R0536401
    1 "1: January"
    2 "2: February"
    3 "3: March"
    4 "4: April"
    5 "5: May"
    6 "6: June"
    7 "7: July"
    8 "8: August"
    9 "9: September"
    10 "10: October"
    11 "11: November"
    12 "12: December"
    /
 R1200300
    1 "Northeast (CT, ME, MA, NH, NJ, NY, PA, RI, VT)"
    2 "North Central (IL, IN, IA, KS, MI, MN, MO, NE, OH, ND, SD, WI)"
    3 "South (AL, AR, DE, DC, FL, GA, KY, LA, MD, MS, NC, OK, SC, TN , TX, VA, WV)"
    4 "West (AK, AZ, CA, CO, HI, ID, MT, NV, NM, OR, UT, WA, WY)"
    /
 R1204500
    -999999 "-999999 TO -3000: < -2999"
    -2999 "-2999 TO -2000"
    -1999 "-1999 TO -1000"
    -999 "-999 TO -1"
    0 "0"
    1 "1 TO 1000"
    1001 "1001 TO 2000"
    2001 "2001 TO 3000"
    3001 "3001 TO 5000"
    5001 "5001 TO 10000"
    10001 "10001 TO 20000"
    20001 "20001 TO 30000"
    30001 "30001 TO 40000"
    40001 "40001 TO 50000"
    50001 "50001 TO 65000"
    65001 "65001 TO 80000"
    80001 "80001 TO 100000"
    100001 "100001 TO 150000"
    150001 "150001 TO 200000"
    200001 "200001 TO 999999: 200001+"
    /
 R1204700
    -999999 "-999999 TO -3000: < -2999"
    -2999 "-2999 TO -2000"
    -1999 "-1999 TO -1000"
    -999 "-999 TO -6"
    0 "0"
    1 "1 TO 1000"
    1001 "1001 TO 2000"
    2001 "2001 TO 3000"
    3001 "3001 TO 5000"
    5001 "5001 TO 10000"
    10001 "10001 TO 20000"
    20001 "20001 TO 30000"
    30001 "30001 TO 40000"
    40001 "40001 TO 50000"
    50001 "50001 TO 65000"
    65001 "65001 TO 80000"
    80001 "80001 TO 100000"
    100001 "100001 TO 150000"
    150001 "150001 TO 200000"
    200001 "200001 TO 500000"
    500001 "500001 TO 1000000"
    1000001 "1000001 TO 1500000"
    1500001 "1500001 TO 2000000"
    2000001 "2000001 TO 999999999: 2000001+"
    /
 R1204800
    -999999 "-999999 TO -3000: < -2999"
    -2999 "-2999 TO -2000"
    -1999 "-1999 TO -1000"
    -999 "-999 TO -6"
    0 "0"
    1 "1 TO 1000"
    1001 "1001 TO 2000"
    2001 "2001 TO 3000"
    3001 "3001 TO 5000"
    5001 "5001 TO 10000"
    10001 "10001 TO 20000"
    20001 "20001 TO 30000"
    30001 "30001 TO 40000"
    40001 "40001 TO 50000"
    50001 "50001 TO 65000"
    65001 "65001 TO 80000"
    80001 "80001 TO 100000"
    100001 "100001 TO 150000"
    150001 "150001 TO 200000"
    200001 "200001 TO 500000"
    500001 "500001 TO 1000000"
    1000001 "1000001 TO 1500000"
    1500001 "1500001 TO 2000000"
    2000001 "2000001 TO 999999999: 2000001+"
    /
 R1204900
    0 "0"
    1 "1 TO 99: .01-.99"
    100 "100 TO 199: 1.00-1.99"
    200 "200 TO 299: 2.00-2.99"
    300 "300 TO 399: 3.00-3.99"
    400 "400 TO 499: 4.00-4.99"
    500 "500 TO 599: 5.00-5.99"
    600 "600 TO 699: 6.00-6.99"
    700 "700 TO 799: 7.00-7.99"
    800 "800 TO 899: 8.00-8.99"
    900 "900 TO 999: 9.00-9.99"
    1000 "1000 TO 1099: 10.00-10.99"
    1100 "1100 TO 1199: 11.00-11.99"
    1200 "1200 TO 1299: 12.00-12.99"
    1300 "1300 TO 1399: 13.00-13.99"
    1400 "1400 TO 1499: 14.00-14.99"
    1500 "1500 TO 1599: 15.00-15.99"
    1600 "1600 TO 1699: 16.00-16.99"
    1700 "1700 TO 1799: 17.00-17.99"
    1800 "1800 TO 1899: 18.00-18.99"
    1900 "1900 TO 1999: 19.00-19.99"
    2000 "2000 TO 2999: 20.00-29.99"
    3000 "3000 TO 9999: 30.00+"
    /
 R1205400
    0 "0"
    1 "1"
    2 "2"
    3 "3"
    4 "4"
    5 "5"
    6 "6"
    7 "7"
    8 "8"
    9 "9"
    10 "10"
    11 "11"
    12 "12"
    13 "13"
    14 "14"
    15 "15"
    16 "16"
    17 "17"
    18 "18"
    19 "19"
    20 "20 TO 99: 20+"
    /
 R1217500
    0 "Rural"
    1 "Urban"
    2 "Unknown"
    /
 R1235800
    1 "Cross-sectional"
    0 "Oversample"
    /
 R1482600
    1 "Black"
    2 "Hispanic"
    3 "Mixed Race (Non-Hispanic)"
    4 "Non-Black / Non-Hispanic"
    /
 R1704004
    1 "Economics (Microeconomics, Macroeconomics)"
    0 "NOT SELECTED"
    /
 R2370600
    1 "YES, RESPONDENT HAS OWN ACCOUNT"
    2 "YES, RESPONDENT HAS OWN ACCOUNTS AND ACCOUNTS JOINTLY WITH SPOUSE/PARTNER"
    3 "YES, RESPONDENT ONLY HAS ACCOUNTS JOINTLY WITH SPOUSE/PARTNER"
    4 "YES, SPOUSE/PARTNER HAS ACCOUNTS SEPARATELY FROM RESPONDENT"
    0 "NO"
    /
 R2370700
    1 "SELECT TO ENTER AMOUNT"
    2 "SELECT TO ENTER RANGE"
    /
 R2370900
    1 "A. $1              -        $1,000"
    2 "B.  $1,001      -       $2,500"
    3 "C.  $2,501      -       $5,000"
    4 "D.  $5,001      -     $10,000"
    5 "E.   $10,001    -     $25,000"
    6 "F.   $25,001    -     $50,000"
    7 "G.   More than   $50,000"
    /
 R2558800
    1 "Northeast (CT, ME, MA, NH, NJ, NY, PA, RI, VT)"
    2 "North Central (IL, IN, IA, KS, MI, MN, MO, NE, OH, ND, SD, WI)"
    3 "South (AL, AR, DE, DC, FL, GA, KY, LA, MD, MS, NC, OK, SC, TN , TX, VA, WV)"
    4 "West (AK, AZ, CA, CO, HI, ID, MT, NV, NM, OR, UT, WA, WY)"
    /
 R2563201
    0 "NONE"
    1 "1ST GRADE"
    2 "2ND GRADE"
    3 "3RD GRADE"
    4 "4TH GRADE"
    5 "5TH GRADE"
    6 "6TH GRADE"
    7 "7TH GRADE"
    8 "8TH GRADE"
    9 "9TH GRADE"
    10 "10TH GRADE"
    11 "11TH GRADE"
    12 "12TH GRADE"
    95 "UNGRADED"
    /
 R2563300
    -999999 "-999999 TO -3000: < -2999"
    -2999 "-2999 TO -2000"
    -1999 "-1999 TO -1000"
    -999 "-999 TO -1"
    0 "0"
    1 "1 TO 1000"
    1001 "1001 TO 2000"
    2001 "2001 TO 3000"
    3001 "3001 TO 5000"
    5001 "5001 TO 10000"
    10001 "10001 TO 20000"
    20001 "20001 TO 30000"
    30001 "30001 TO 40000"
    40001 "40001 TO 50000"
    50001 "50001 TO 65000"
    65001 "65001 TO 80000"
    80001 "80001 TO 100000"
    100001 "100001 TO 150000"
    150001 "150001 TO 200000"
    200001 "200001 TO 999999: 200001+"
    /
 R2563400
    -999999 "-999999 TO -3000: < -2999"
    -2999 "-2999 TO -2000"
    -1999 "-1999 TO -1000"
    -999 "-999 TO -1"
    0 "0"
    1 "1 TO 1000"
    1001 "1001 TO 2000"
    2001 "2001 TO 3000"
    3001 "3001 TO 5000"
    5001 "5001 TO 10000"
    10001 "10001 TO 20000"
    20001 "20001 TO 30000"
    30001 "30001 TO 40000"
    40001 "40001 TO 50000"
    50001 "50001 TO 65000"
    65001 "65001 TO 80000"
    80001 "80001 TO 100000"
    100001 "100001 TO 150000"
    150001 "150001 TO 200000"
    200001 "200001 TO 999999999: 200001+"
    /
 R2563500
    0 "0"
    1 "1 TO 99: .01-.99"
    100 "100 TO 199: 1.00-1.99"
    200 "200 TO 299: 2.00-2.99"
    300 "300 TO 399: 3.00-3.99"
    400 "400 TO 499: 4.00-4.99"
    500 "500 TO 599: 5.00-5.99"
    600 "600 TO 699: 6.00-6.99"
    700 "700 TO 799: 7.00-7.99"
    800 "800 TO 899: 8.00-8.99"
    900 "900 TO 999: 9.00-9.99"
    1000 "1000 TO 1099: 10.00-10.99"
    1100 "1100 TO 1199: 11.00-11.99"
    1200 "1200 TO 1299: 12.00-12.99"
    1300 "1300 TO 1399: 13.00-13.99"
    1400 "1400 TO 1499: 14.00-14.99"
    1500 "1500 TO 1599: 15.00-15.99"
    1600 "1600 TO 1699: 16.00-16.99"
    1700 "1700 TO 1799: 17.00-17.99"
    1800 "1800 TO 1899: 18.00-18.99"
    1900 "1900 TO 1999: 19.00-19.99"
    2000 "2000 TO 2999: 20.00-29.99"
    3000 "3000 TO 9999: 30.00+"
    /
 R2563700
    0 "0"
    1 "1"
    2 "2"
    3 "3"
    4 "4"
    5 "5"
    6 "6"
    7 "7"
    8 "8"
    9 "9"
    10 "10"
    11 "11"
    12 "12"
    13 "13"
    14 "14"
    15 "15"
    16 "16"
    17 "17"
    18 "18"
    19 "19"
    20 "20 TO 99: 20+"
    /
 R2576800
    0 "Rural"
    1 "Urban"
    2 "Unknown"
    /
 R2996504
    1 "Economics (Microeconomics, Macroeconomics)"
    0 "NOT SELECTED"
    /
 R3678300
    1 "YES, RESPONDENT HAS OWN ACCOUNT"
    2 "YES, RESPONDENT HAS OWN ACCOUNTS AND ACCOUNTS JOINTLY WITH SPOUSE/PARTNER"
    3 "YES, RESPONDENT ONLY HAS ACCOUNTS JOINTLY WITH SPOUSE/PARTNER"
    4 "YES, SPOUSE/PARTNER HAS ACCOUNTS SEPARATELY FROM RESPONDENT"
    0 "NO"
    /
 R3678400
    1 "SELECT TO ENTER AMOUNT"
    2 "SELECT TO ENTER RANGE"
    /
 R3678600
    1 "A. $1              -        $1,000"
    2 "B.  $1,001      -       $2,500"
    3 "C.  $2,501      -       $5,000"
    4 "D.  $5,001      -     $10,000"
    5 "E.   $10,001    -     $25,000"
    6 "F.   $25,001    -     $50,000"
    7 "G.   More than   $50,000"
    /
 R3880300
    1 "Northeast (CT, ME, MA, NH, NJ, NY, PA, RI, VT)"
    2 "North Central (IL, IN, IA, KS, MI, MN, MO, NE, OH, ND, SD, WI)"
    3 "South (AL, AR, DE, DC, FL, GA, KY, LA, MD, MS, NC, OK, SC, TN , TX, VA, WV)"
    4 "West (AK, AZ, CA, CO, HI, ID, MT, NV, NM, OR, UT, WA, WY)"
    /
 R3884801
    0 "NONE"
    1 "1ST GRADE"
    2 "2ND GRADE"
    3 "3RD GRADE"
    4 "4TH GRADE"
    5 "5TH GRADE"
    6 "6TH GRADE"
    7 "7TH GRADE"
    8 "8TH GRADE"
    9 "9TH GRADE"
    10 "10TH GRADE"
    11 "11TH GRADE"
    12 "12TH GRADE"
    95 "UNGRADED"
    /
 R3884900
    -999999 "-999999 TO -3000: < -2999"
    -2999 "-2999 TO -2000"
    -1999 "-1999 TO -1000"
    -999 "-999 TO -1"
    0 "0"
    1 "1 TO 1000"
    1001 "1001 TO 2000"
    2001 "2001 TO 3000"
    3001 "3001 TO 5000"
    5001 "5001 TO 10000"
    10001 "10001 TO 20000"
    20001 "20001 TO 30000"
    30001 "30001 TO 40000"
    40001 "40001 TO 50000"
    50001 "50001 TO 65000"
    65001 "65001 TO 80000"
    80001 "80001 TO 100000"
    100001 "100001 TO 150000"
    150001 "150001 TO 200000"
    200001 "200001 TO 999999: 200001+"
    /
 R3885000
    -999999 "-999999 TO -3000: < -2999"
    -2999 "-2999 TO -2000"
    -1999 "-1999 TO -1000"
    -999 "-999 TO -1"
    0 "0"
    1 "1 TO 1000"
    1001 "1001 TO 2000"
    2001 "2001 TO 3000"
    3001 "3001 TO 5000"
    5001 "5001 TO 10000"
    10001 "10001 TO 20000"
    20001 "20001 TO 30000"
    30001 "30001 TO 40000"
    40001 "40001 TO 50000"
    50001 "50001 TO 65000"
    65001 "65001 TO 80000"
    80001 "80001 TO 100000"
    100001 "100001 TO 150000"
    150001 "150001 TO 200000"
    200001 "200001 TO 999999999: 200001+"
    /
 R3885100
    0 "0"
    1 "1 TO 99: .01-.99"
    100 "100 TO 199: 1.00-1.99"
    200 "200 TO 299: 2.00-2.99"
    300 "300 TO 399: 3.00-3.99"
    400 "400 TO 499: 4.00-4.99"
    500 "500 TO 599: 5.00-5.99"
    600 "600 TO 699: 6.00-6.99"
    700 "700 TO 799: 7.00-7.99"
    800 "800 TO 899: 8.00-8.99"
    900 "900 TO 999: 9.00-9.99"
    1000 "1000 TO 1099: 10.00-10.99"
    1100 "1100 TO 1199: 11.00-11.99"
    1200 "1200 TO 1299: 12.00-12.99"
    1300 "1300 TO 1399: 13.00-13.99"
    1400 "1400 TO 1499: 14.00-14.99"
    1500 "1500 TO 1599: 15.00-15.99"
    1600 "1600 TO 1699: 16.00-16.99"
    1700 "1700 TO 1799: 17.00-17.99"
    1800 "1800 TO 1899: 18.00-18.99"
    1900 "1900 TO 1999: 19.00-19.99"
    2000 "2000 TO 2999: 20.00-29.99"
    3000 "3000 TO 9999: 30.00+"
    /
 R3885300
    0 "0"
    1 "1"
    2 "2"
    3 "3"
    4 "4"
    5 "5"
    6 "6"
    7 "7"
    8 "8"
    9 "9"
    10 "10"
    11 "11"
    12 "12"
    13 "13"
    14 "14"
    15 "15"
    16 "16"
    17 "17"
    18 "18"
    19 "19"
    20 "20 TO 99: 20+"
    /
 R3899100
    0 "Rural"
    1 "Urban"
    2 "Unknown"
    /
 R4262104
    1 "Economics (Microeconomics, Macroeconomics)"
    0 "NOT SELECTED"
    /
 R5128600
    1 "YES, RESPONDENT HAS OWN ACCOUNT"
    2 "YES, RESPONDENT HAS OWN ACCOUNTS AND ACCOUNTS JOINTLY WITH SPOUSE/PARTNER"
    3 "YES, RESPONDENT ONLY HAS ACCOUNTS JOINTLY WITH SPOUSE/PARTNER"
    4 "YES, SPOUSE/PARTNER HAS ACCOUNTS SEPARATELY FROM RESPONDENT"
    0 "NO"
    /
 R5128700
    1 "SELECT TO ENTER AMOUNT"
    2 "SELECT TO ENTER RANGE"
    /
 R5128900
    1 "A. $1              -        $1,000"
    2 "B.  $1,001      -       $2,500"
    3 "C.  $2,501      -       $5,000"
    4 "D.  $5,001      -     $10,000"
    5 "E.   $10,001    -     $25,000"
    6 "F.   $25,001    -     $50,000"
    7 "G.   More than   $50,000"
    /
 R5459400
    1 "Northeast (CT, ME, MA, NH, NJ, NY, PA, RI, VT)"
    2 "North Central (IL, IN, IA, KS, MI, MN, MO, NE, OH, ND, SD, WI)"
    3 "South (AL, AR, DE, DC, FL, GA, KY, LA, MD, MS, NC, OK, SC, TN , TX, VA, WV)"
    4 "West (AK, AZ, CA, CO, HI, ID, MT, NV, NM, OR, UT, WA, WY)"
    /
 R5464001
    0 "NONE"
    1 "1ST GRADE"
    2 "2ND GRADE"
    3 "3RD GRADE"
    4 "4TH GRADE"
    5 "5TH GRADE"
    6 "6TH GRADE"
    7 "7TH GRADE"
    8 "8TH GRADE"
    9 "9TH GRADE"
    10 "10TH GRADE"
    11 "11TH GRADE"
    12 "12TH GRADE"
    95 "UNGRADED"
    /
 R5464100
    -999999 "-999999 TO -3000: < -2999"
    -2999 "-2999 TO -2000"
    -1999 "-1999 TO -1000"
    -999 "-999 TO -1"
    0 "0"
    1 "1 TO 1000"
    1001 "1001 TO 2000"
    2001 "2001 TO 3000"
    3001 "3001 TO 5000"
    5001 "5001 TO 10000"
    10001 "10001 TO 20000"
    20001 "20001 TO 30000"
    30001 "30001 TO 40000"
    40001 "40001 TO 50000"
    50001 "50001 TO 65000"
    65001 "65001 TO 80000"
    80001 "80001 TO 100000"
    100001 "100001 TO 150000"
    150001 "150001 TO 200000"
    200001 "200001 TO 999999: 200001+"
    /
 R5464200
    -999999 "-999999 TO -3000: < -2999"
    -2999 "-2999 TO -2000"
    -1999 "-1999 TO -1000"
    -999 "-999 TO -1"
    0 "0"
    1 "1 TO 1000"
    1001 "1001 TO 2000"
    2001 "2001 TO 3000"
    3001 "3001 TO 5000"
    5001 "5001 TO 10000"
    10001 "10001 TO 20000"
    20001 "20001 TO 30000"
    30001 "30001 TO 40000"
    40001 "40001 TO 50000"
    50001 "50001 TO 65000"
    65001 "65001 TO 80000"
    80001 "80001 TO 100000"
    100001 "100001 TO 150000"
    150001 "150001 TO 200000"
    200001 "200001 TO 999999999: 200001+"
    /
 R5464300
    0 "0"
    1 "1 TO 99: .01-.99"
    100 "100 TO 199: 1.00-1.99"
    200 "200 TO 299: 2.00-2.99"
    300 "300 TO 399: 3.00-3.99"
    400 "400 TO 499: 4.00-4.99"
    500 "500 TO 599: 5.00-5.99"
    600 "600 TO 699: 6.00-6.99"
    700 "700 TO 799: 7.00-7.99"
    800 "800 TO 899: 8.00-8.99"
    900 "900 TO 999: 9.00-9.99"
    1000 "1000 TO 1099: 10.00-10.99"
    1100 "1100 TO 1199: 11.00-11.99"
    1200 "1200 TO 1299: 12.00-12.99"
    1300 "1300 TO 1399: 13.00-13.99"
    1400 "1400 TO 1499: 14.00-14.99"
    1500 "1500 TO 1599: 15.00-15.99"
    1600 "1600 TO 1699: 16.00-16.99"
    1700 "1700 TO 1799: 17.00-17.99"
    1800 "1800 TO 1899: 18.00-18.99"
    1900 "1900 TO 1999: 19.00-19.99"
    2000 "2000 TO 2999: 20.00-29.99"
    3000 "3000 TO 9999: 30.00+"
    /
 R5464500
    0 "0"
    1 "1"
    2 "2"
    3 "3"
    4 "4"
    5 "5"
    6 "6"
    7 "7"
    8 "8"
    9 "9"
    10 "10"
    11 "11"
    12 "12"
    13 "13"
    14 "14"
    15 "15"
    16 "16"
    17 "17"
    18 "18"
    19 "19"
    20 "20 TO 99: 20+"
    /
 R5484100
    0 "Rural"
    1 "Urban"
    2 "Unknown"
    /
 R5919804
    1 "Economics (Microeconomics, Macroeconomics)"
    0 "NOT SELECTED"
    /
 R6858400
    1 "YES, RESPONDENT HAS OWN ACCOUNT"
    2 "YES, RESPONDENT HAS OWN ACCOUNTS AND ACCOUNTS JOINTLY WITH SPOUSE/PARTNER"
    3 "YES, RESPONDENT ONLY HAS ACCOUNTS JOINTLY WITH SPOUSE/PARTNER"
    4 "YES, SPOUSE/PARTNER HAS ACCOUNTS SEPARATELY FROM RESPONDENT"
    0 "NO"
    /
 R6858500
    1 "SELECT TO ENTER AMOUNT"
    2 "SELECT TO ENTER RANGE"
    /
 R6858700
    1 "A. $1              -        $1,000"
    2 "B.  $1,001      -       $2,500"
    3 "C.  $2,501      -       $5,000"
    4 "D.  $5,001      -     $10,000"
    5 "E.   $10,001    -     $25,000"
    6 "F.   $25,001    -     $50,000"
    7 "G.   More than   $50,000"
    /
 R7222400
    1 "Northeast (CT, ME, MA, NH, NJ, NY, PA, RI, VT)"
    2 "North Central (IL, IN, IA, KS, MI, MN, MO, NE, OH, ND, SD, WI)"
    3 "South (AL, AR, DE, DC, FL, GA, KY, LA, MD, MS, NC, OK, SC, TN , TX, VA, WV)"
    4 "West (AK, AZ, CA, CO, HI, ID, MT, NV, NM, OR, UT, WA, WY)"
    /
 R7227701
    0 "NONE"
    1 "1ST GRADE"
    2 "2ND GRADE"
    3 "3RD GRADE"
    4 "4TH GRADE"
    5 "5TH GRADE"
    6 "6TH GRADE"
    7 "7TH GRADE"
    8 "8TH GRADE"
    9 "9TH GRADE"
    10 "10TH GRADE"
    11 "11TH GRADE"
    12 "12TH GRADE"
    95 "UNGRADED"
    /
 R7227800
    -999999 "-999999 TO -3000: < -2999"
    -2999 "-2999 TO -2000"
    -1999 "-1999 TO -1000"
    -999 "-999 TO -1"
    0 "0"
    1 "1 TO 1000"
    1001 "1001 TO 2000"
    2001 "2001 TO 3000"
    3001 "3001 TO 5000"
    5001 "5001 TO 10000"
    10001 "10001 TO 20000"
    20001 "20001 TO 30000"
    30001 "30001 TO 40000"
    40001 "40001 TO 50000"
    50001 "50001 TO 65000"
    65001 "65001 TO 80000"
    80001 "80001 TO 100000"
    100001 "100001 TO 150000"
    150001 "150001 TO 200000"
    200001 "200001 TO 999999: 200001+"
    /
 R7227900
    -999999 "-999999 TO -3000: < -2999"
    -2999 "-2999 TO -2000"
    -1999 "-1999 TO -1000"
    -999 "-999 TO -1"
    0 "0"
    1 "1 TO 1000"
    1001 "1001 TO 2000"
    2001 "2001 TO 3000"
    3001 "3001 TO 5000"
    5001 "5001 TO 10000"
    10001 "10001 TO 20000"
    20001 "20001 TO 30000"
    30001 "30001 TO 40000"
    40001 "40001 TO 50000"
    50001 "50001 TO 65000"
    65001 "65001 TO 80000"
    80001 "80001 TO 100000"
    100001 "100001 TO 150000"
    150001 "150001 TO 200000"
    200001 "200001 TO 999999999: 200001+"
    /
 R7228000
    0 "0"
    1 "1 TO 99: .01-.99"
    100 "100 TO 199: 1.00-1.99"
    200 "200 TO 299: 2.00-2.99"
    300 "300 TO 399: 3.00-3.99"
    400 "400 TO 499: 4.00-4.99"
    500 "500 TO 599: 5.00-5.99"
    600 "600 TO 699: 6.00-6.99"
    700 "700 TO 799: 7.00-7.99"
    800 "800 TO 899: 8.00-8.99"
    900 "900 TO 999: 9.00-9.99"
    1000 "1000 TO 1099: 10.00-10.99"
    1100 "1100 TO 1199: 11.00-11.99"
    1200 "1200 TO 1299: 12.00-12.99"
    1300 "1300 TO 1399: 13.00-13.99"
    1400 "1400 TO 1499: 14.00-14.99"
    1500 "1500 TO 1599: 15.00-15.99"
    1600 "1600 TO 1699: 16.00-16.99"
    1700 "1700 TO 1799: 17.00-17.99"
    1800 "1800 TO 1899: 18.00-18.99"
    1900 "1900 TO 1999: 19.00-19.99"
    2000 "2000 TO 2999: 20.00-29.99"
    3000 "3000 TO 9999: 30.00+"
    /
 R7228200
    0 "0"
    1 "1"
    2 "2"
    3 "3"
    4 "4"
    5 "5"
    6 "6"
    7 "7"
    8 "8"
    9 "9"
    10 "10"
    11 "11"
    12 "12"
    13 "13"
    14 "14"
    15 "15"
    16 "16"
    17 "17"
    18 "18"
    19 "19"
    20 "20 TO 99: 20+"
    /
 R7248400
    0 "Rural"
    1 "Urban"
    2 "Unknown"
    /
 R9705300
    0 "0 TO 500"
    501 "501 TO 1000"
    1001 "1001 TO 1500"
    1501 "1501 TO 2000"
    2001 "2001 TO 2500"
    2501 "2501 TO 3000"
    3001 "3001 TO 3500"
    /
 R9706000
    0 "0 TO 500"
    501 "501 TO 1000"
    1001 "1001 TO 1500"
    1501 "1501 TO 2000"
    2001 "2001 TO 2500"
    2501 "2501 TO 3000"
    3001 "3001 TO 3500"
    /
 R9829600
    0 "0"
    1 "1 TO 999: .001-.999"
    1000 "1000 TO 19999: 1.000-19.999"
    20000 "20000 TO 39999: 20.000-39.999"
    40000 "40000 TO 59999: 40.000-59.999"
    60000 "60000 TO 79999: 60.000-79.999"
    80000 "80000 TO 100000: 80.000-100.000"
    /
 R9831500
    1 "1"
    2 "2"
    3 "3"
    4 "4"
    5 "5"
    /
 S0294104
    1 "Economics (Microeconomics, Macroeconomics)"
    0 "NOT SELECTED"
    /
 S1092600
    1 "YES, RESPONDENT HAS OWN ACCOUNT"
    2 "YES, RESPONDENT HAS OWN ACCOUNTS AND ACCOUNTS JOINTLY WITH SPOUSE/PARTNER"
    3 "YES, RESPONDENT ONLY HAS ACCOUNTS JOINTLY WITH SPOUSE/PARTNER"
    4 "YES, SPOUSE/PARTNER HAS ACCOUNTS SEPARATELY FROM RESPONDENT"
    0 "NO"
    /
 S1092700
    1 "SELECT TO ENTER AMOUNT"
    2 "SELECT TO ENTER RANGE"
    /
 S1093100
    1 "A. $1              -        $1,000"
    2 "B.  $1,001      -       $2,500"
    3 "C.  $2,501      -       $5,000"
    4 "D.  $5,001      -     $10,000"
    5 "E.   $10,001    -     $25,000"
    6 "F.   $25,001    -     $50,000"
    7 "G.   More than   $50,000"
    /
 S1535500
    1 "Northeast (CT, ME, MA, NH, NJ, NY, PA, RI, VT)"
    2 "North Central (IL, IN, IA, KS, MI, MN, MO, NE, OH, ND, SD, WI)"
    3 "South (AL, AR, DE, DC, FL, GA, KY, LA, MD, MS, NC, OK, SC, TN , TX, VA, WV)"
    4 "West (AK, AZ, CA, CO, HI, ID, MT, NV, NM, OR, UT, WA, WY)"
    /
 S1541601
    0 "NONE"
    1 "1ST GRADE"
    2 "2ND GRADE"
    3 "3RD GRADE"
    4 "4TH GRADE"
    5 "5TH GRADE"
    6 "6TH GRADE"
    7 "7TH GRADE"
    8 "8TH GRADE"
    9 "9TH GRADE"
    10 "10TH GRADE"
    11 "11TH GRADE"
    12 "12TH GRADE"
    95 "UNGRADED"
    /
 S1541700
    -999999 "-999999 TO -3000: < -2999"
    -2999 "-2999 TO -2000"
    -1999 "-1999 TO -1000"
    -999 "-999 TO -1"
    0 "0"
    1 "1 TO 1000"
    1001 "1001 TO 2000"
    2001 "2001 TO 3000"
    3001 "3001 TO 5000"
    5001 "5001 TO 10000"
    10001 "10001 TO 20000"
    20001 "20001 TO 30000"
    30001 "30001 TO 40000"
    40001 "40001 TO 50000"
    50001 "50001 TO 65000"
    65001 "65001 TO 80000"
    80001 "80001 TO 100000"
    100001 "100001 TO 150000"
    150001 "150001 TO 200000"
    200001 "200001 TO 999999: 200001+"
    /
 S1541800
    -999999 "-999999 TO -3000: < -2999"
    -2999 "-2999 TO -2000"
    -1999 "-1999 TO -1000"
    -999 "-999 TO -1"
    0 "0"
    1 "1 TO 1000"
    1001 "1001 TO 2000"
    2001 "2001 TO 3000"
    3001 "3001 TO 5000"
    5001 "5001 TO 10000"
    10001 "10001 TO 20000"
    20001 "20001 TO 30000"
    30001 "30001 TO 40000"
    40001 "40001 TO 50000"
    50001 "50001 TO 65000"
    65001 "65001 TO 80000"
    80001 "80001 TO 100000"
    100001 "100001 TO 150000"
    150001 "150001 TO 200000"
    200001 "200001 TO 999999999: 200001+"
    /
 S1541900
    0 "0"
    1 "1 TO 99: .01-.99"
    100 "100 TO 199: 1.00-1.99"
    200 "200 TO 299: 2.00-2.99"
    300 "300 TO 399: 3.00-3.99"
    400 "400 TO 499: 4.00-4.99"
    500 "500 TO 599: 5.00-5.99"
    600 "600 TO 699: 6.00-6.99"
    700 "700 TO 799: 7.00-7.99"
    800 "800 TO 899: 8.00-8.99"
    900 "900 TO 999: 9.00-9.99"
    1000 "1000 TO 1099: 10.00-10.99"
    1100 "1100 TO 1199: 11.00-11.99"
    1200 "1200 TO 1299: 12.00-12.99"
    1300 "1300 TO 1399: 13.00-13.99"
    1400 "1400 TO 1499: 14.00-14.99"
    1500 "1500 TO 1599: 15.00-15.99"
    1600 "1600 TO 1699: 16.00-16.99"
    1700 "1700 TO 1799: 17.00-17.99"
    1800 "1800 TO 1899: 18.00-18.99"
    1900 "1900 TO 1999: 19.00-19.99"
    2000 "2000 TO 2999: 20.00-29.99"
    3000 "3000 TO 9999: 30.00+"
    /
 S1542100
    0 "0"
    1 "1"
    2 "2"
    3 "3"
    4 "4"
    5 "5"
    6 "6"
    7 "7"
    8 "8"
    9 "9"
    10 "10"
    11 "11"
    12 "12"
    13 "13"
    14 "14"
    15 "15"
    16 "16"
    17 "17"
    18 "18"
    19 "19"
    20 "20 TO 99: 20+"
    /
 S1564300
    0 "Rural"
    1 "Urban"
    2 "Unknown"
    /
 S2005400
    1 "Northeast (CT, ME, MA, NH, NJ, NY, PA, RI, VT)"
    2 "North Central (IL, IN, IA, KS, MI, MN, MO, NE, OH, ND, SD, WI)"
    3 "South (AL, AR, DE, DC, FL, GA, KY, LA, MD, MS, NC, OK, SC, TN , TX, VA, WV)"
    4 "West (AK, AZ, CA, CO, HI, ID, MT, NV, NM, OR, UT, WA, WY)"
    /
 S2011401
    0 "NONE"
    1 "1ST GRADE"
    2 "2ND GRADE"
    3 "3RD GRADE"
    4 "4TH GRADE"
    5 "5TH GRADE"
    6 "6TH GRADE"
    7 "7TH GRADE"
    8 "8TH GRADE"
    9 "9TH GRADE"
    10 "10TH GRADE"
    11 "11TH GRADE"
    12 "12TH GRADE"
    95 "UNGRADED"
    /
 S2011500
    -999999 "-999999 TO -3000: < -2999"
    -2999 "-2999 TO -2000"
    -1999 "-1999 TO -1000"
    -999 "-999 TO -1"
    0 "0"
    1 "1 TO 1000"
    1001 "1001 TO 2000"
    2001 "2001 TO 3000"
    3001 "3001 TO 5000"
    5001 "5001 TO 10000"
    10001 "10001 TO 20000"
    20001 "20001 TO 30000"
    30001 "30001 TO 40000"
    40001 "40001 TO 50000"
    50001 "50001 TO 65000"
    65001 "65001 TO 80000"
    80001 "80001 TO 100000"
    100001 "100001 TO 150000"
    150001 "150001 TO 200000"
    200001 "200001 TO 999999: 200001+"
    /
 S2011600
    -999999 "-999999 TO -3000: < -2999"
    -2999 "-2999 TO -2000"
    -1999 "-1999 TO -1000"
    -999 "-999 TO -1"
    0 "0"
    1 "1 TO 1000"
    1001 "1001 TO 2000"
    2001 "2001 TO 3000"
    3001 "3001 TO 5000"
    5001 "5001 TO 10000"
    10001 "10001 TO 20000"
    20001 "20001 TO 30000"
    30001 "30001 TO 40000"
    40001 "40001 TO 50000"
    50001 "50001 TO 65000"
    65001 "65001 TO 80000"
    80001 "80001 TO 100000"
    100001 "100001 TO 150000"
    150001 "150001 TO 200000"
    200001 "200001 TO 999999999: 200001+"
    /
 S2011700
    0 "0"
    1 "1 TO 99: .01-.99"
    100 "100 TO 199: 1.00-1.99"
    200 "200 TO 299: 2.00-2.99"
    300 "300 TO 399: 3.00-3.99"
    400 "400 TO 499: 4.00-4.99"
    500 "500 TO 599: 5.00-5.99"
    600 "600 TO 699: 6.00-6.99"
    700 "700 TO 799: 7.00-7.99"
    800 "800 TO 899: 8.00-8.99"
    900 "900 TO 999: 9.00-9.99"
    1000 "1000 TO 1099: 10.00-10.99"
    1100 "1100 TO 1199: 11.00-11.99"
    1200 "1200 TO 1299: 12.00-12.99"
    1300 "1300 TO 1399: 13.00-13.99"
    1400 "1400 TO 1499: 14.00-14.99"
    1500 "1500 TO 1599: 15.00-15.99"
    1600 "1600 TO 1699: 16.00-16.99"
    1700 "1700 TO 1799: 17.00-17.99"
    1800 "1800 TO 1899: 18.00-18.99"
    1900 "1900 TO 1999: 19.00-19.99"
    2000 "2000 TO 2999: 20.00-29.99"
    3000 "3000 TO 9999: 30.00+"
    /
 S2011900
    0 "0"
    1 "1"
    2 "2"
    3 "3"
    4 "4"
    5 "5"
    6 "6"
    7 "7"
    8 "8"
    9 "9"
    10 "10"
    11 "11"
    12 "12"
    13 "13"
    14 "14"
    15 "15"
    16 "16"
    17 "17"
    18 "18"
    19 "19"
    20 "20 TO 99: 20+"
    /
 S2034400
    0 "Rural"
    1 "Urban"
    2 "Unknown"
    /
 S2332904
    1 "Economics (Microeconomics, Macroeconomics)"
    0 "NOT SELECTED"
    /
 S3165000
    1 "YES, RESPONDENT HAS OWN ACCOUNT"
    2 "YES, RESPONDENT HAS OWN ACCOUNTS AND ACCOUNTS JOINTLY WITH SPOUSE/PARTNER"
    3 "YES, RESPONDENT ONLY HAS ACCOUNTS JOINTLY WITH SPOUSE/PARTNER"
    4 "YES, SPOUSE/PARTNER HAS ACCOUNTS SEPARATELY FROM RESPONDENT"
    0 "NO"
    /
 S3165100
    1 "SELECT TO ENTER AMOUNT"
    2 "SELECT TO ENTER RANGE"
    /
 S3165500
    1 "A. $1              -        $1,000"
    2 "B.  $1,001      -       $2,500"
    3 "C.  $2,501      -       $5,000"
    4 "D.  $5,001      -     $10,000"
    5 "E.   $10,001    -     $25,000"
    6 "F.   $25,001    -     $50,000"
    7 "G.   More than   $50,000"
    /
 S3805700
    1 "Northeast (CT, ME, MA, NH, NJ, NY, PA, RI, VT)"
    2 "North Central (IL, IN, IA, KS, MI, MN, MO, NE, OH, ND, SD, WI)"
    3 "South (AL, AR, DE, DC, FL, GA, KY, LA, MD, MS, NC, OK, SC, TN , TX, VA, WV)"
    4 "West (AK, AZ, CA, CO, HI, ID, MT, NV, NM, OR, UT, WA, WY)"
    /
 S3812301
    0 "NONE"
    1 "1ST GRADE"
    2 "2ND GRADE"
    3 "3RD GRADE"
    4 "4TH GRADE"
    5 "5TH GRADE"
    6 "6TH GRADE"
    7 "7TH GRADE"
    8 "8TH GRADE"
    9 "9TH GRADE"
    10 "10TH GRADE"
    11 "11TH GRADE"
    12 "12TH GRADE"
    95 "UNGRADED"
    /
 S3812400
    -999999 "-999999 TO -3000: < -2999"
    -2999 "-2999 TO -2000"
    -1999 "-1999 TO -1000"
    -999 "-999 TO -1"
    0 "0"
    1 "1 TO 1000"
    1001 "1001 TO 2000"
    2001 "2001 TO 3000"
    3001 "3001 TO 5000"
    5001 "5001 TO 10000"
    10001 "10001 TO 20000"
    20001 "20001 TO 30000"
    30001 "30001 TO 40000"
    40001 "40001 TO 50000"
    50001 "50001 TO 65000"
    65001 "65001 TO 80000"
    80001 "80001 TO 100000"
    100001 "100001 TO 150000"
    150001 "150001 TO 200000"
    200001 "200001 TO 999999: 200001+"
    /
 S3812500
    0 "0"
    1 "1 TO 99: .01-.99"
    100 "100 TO 199: 1.00-1.99"
    200 "200 TO 299: 2.00-2.99"
    300 "300 TO 399: 3.00-3.99"
    400 "400 TO 499: 4.00-4.99"
    500 "500 TO 599: 5.00-5.99"
    600 "600 TO 699: 6.00-6.99"
    700 "700 TO 799: 7.00-7.99"
    800 "800 TO 899: 8.00-8.99"
    900 "900 TO 999: 9.00-9.99"
    1000 "1000 TO 1099: 10.00-10.99"
    1100 "1100 TO 1199: 11.00-11.99"
    1200 "1200 TO 1299: 12.00-12.99"
    1300 "1300 TO 1399: 13.00-13.99"
    1400 "1400 TO 1499: 14.00-14.99"
    1500 "1500 TO 1599: 15.00-15.99"
    1600 "1600 TO 1699: 16.00-16.99"
    1700 "1700 TO 1799: 17.00-17.99"
    1800 "1800 TO 1899: 18.00-18.99"
    1900 "1900 TO 1999: 19.00-19.99"
    2000 "2000 TO 2999: 20.00-29.99"
    3000 "3000 TO 9999: 30.00+"
    /
 S3813400
    0 "0"
    1 "1"
    2 "2"
    3 "3"
    4 "4"
    5 "5"
    6 "6"
    7 "7"
    8 "8"
    9 "9"
    10 "10"
    11 "11"
    12 "12"
    13 "13"
    14 "14"
    15 "15"
    16 "16"
    17 "17"
    18 "18"
    19 "19"
    20 "20 TO 99: 20+"
    /
 S3835800
    0 "Rural"
    1 "Urban"
    2 "Unknown"
    /
 S4104604
    1 "Economics (Microeconomics, Macroeconomics)"
    0 "NOT SELECTED"
    /
 S4822600
    1 "YES, RESPONDENT HAS OWN ACCOUNT"
    2 "YES, RESPONDENT HAS OWN ACCOUNTS AND ACCOUNTS JOINTLY WITH SPOUSE/PARTNER"
    3 "YES, RESPONDENT ONLY HAS ACCOUNTS JOINTLY WITH SPOUSE/PARTNER"
    4 "YES, SPOUSE/PARTNER HAS ACCOUNTS SEPARATELY FROM RESPONDENT"
    0 "NO"
    /
 S4822700
    1 "SELECT TO ENTER AMOUNT"
    2 "SELECT TO ENTER RANGE"
    /
 S4823100
    1 "A. $1              -        $1,000"
    2 "B.  $1,001      -       $2,500"
    3 "C.  $2,501      -       $5,000"
    4 "D.  $5,001      -     $10,000"
    5 "E.   $10,001    -     $25,000"
    6 "F.   $25,001    -     $50,000"
    7 "G.   More than   $50,000"
    /
 S5405600
    1 "Northeast (CT, ME, MA, NH, NJ, NY, PA, RI, VT)"
    2 "North Central (IL, IN, IA, KS, MI, MN, MO, NE, OH, ND, SD, WI)"
    3 "South (AL, AR, DE, DC, FL, GA, KY, LA, MD, MS, NC, OK, SC, TN , TX, VA, WV)"
    4 "West (AK, AZ, CA, CO, HI, ID, MT, NV, NM, OR, UT, WA, WY)"
    /
 S5412700
    0 "None"
    1 "1st Grade"
    2 "2nd Grade"
    3 "3rd Grade"
    4 "4th Grade"
    5 "5th Grade"
    6 "6th Grade"
    7 "7th Grade"
    8 "8th Grade"
    9 "9th Grade"
    10 "10th Grade"
    11 "11th Grade"
    12 "12th Grade"
    95 "Ungraded"
    /
 S5412800
    -999999 "-999999 TO -3000: < -2999"
    -2999 "-2999 TO -2000"
    -1999 "-1999 TO -1000"
    -999 "-999 TO -1"
    0 "0"
    1 "1 TO 1000"
    1001 "1001 TO 2000"
    2001 "2001 TO 3000"
    3001 "3001 TO 5000"
    5001 "5001 TO 10000"
    10001 "10001 TO 20000"
    20001 "20001 TO 30000"
    30001 "30001 TO 40000"
    40001 "40001 TO 50000"
    50001 "50001 TO 65000"
    65001 "65001 TO 80000"
    80001 "80001 TO 100000"
    100001 "100001 TO 150000"
    150001 "150001 TO 200000"
    200001 "200001 TO 999999: 200001+"
    /
 S5412900
    0 "0"
    1 "1 TO 99: .01-.99"
    100 "100 TO 199: 1.00-1.99"
    200 "200 TO 299: 2.00-2.99"
    300 "300 TO 399: 3.00-3.99"
    400 "400 TO 499: 4.00-4.99"
    500 "500 TO 599: 5.00-5.99"
    600 "600 TO 699: 6.00-6.99"
    700 "700 TO 799: 7.00-7.99"
    800 "800 TO 899: 8.00-8.99"
    900 "900 TO 999: 9.00-9.99"
    1000 "1000 TO 1099: 10.00-10.99"
    1100 "1100 TO 1199: 11.00-11.99"
    1200 "1200 TO 1299: 12.00-12.99"
    1300 "1300 TO 1399: 13.00-13.99"
    1400 "1400 TO 1499: 14.00-14.99"
    1500 "1500 TO 1599: 15.00-15.99"
    1600 "1600 TO 1699: 16.00-16.99"
    1700 "1700 TO 1799: 17.00-17.99"
    1800 "1800 TO 1899: 18.00-18.99"
    1900 "1900 TO 1999: 19.00-19.99"
    2000 "2000 TO 2999: 20.00-29.99"
    3000 "3000 TO 9999: 30.00+"
    /
 S5413000
    0 "0"
    1 "1"
    2 "2"
    3 "3"
    4 "4"
    5 "5"
    6 "6"
    7 "7"
    8 "8"
    9 "9"
    10 "10"
    11 "11"
    12 "12"
    13 "13"
    14 "14"
    15 "15"
    16 "16"
    17 "17"
    18 "18"
    19 "19"
    20 "20 TO 99: 20+"
    /
 S5436300
    0 "Rural"
    1 "Urban"
    2 "Unknown"
    /
 S5664704
    1 "Economics (Microeconomics, Macroeconomics)"
    0 "NOT SELECTED"
    /
 S6518400
    1 "YES, RESPONDENT HAS OWN ACCOUNT"
    2 "YES, RESPONDENT HAS OWN ACCOUNTS AND ACCOUNTS JOINTLY WITH SPOUSE/PARTNER"
    3 "YES, RESPONDENT ONLY HAS ACCOUNTS JOINTLY WITH SPOUSE/PARTNER"
    4 "YES, SPOUSE/PARTNER HAS ACCOUNTS SEPARATELY FROM RESPONDENT"
    0 "NO"
    /
 S6518500
    1 "SELECT TO ENTER AMOUNT"
    2 "SELECT TO ENTER RANGE"
    /
 S6518900
    1 "A. $1              -        $1,000"
    2 "B.  $1,001      -       $2,500"
    3 "C.  $2,501      -       $5,000"
    4 "D.  $5,001      -     $10,000"
    5 "E.   $10,001    -     $25,000"
    6 "F.   $25,001    -     $50,000"
    7 "G.   More than   $50,000"
    /
 S7506100
    1 "Northeast (CT, ME, MA, NH, NJ, NY, PA, RI, VT)"
    2 "North Central (IL, IN, IA, KS, MI, MN, MO, NE, OH, ND, SD, WI)"
    3 "South (AL, AR, DE, DC, FL, GA, KY, LA, MD, MS, NC, OK, SC, TN , TX, VA, WV)"
    4 "West (AK, AZ, CA, CO, HI, ID, MT, NV, NM, OR, UT, WA, WY)"
    /
 S7513600
    0 "None"
    1 "1st Grade"
    2 "2nd Grade"
    3 "3rd Grade"
    4 "4th Grade"
    5 "5th Grade"
    6 "6th Grade"
    7 "7th Grade"
    8 "8th Grade"
    9 "9th Grade"
    10 "10th Grade"
    11 "11th Grade"
    12 "12th Grade"
    95 "Ungraded"
    /
 S7513700
    -999999 "-999999 TO -3000: < -2999"
    -2999 "-2999 TO -2000"
    -1999 "-1999 TO -1000"
    -999 "-999 TO -1"
    0 "0"
    1 "1 TO 1000"
    1001 "1001 TO 2000"
    2001 "2001 TO 3000"
    3001 "3001 TO 5000"
    5001 "5001 TO 10000"
    10001 "10001 TO 20000"
    20001 "20001 TO 30000"
    30001 "30001 TO 40000"
    40001 "40001 TO 50000"
    50001 "50001 TO 65000"
    65001 "65001 TO 80000"
    80001 "80001 TO 100000"
    100001 "100001 TO 150000"
    150001 "150001 TO 200000"
    200001 "200001 TO 999999: 200001+"
    /
 S7513800
    0 "0"
    1 "1 TO 99: .01-.99"
    100 "100 TO 199: 1.00-1.99"
    200 "200 TO 299: 2.00-2.99"
    300 "300 TO 399: 3.00-3.99"
    400 "400 TO 499: 4.00-4.99"
    500 "500 TO 599: 5.00-5.99"
    600 "600 TO 699: 6.00-6.99"
    700 "700 TO 799: 7.00-7.99"
    800 "800 TO 899: 8.00-8.99"
    900 "900 TO 999: 9.00-9.99"
    1000 "1000 TO 1099: 10.00-10.99"
    1100 "1100 TO 1199: 11.00-11.99"
    1200 "1200 TO 1299: 12.00-12.99"
    1300 "1300 TO 1399: 13.00-13.99"
    1400 "1400 TO 1499: 14.00-14.99"
    1500 "1500 TO 1599: 15.00-15.99"
    1600 "1600 TO 1699: 16.00-16.99"
    1700 "1700 TO 1799: 17.00-17.99"
    1800 "1800 TO 1899: 18.00-18.99"
    1900 "1900 TO 1999: 19.00-19.99"
    2000 "2000 TO 2999: 20.00-29.99"
    3000 "3000 TO 9999: 30.00+"
    /
 S7513900
    0 "0"
    1 "1"
    2 "2"
    3 "3"
    4 "4"
    5 "5"
    6 "6"
    7 "7"
    8 "8"
    9 "9"
    10 "10"
    11 "11"
    12 "12"
    13 "13"
    14 "14"
    15 "15"
    16 "16"
    17 "17"
    18 "18"
    19 "19"
    20 "20 TO 99: 20+"
    /
 S7537100
    0 "Rural"
    1 "Urban"
    2 "Unknown"
    /
 S7740704
    1 "Economics (Microeconomics, Macroeconomics)"
    0 "NOT SELECTED"
    /
 S8516500
    1 "YES, RESPONDENT HAS OWN ACCOUNT"
    2 "YES, RESPONDENT HAS OWN ACCOUNTS AND ACCOUNTS JOINTLY WITH SPOUSE/PARTNER"
    3 "YES, RESPONDENT ONLY HAS ACCOUNTS JOINTLY WITH SPOUSE/PARTNER"
    4 "YES, SPOUSE/PARTNER HAS ACCOUNTS SEPARATELY FROM RESPONDENT"
    0 "NO"
    /
 S8516600
    1 "SELECT TO ENTER AMOUNT"
    2 "SELECT TO ENTER RANGE"
    /
 S8517000
    1 "A. $1              -        $1,000"
    2 "B.  $1,001      -       $2,500"
    3 "C.  $2,501      -       $5,000"
    4 "D.  $5,001      -     $10,000"
    5 "E.   $10,001    -     $25,000"
    6 "F.   $25,001    -     $50,000"
    7 "G.   More than   $50,000"
    /
 Z9049700
    -9999999 "-9999999 TO -3000: < -2999"
    -2999 "-2999 TO -2000"
    -1999 "-1999 TO -1000"
    -999 "-999 TO -1"
    0 "0"
    1 "1 TO 1000"
    1001 "1001 TO 2000"
    2001 "2001 TO 3000"
    3001 "3001 TO 5000"
    5001 "5001 TO 10000"
    10001 "10001 TO 20000"
    20001 "20001 TO 30000"
    30001 "30001 TO 40000"
    40001 "40001 TO 50000"
    50001 "50001 TO 65000"
    65001 "65001 TO 80000"
    80001 "80001 TO 100000"
    100001 "100001 TO 150000"
    150001 "150001 TO 200000"
    200001 "200001 TO 999999999: 200001+"
    /
 Z9050100
    -9999999 "-9999999 TO -3000: < -2999"
    -2999 "-2999 TO -2000"
    -1999 "-1999 TO -1000"
    -999 "-999 TO -1"
    0 "0"
    1 "1 TO 1000"
    1001 "1001 TO 2000"
    2001 "2001 TO 3000"
    3001 "3001 TO 5000"
    5001 "5001 TO 10000"
    10001 "10001 TO 20000"
    20001 "20001 TO 30000"
    30001 "30001 TO 40000"
    40001 "40001 TO 50000"
    50001 "50001 TO 65000"
    65001 "65001 TO 80000"
    80001 "80001 TO 100000"
    100001 "100001 TO 150000"
    150001 "150001 TO 200000"
    200001 "200001 TO 999999999: 200001+"
    /
.


/* Crosswalk for Reference number & Question name
 * Uncomment and edit this RENAME VARIABLES statement to rename variables for ease of use.
 * This command does not guarantee uniqueness
 */  /* *start* */

* RENAME VARIABLES
  (R0000100 = PUBID_1997)
  (R0041603 = YSCH_9600_000004_1997)  /* YSCH-9600_000004 */
  (R0507500 = YINC_18700_1997)  /* YINC-18700 */
  (R0507600 = YINC_18800_1997)  /* YINC-18800 */
  (R0507700 = YINC_18900_1997)  /* YINC-18900 */
  (R0536300 = KEY_SEX_1997)  /* KEY!SEX */
  (R0536401 = KEY_BDATE_M_1997)  /* KEY!BDATE_M */
  (R0536402 = KEY_BDATE_Y_1997)  /* KEY!BDATE_Y */
  (R1200300 = CV_CENSUS_REGION_1997)
  (R1204500 = CV_INCOME_GROSS_YR_1997)
  (R1204700 = CV_HH_NET_WORTH_P_1997)
  (R1204800 = CV_HH_NET_WORTH_Y_1997)
  (R1204900 = CV_HH_POV_RATIO_1997)
  (R1205400 = CV_HH_SIZE_1997)
  (R1217500 = CV_URBAN_RURAL_1997)  /* CV_URBAN-RURAL */
  (R1235800 = CV_SAMPLE_TYPE_1997)
  (R1482600 = KEY_RACE_ETHNICITY_1997)  /* KEY!RACE_ETHNICITY */
  (R1704004 = YSCH_9600_000005_1998)  /* YSCH-9600~000005 */
  (R2370600 = YAST_4400_1998)  /* YAST-4400 */
  (R2370700 = YAST_4420_1998)  /* YAST-4420 */
  (R2370900 = YAST_4426_1998)  /* YAST-4426 */
  (R2558800 = CV_CENSUS_REGION_1998)
  (R2563201 = CV_HGC_9899_1998)
  (R2563300 = CV_INCOME_GROSS_YR_1998)
  (R2563400 = CV_HH_NET_WORTH_Y_1998)
  (R2563500 = CV_HH_POV_RATIO_1998)
  (R2563700 = CV_HH_SIZE_1998)
  (R2576800 = CV_URBAN_RURAL_1998)  /* CV_URBAN-RURAL */
  (R2996504 = YSCH_9600_000005_1999)  /* YSCH-9600~000005 */
  (R3678300 = YAST_4400_1999)  /* YAST-4400 */
  (R3678400 = YAST_4420_1999)  /* YAST-4420 */
  (R3678600 = YAST_4426_1999)  /* YAST-4426 */
  (R3880300 = CV_CENSUS_REGION_1999)
  (R3884801 = CV_HGC_9900_1999)
  (R3884900 = CV_INCOME_GROSS_YR_1999)
  (R3885000 = CV_HH_NET_WORTH_Y_1999)
  (R3885100 = CV_HH_POV_RATIO_1999)
  (R3885300 = CV_HH_SIZE_1999)
  (R3899100 = CV_URBAN_RURAL_1999)  /* CV_URBAN-RURAL */
  (R4262104 = YSCH_9600_000005_2000)  /* YSCH-9600~000005 */
  (R5128600 = YAST_4400_2000)  /* YAST-4400 */
  (R5128700 = YAST_4420_2000)  /* YAST-4420 */
  (R5128900 = YAST_4426_2000)  /* YAST-4426 */
  (R5459400 = CV_CENSUS_REGION_2000)
  (R5464001 = CV_HGC_0001_2000)
  (R5464100 = CV_INCOME_GROSS_YR_2000)
  (R5464200 = CV_HH_NET_WORTH_Y_2000)
  (R5464300 = CV_HH_POV_RATIO_2000)
  (R5464500 = CV_HH_SIZE_2000)
  (R5484100 = CV_URBAN_RURAL_2000)  /* CV_URBAN-RURAL */
  (R5919804 = YSCH_9600_000005_2001)  /* YSCH-9600~000005 */
  (R6858400 = YAST_4400_2001)  /* YAST-4400 */
  (R6858500 = YAST_4420_2001)  /* YAST-4420 */
  (R6858700 = YAST_4426_2001)  /* YAST-4426 */
  (R7222400 = CV_CENSUS_REGION_2001)
  (R7227701 = CV_HGC_0102_2001)
  (R7227800 = CV_INCOME_GROSS_YR_2001)
  (R7227900 = CV_HH_NET_WORTH_Y_2001)
  (R7228000 = CV_HH_POV_RATIO_2001)
  (R7228200 = CV_HH_SIZE_2001)
  (R7248400 = CV_URBAN_RURAL_2001)  /* CV_URBAN-RURAL */
  (R9705300 = ASVAB_AR_ABILITY_EST_POS_XRND)
  (R9706000 = ASVAB_MK_ABILITY_EST_POS_XRND)
  (R9829600 = ASVAB_MATH_VERBAL_SCORE_PCT_XRND)
  (R9831500 = TRANS_AP_ECON_HSTR)
  (S0294104 = YSCH_9600_000005_2002)  /* YSCH-9600~000005 */
  (S1092600 = YAST_4400_2002)  /* YAST-4400 */
  (S1092700 = YAST_4420_2002)  /* YAST-4420 */
  (S1093100 = YAST_4426_2002)  /* YAST-4426 */
  (S1535500 = CV_CENSUS_REGION_2002)
  (S1541601 = CV_HGC_0203_2002)
  (S1541700 = CV_INCOME_GROSS_YR_2002)
  (S1541800 = CV_HH_NET_WORTH_Y_2002)
  (S1541900 = CV_HH_POV_RATIO_2002)
  (S1542100 = CV_HH_SIZE_2002)
  (S1564300 = CV_URBAN_RURAL_2002)  /* CV_URBAN-RURAL */
  (S2005400 = CV_CENSUS_REGION_2003)
  (S2011401 = CV_HGC_0304_2003)
  (S2011500 = CV_INCOME_GROSS_YR_2003)
  (S2011600 = CV_HH_NET_WORTH_Y_2003)
  (S2011700 = CV_HH_POV_RATIO_2003)
  (S2011900 = CV_HH_SIZE_2003)
  (S2034400 = CV_URBAN_RURAL_2003)  /* CV_URBAN-RURAL */
  (S2332904 = YSCH_9600_000005_2003)  /* YSCH-9600~000005 */
  (S3165000 = YAST_4400_2003)  /* YAST-4400 */
  (S3165100 = YAST_4420_2003)  /* YAST-4420 */
  (S3165500 = YAST_4426_2003)  /* YAST-4426 */
  (S3805700 = CV_CENSUS_REGION_2004)
  (S3812301 = CV_HGC_0405_2004)
  (S3812400 = CV_INCOME_FAMILY_2004)
  (S3812500 = CV_HH_POV_RATIO_2004)
  (S3813400 = CV_HH_SIZE_2004)
  (S3835800 = CV_URBAN_RURAL_2004)  /* CV_URBAN-RURAL */
  (S4104604 = YSCH_9600_000005_2004)  /* YSCH-9600~000005 */
  (S4822600 = YAST_4400_2004)  /* YAST-4400 */
  (S4822700 = YAST_4420_2004)  /* YAST-4420 */
  (S4823100 = YAST_4426_2004)  /* YAST-4426 */
  (S5405600 = CV_CENSUS_REGION_2005)
  (S5412700 = CV_HGC_0506_2005)
  (S5412800 = CV_INCOME_FAMILY_2005)
  (S5412900 = CV_HH_POV_RATIO_2005)
  (S5413000 = CV_HH_SIZE_2005)
  (S5436300 = CV_URBAN_RURAL_2005)  /* CV_URBAN-RURAL */
  (S5664704 = YSCH_9600_000005_2005)  /* YSCH-9600~000005 */
  (S6518400 = YAST_4400_2005)  /* YAST-4400 */
  (S6518500 = YAST_4420_2005)  /* YAST-4420 */
  (S6518900 = YAST_4426_2005)  /* YAST-4426 */
  (S7506100 = CV_CENSUS_REGION_2006)
  (S7513600 = CV_HGC_0607_2006)
  (S7513700 = CV_INCOME_FAMILY_2006)
  (S7513800 = CV_HH_POV_RATIO_2006)
  (S7513900 = CV_HH_SIZE_2006)
  (S7537100 = CV_URBAN_RURAL_2006)  /* CV_URBAN-RURAL */
  (S7740704 = YSCH_9600_000005_2006)  /* YSCH-9600~000005 */
  (S8516500 = YAST_4400_2006)  /* YAST-4400 */
  (S8516600 = YAST_4420_2006)  /* YAST-4420 */
  (S8517000 = YAST_4426_2006)  /* YAST-4426 */
  (Z9049700 = CVC_ASSETS_FINANCIAL_20_XRND)
  (Z9050100 = CVC_ASSETS_DEBTS_20_XRND)
.
  /* *end* */

descriptives all.

*--- Tabulations using reference number variables.
*freq var=R0000100,
  R0041603,
  R0507500,
  R0507600,
  R0507700,
  R0536300,
  R0536401,
  R0536402,
  R1200300,
  R1204500,
  R1204700,
  R1204800,
  R1204900,
  R1205400,
  R1217500,
  R1235800,
  R1482600,
  R1704004,
  R2370600,
  R2370700,
  R2370900,
  R2558800,
  R2563201,
  R2563300,
  R2563400,
  R2563500,
  R2563700,
  R2576800,
  R2996504,
  R3678300,
  R3678400,
  R3678600,
  R3880300,
  R3884801,
  R3884900,
  R3885000,
  R3885100,
  R3885300,
  R3899100,
  R4262104,
  R5128600,
  R5128700,
  R5128900,
  R5459400,
  R5464001,
  R5464100,
  R5464200,
  R5464300,
  R5464500,
  R5484100,
  R5919804,
  R6858400,
  R6858500,
  R6858700,
  R7222400,
  R7227701,
  R7227800,
  R7227900,
  R7228000,
  R7228200,
  R7248400,
  R9705300,
  R9706000,
  R9829600,
  R9831500,
  S0294104,
  S1092600,
  S1092700,
  S1093100,
  S1535500,
  S1541601,
  S1541700,
  S1541800,
  S1541900,
  S1542100,
  S1564300,
  S2005400,
  S2011401,
  S2011500,
  S2011600,
  S2011700,
  S2011900,
  S2034400,
  S2332904,
  S3165000,
  S3165100,
  S3165500,
  S3805700,
  S3812301,
  S3812400,
  S3812500,
  S3813400,
  S3835800,
  S4104604,
  S4822600,
  S4822700,
  S4823100,
  S5405600,
  S5412700,
  S5412800,
  S5412900,
  S5413000,
  S5436300,
  S5664704,
  S6518400,
  S6518500,
  S6518900,
  S7506100,
  S7513600,
  S7513700,
  S7513800,
  S7513900,
  S7537100,
  S7740704,
  S8516500,
  S8516600,
  S8517000,
  Z9049700,
  Z9050100.

*--- Tabulations using qname variables.
*freq var=PUBID_1997,
  YSCH_9600_000004_1997,
  YINC_18700_1997,
  YINC_18800_1997,
  YINC_18900_1997,
  KEY_SEX_1997,
  KEY_BDATE_M_1997,
  KEY_BDATE_Y_1997,
  CV_CENSUS_REGION_1997,
  CV_INCOME_GROSS_YR_1997,
  CV_HH_NET_WORTH_P_1997,
  CV_HH_NET_WORTH_Y_1997,
  CV_HH_POV_RATIO_1997,
  CV_HH_SIZE_1997,
  CV_URBAN_RURAL_1997,
  CV_SAMPLE_TYPE_1997,
  KEY_RACE_ETHNICITY_1997,
  YSCH_9600_000005_1998,
  YAST_4400_1998,
  YAST_4420_1998,
  YAST_4426_1998,
  CV_CENSUS_REGION_1998,
  CV_HGC_9899_1998,
  CV_INCOME_GROSS_YR_1998,
  CV_HH_NET_WORTH_Y_1998,
  CV_HH_POV_RATIO_1998,
  CV_HH_SIZE_1998,
  CV_URBAN_RURAL_1998,
  YSCH_9600_000005_1999,
  YAST_4400_1999,
  YAST_4420_1999,
  YAST_4426_1999,
  CV_CENSUS_REGION_1999,
  CV_HGC_9900_1999,
  CV_INCOME_GROSS_YR_1999,
  CV_HH_NET_WORTH_Y_1999,
  CV_HH_POV_RATIO_1999,
  CV_HH_SIZE_1999,
  CV_URBAN_RURAL_1999,
  YSCH_9600_000005_2000,
  YAST_4400_2000,
  YAST_4420_2000,
  YAST_4426_2000,
  CV_CENSUS_REGION_2000,
  CV_HGC_0001_2000,
  CV_INCOME_GROSS_YR_2000,
  CV_HH_NET_WORTH_Y_2000,
  CV_HH_POV_RATIO_2000,
  CV_HH_SIZE_2000,
  CV_URBAN_RURAL_2000,
  YSCH_9600_000005_2001,
  YAST_4400_2001,
  YAST_4420_2001,
  YAST_4426_2001,
  CV_CENSUS_REGION_2001,
  CV_HGC_0102_2001,
  CV_INCOME_GROSS_YR_2001,
  CV_HH_NET_WORTH_Y_2001,
  CV_HH_POV_RATIO_2001,
  CV_HH_SIZE_2001,
  CV_URBAN_RURAL_2001,
  ASVAB_AR_ABILITY_EST_POS_XRND,
  ASVAB_MK_ABILITY_EST_POS_XRND,
  ASVAB_MATH_VERBAL_SCORE_PCT_XRND,
  TRANS_AP_ECON_HSTR,
  YSCH_9600_000005_2002,
  YAST_4400_2002,
  YAST_4420_2002,
  YAST_4426_2002,
  CV_CENSUS_REGION_2002,
  CV_HGC_0203_2002,
  CV_INCOME_GROSS_YR_2002,
  CV_HH_NET_WORTH_Y_2002,
  CV_HH_POV_RATIO_2002,
  CV_HH_SIZE_2002,
  CV_URBAN_RURAL_2002,
  CV_CENSUS_REGION_2003,
  CV_HGC_0304_2003,
  CV_INCOME_GROSS_YR_2003,
  CV_HH_NET_WORTH_Y_2003,
  CV_HH_POV_RATIO_2003,
  CV_HH_SIZE_2003,
  CV_URBAN_RURAL_2003,
  YSCH_9600_000005_2003,
  YAST_4400_2003,
  YAST_4420_2003,
  YAST_4426_2003,
  CV_CENSUS_REGION_2004,
  CV_HGC_0405_2004,
  CV_INCOME_FAMILY_2004,
  CV_HH_POV_RATIO_2004,
  CV_HH_SIZE_2004,
  CV_URBAN_RURAL_2004,
  YSCH_9600_000005_2004,
  YAST_4400_2004,
  YAST_4420_2004,
  YAST_4426_2004,
  CV_CENSUS_REGION_2005,
  CV_HGC_0506_2005,
  CV_INCOME_FAMILY_2005,
  CV_HH_POV_RATIO_2005,
  CV_HH_SIZE_2005,
  CV_URBAN_RURAL_2005,
  YSCH_9600_000005_2005,
  YAST_4400_2005,
  YAST_4420_2005,
  YAST_4426_2005,
  CV_CENSUS_REGION_2006,
  CV_HGC_0607_2006,
  CV_INCOME_FAMILY_2006,
  CV_HH_POV_RATIO_2006,
  CV_HH_SIZE_2006,
  CV_URBAN_RURAL_2006,
  YSCH_9600_000005_2006,
  YAST_4400_2006,
  YAST_4420_2006,
  YAST_4426_2006,
  CVC_ASSETS_FINANCIAL_20_XRND,
  CVC_ASSETS_DEBTS_20_XRND.

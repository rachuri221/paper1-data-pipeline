
file handle pcdat/name='default.dat' /lrecl=31.
data list file pcdat free /
  C0000100 (F7)
  C0000200 (F5)
  C0005300 (F2)
  C0005400 (F2)
  C0005700 (F4)
  Y2267000 (F3)
.

* The following code works with current versions of SPSS.

missing values all (-7 thru -1).
* older versions of SPSS may require this:
* recode all (-3,-2,-1=-7).
* missing values all (-7).



variable labels
  C0000100  "ID CODE OF CHILD"
  C0000200  "ID CODE OF MOTHER OF CHILD"
  C0005300  "RACE OF CHILD (FROM MOTHERS SCREENER 79)"
  C0005400  "SEX OF CHILD"
  C0005700  "DATE OF BIRTH OF CHILD - YEAR"
  Y2267000  "VERSION_R29 CHILD/YOUNG ADULT XRND"
.

* Recode continuous values.
* recode
  C0000100
    (1 thru 9999999 eq 1)
    /
  C0000200
    (1 thru 12686 eq 1)
    /
  C0005700
    (1970 thru 1978 eq 1970)
    (1979 thru 1979 eq 1979)
    (1980 thru 1980 eq 1980)
    (1981 thru 1981 eq 1981)
    (1982 thru 1982 eq 1982)
    (1983 thru 1983 eq 1983)
    (1984 thru 1984 eq 1984)
    (1985 thru 1985 eq 1985)
    (1986 thru 1986 eq 1986)
    (1987 thru 1987 eq 1987)
    (1988 thru 1988 eq 1988)
    (1989 thru 1989 eq 1989)
    (1990 thru 1990 eq 1990)
    (1991 thru 1991 eq 1991)
    (1992 thru 1992 eq 1992)
    (1993 thru 1993 eq 1993)
    (1994 thru 1994 eq 1994)
    (1995 thru 1995 eq 1995)
    (1996 thru 1996 eq 1996)
    (1997 thru 1997 eq 1997)
    (1998 thru 1998 eq 1998)
    (1999 thru 1999 eq 1999)
    (2000 thru 2000 eq 2000)
    (2001 thru 2001 eq 2001)
    (2002 thru 2002 eq 2002)
    (2003 thru 2003 eq 2003)
    (2004 thru 2004 eq 2004)
    (2005 thru 2005 eq 2005)
    (2006 thru 2006 eq 2006)
    (2007 thru 2007 eq 2007)
    (2008 thru 2008 eq 2008)
    (2009 thru 2009 eq 2009)
    (2010 thru 2010 eq 2010)
    (2011 thru 2011 eq 2011)
    (2012 thru 2012 eq 2012)
    (2013 thru 2013 eq 2013)
    (2014 thru 2014 eq 2014)
    (2015 thru 2015 eq 2015)
    (2016 thru 2016 eq 2016)
    (2017 thru 2017 eq 2017)
    (2018 thru 2018 eq 2018)
    (2019 thru 2019 eq 2019)
    (2020 thru 2020 eq 2020)
    (2021 thru 2021 eq 2021)
.

* value labels
 C0000100
    1 "1 TO 9999999: See Min & Max values below for range as of this release"
    /
 C0000200
    1 "1 TO 12686: NLSY79 Public ID"
    /
 C0005300
    1 "HISPANIC"
    2 "BLACK"
    3 "NON-BLACK, NON-HISPANIC"
    /
 C0005400
    1 "MALE"
    2 "FEMALE"
    /
 C0005700
    1970 "1970 TO 1978: < before 1979"
    1979 "1979"
    1980 "1980"
    1981 "1981"
    1982 "1982"
    1983 "1983"
    1984 "1984"
    1985 "1985"
    1986 "1986"
    1987 "1987"
    1988 "1988"
    1989 "1989"
    1990 "1990"
    1991 "1991"
    1992 "1992"
    1993 "1993"
    1994 "1994"
    1995 "1995"
    1996 "1996"
    1997 "1997"
    1998 "1998"
    1999 "1999"
    2000 "2000"
    2001 "2001"
    2002 "2002"
    2003 "2003"
    2004 "2004"
    2005 "2005"
    2006 "2006"
    2007 "2007"
    2008 "2008"
    2009 "2009"
    2010 "2010"
    2011 "2011"
    2012 "2012"
    2013 "2013"
    2014 "2014"
    2015 "2015"
    2016 "2016"
    2017 "2017"
    2018 "2018"
    2019 "2019"
    2020 "2020"
    2021 "2021"
    /
 Y2267000
    532 "532"
    /
.


/* Crosswalk for Reference number & Question name
 * Uncomment and edit this RENAME VARIABLES statement to rename variables for ease of use.
 * This command does not guarantee uniqueness
 */  /* *start* */

* RENAME VARIABLES
  (C0000100 = CPUBID_XRND)
  (C0000200 = MPUBID_XRND)
  (C0005300 = CRACE_XRND)
  (C0005400 = CSEX_XRND)
  (C0005700 = CYRB_XRND)
  (Y2267000 = VERSION_R29_XRND)
.
  /* *end* */

descriptives all.

*--- Tabulations using reference number variables.
*freq var=C0000100,
  C0000200,
  C0005300,
  C0005400,
  C0005700,
  Y2267000.

*--- Tabulations using qname variables.
*freq var=CPUBID_XRND,
  MPUBID_XRND,
  CRACE_XRND,
  CSEX_XRND,
  CYRB_XRND,
  VERSION_R29_XRND.

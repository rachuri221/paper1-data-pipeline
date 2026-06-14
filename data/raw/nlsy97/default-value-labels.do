

label define vlC0005300 1 "HISPANIC" 2 "BLACK" 3 "NON-BLACK, NON-HISPANIC" 
label values C0005300 vlC0005300

label define vlC0005400 1 "MALE" 2 "FEMALE" 
label values C0005400 vlC0005400

label define vlC0005700 1970 "1970 TO 1978: < before 1979" 1979 "1979" 1980 "1980" 1981 "1981" 1982 "1982" 1983 "1983" 1984 "1984" 1985 "1985" 1986 "1986" 1987 "1987" 1988 "1988" 1989 "1989" 1990 "1990" 1991 "1991" 1992 "1992" 1993 "1993" 1994 "1994" 1995 "1995" 1996 "1996" 1997 "1997" 1998 "1998" 1999 "1999" 2000 "2000" 2001 "2001" 2002 "2002" 2003 "2003" 2004 "2004" 2005 "2005" 2006 "2006" 2007 "2007" 2008 "2008" 2009 "2009" 2010 "2010" 2011 "2011" 2012 "2012" 2013 "2013" 2014 "2014" 2015 "2015" 2016 "2016" 2017 "2017" 2018 "2018" 2019 "2019" 2020 "2020" 2021 "2021" 
label values C0005700 vlC0005700

label define vlY2267000 532 "532" 
label values Y2267000 vlY2267000

/* Crosswalk for Reference number & Question name
 * Uncomment and edit this RENAME statement to rename variables for ease of use.
 * This command does not guarantee uniqueness
 */
  /* *start* */
/*
  rename C0000100 CPUBID_XRND
  rename C0000200 MPUBID_XRND
  rename C0005300 CRACE_XRND
  rename C0005400 CSEX_XRND
  rename C0005700 CYRB_XRND
  rename Y2267000 VERSION_R29_XRND
*/
  /* *end* */

/* To convert variable names to lower case use the TOLOWER command
 *      (type findit tolower and follow the links to install).
 * TOLOWER VARLIST will change listed variables to lower case;
 *  TOLOWER without a specified variable list will convert all variables in the dataset to lower case
 */
/* tolower */

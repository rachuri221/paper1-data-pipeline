options nocenter validvarname=any;

*---Read in space-delimited ascii file;

data new_data;

infile 'default.dat' lrecl=31 missover DSD DLM=' ' print;
input
  C0000100
  C0000200
  C0005300
  C0005400
  C0005700
  Y2267000
;
array nvarlist _numeric_;

*---Recode missing values to SAS custom system missing. See SAS
      documentation for use of MISSING option in procedures, e.g. PROC FREQ;

do over nvarlist;
  if nvarlist = -1 then nvarlist = .R;  /* Refused */
  if nvarlist = -2 then nvarlist = .D;  /* Dont know */
  if nvarlist = -3 then nvarlist = .I;  /* Invalid missing */
  if nvarlist = -7 then nvarlist = .M;  /* Missing */
end;

  label C0000100 = "ID CODE OF CHILD";
  label C0000200 = "ID CODE OF MOTHER OF CHILD";
  label C0005300 = "RACE OF CHILD (FROM MOTHERS SCREENER 79)";
  label C0005400 = "SEX OF CHILD";
  label C0005700 = "DATE OF BIRTH OF CHILD - YEAR";
  label Y2267000 = "VERSION_R29 CHILD/YOUNG ADULT XRND";

/*---------------------------------------------------------------------*
 *  Crosswalk for Reference number & Question name                     *
 *---------------------------------------------------------------------*
 * Uncomment and edit this RENAME statement to rename variables
 * for ease of use.  You may need to use  name literal strings
 * e.g.  'variable-name'n   to create valid SAS variable names, or 
 * alter variables similarly named across years.
 * This command does not guarantee uniqueness

 * See SAS documentation for use of name literals and use of the
 * VALIDVARNAME=ANY option.     
 *---------------------------------------------------------------------*/
  /* *start* */

* RENAME
  C0000100 = 'CPUBID_XRND'n
  C0000200 = 'MPUBID_XRND'n
  C0005300 = 'CRACE_XRND'n
  C0005400 = 'CSEX_XRND'n
  C0005700 = 'CYRB_XRND'n
  Y2267000 = 'VERSION_R29_XRND'n
;
  /* *finish* */
run;

proc means data=new_data n mean min max;
run;

/*---------------------------------------------------------------------*
 *  FORMATTED TABULATIONS                                              *
 *---------------------------------------------------------------------*
 * You can uncomment and edit the PROC FORMAT and PROC FREQ statements 
 * provided below to obtain formatted tabulations. The tabulations 
 * should reflect codebook values.
 * 
 * Please edit the formats below reflect any renaming of the variables
 * you may have done in the first data step. 
 *---------------------------------------------------------------------*/

/*
proc format;
value vx0f
  1-9999999='1 TO 9999999: See Min & Max values below for range as of this release'
;
value vx1f
  1-12686='1 TO 12686: NLSY79 Public ID'
;
value vx2f
  1='HISPANIC'
  2='BLACK'
  3='NON-BLACK, NON-HISPANIC'
;
value vx3f
  1='MALE'
  2='FEMALE'
;
value vx4f
  1970-1978='1970 TO 1978: < before 1979'
  1979='1979'
  1980='1980'
  1981='1981'
  1982='1982'
  1983='1983'
  1984='1984'
  1985='1985'
  1986='1986'
  1987='1987'
  1988='1988'
  1989='1989'
  1990='1990'
  1991='1991'
  1992='1992'
  1993='1993'
  1994='1994'
  1995='1995'
  1996='1996'
  1997='1997'
  1998='1998'
  1999='1999'
  2000='2000'
  2001='2001'
  2002='2002'
  2003='2003'
  2004='2004'
  2005='2005'
  2006='2006'
  2007='2007'
  2008='2008'
  2009='2009'
  2010='2010'
  2011='2011'
  2012='2012'
  2013='2013'
  2014='2014'
  2015='2015'
  2016='2016'
  2017='2017'
  2018='2018'
  2019='2019'
  2020='2020'
  2021='2021'
;
value vx5f
  532='532'
;
*/

/* 
 *--- Tabulations using reference number variables;
proc freq data=new_data;
tables _ALL_ /MISSING;
  format C0000100 vx0f.;
  format C0000200 vx1f.;
  format C0005300 vx2f.;
  format C0005400 vx3f.;
  format C0005700 vx4f.;
  format Y2267000 vx5f.;
run;
*/

/*
*--- Tabulations using default named variables;
proc freq data=new_data;
tables _ALL_ /MISSING;
  format 'CPUBID_XRND'n vx0f.;
  format 'MPUBID_XRND'n vx1f.;
  format 'CRACE_XRND'n vx2f.;
  format 'CSEX_XRND'n vx3f.;
  format 'CYRB_XRND'n vx4f.;
  format 'VERSION_R29_XRND'n vx5f.;
run;
*/
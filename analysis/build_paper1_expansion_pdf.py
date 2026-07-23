"""Generate docs/Paper1_Expansion.pdf — research briefing for the lead researcher
on the proposed causal reframing of Paper 1 (NLSY97 x state financial-education mandates)."""
from reportlab.lib.pagesizes import LETTER
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib.units import inch
from reportlab.lib import colors
from reportlab.lib.enums import TA_JUSTIFY, TA_LEFT
from reportlab.platypus import (SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle,
                                ListFlowable, ListItem, HRFlowable)
from pathlib import Path

OUT = Path(__file__).resolve().parent.parent / "docs" / "Paper1_Expansion.pdf"

NAVY = colors.HexColor("#1F3B63")
BLUE = colors.HexColor("#2E6DA4")
LIGHT = colors.HexColor("#EAF0F7")
GREY = colors.HexColor("#555555")

ss = getSampleStyleSheet()
title = ParagraphStyle("title", parent=ss["Title"], textColor=NAVY, fontSize=24, spaceAfter=4, leading=28)
subtitle = ParagraphStyle("subtitle", parent=ss["Normal"], textColor=BLUE, fontSize=13, spaceAfter=2, leading=16)
meta = ParagraphStyle("meta", parent=ss["Normal"], textColor=GREY, fontSize=9, spaceAfter=2, leading=12)
h1 = ParagraphStyle("h1", parent=ss["Heading1"], textColor=NAVY, fontSize=14, spaceBefore=14, spaceAfter=6, leading=17)
h2 = ParagraphStyle("h2", parent=ss["Heading2"], textColor=BLUE, fontSize=11.5, spaceBefore=8, spaceAfter=3, leading=14)
body = ParagraphStyle("body", parent=ss["BodyText"], fontSize=10, leading=14, alignment=TA_JUSTIFY, spaceAfter=6)
cell = ParagraphStyle("cell", parent=ss["BodyText"], fontSize=8.5, leading=11)
cellb = ParagraphStyle("cellb", parent=cell, textColor=colors.white, fontName="Helvetica-Bold")
bullet = ParagraphStyle("bullet", parent=body, spaceAfter=2)

S = []
def P(t): S.append(Paragraph(t, body))
def H1(t): S.append(Paragraph(t, h1))
def H2(t): S.append(Paragraph(t, h2))
def SP(h=6): S.append(Spacer(1, h))
def BUL(items):
    S.append(ListFlowable([ListItem(Paragraph(t, bullet), leftIndent=12, value="•") for t in items],
                          bulletType="bullet", start="•", leftIndent=10))
    SP(4)
def TBL(header, rows, widths):
    data = [[Paragraph(c, cellb) for c in header]] + [[Paragraph(c, cell) for c in r] for r in rows]
    t = Table(data, colWidths=[w*inch for w in widths], repeatRows=1)
    st = [("BACKGROUND",(0,0),(-1,0),NAVY), ("GRID",(0,0),(-1,-1),0.5,colors.HexColor("#B8C4D6")),
          ("VALIGN",(0,0),(-1,-1),"TOP"), ("TOPPADDING",(0,0),(-1,-1),4), ("BOTTOMPADDING",(0,0),(-1,-1),4),
          ("LEFTPADDING",(0,0),(-1,-1),5), ("RIGHTPADDING",(0,0),(-1,-1),5),
          ("ROWBACKGROUNDS",(0,1),(-1,-1),[colors.white, LIGHT])]
    t.setStyle(TableStyle(st)); S.append(t); SP(8)

# ---------------- Title block ----------------
S.append(Paragraph("Paper 1 &mdash; Expansion", title))
S.append(Paragraph("Reframing to a Causal Design Using Staggered State Financial-Education Mandates", subtitle))
SP(4)
S.append(HRFlowable(width="100%", thickness=1.2, color=BLUE))
SP(4)
S.append(Paragraph("Srivastava Economic Research Lab &mdash; EmpowerED &times; Synthica Research Partnership", meta))
S.append(Paragraph("Prepared by: Paper 1 Data Team &nbsp;|&nbsp; For: Lead Researcher (cc: Lydia, Satvik) &nbsp;|&nbsp; Date: July 23, 2026", meta))
S.append(Paragraph("Status: Proposal for decision &mdash; builds on completed &amp; validated Paper 1 data cleaning", meta))
SP(10)

# ---------------- 1. Executive summary ----------------
H1("1. Executive Summary")
P("Paper 1&rsquo;s data cleaning is complete and has passed independent validation. However, the five "
  "assembled datasets can support only <b>descriptive, correlational</b> analysis &mdash; they cannot "
  "substantiate the paper&rsquo;s central <b>causal</b> claim that financial-literacy education changes young "
  "people&rsquo;s financial behavior. This briefing proposes an expansion that reframes Paper 1 around a "
  "credible causal design: a <b>natural experiment</b> exploiting the fact that U.S. states adopted "
  "high-school financial-education graduation requirements at different times. Using the National "
  "Longitudinal Survey of Youth 1997 (NLSY97) linked to the history of these state &ldquo;mandates,&rdquo; we can "
  "compare cohorts that were required to receive financial education against otherwise-similar cohorts that "
  "were not, and estimate the causal effect on adult saving, credit, and debt behavior. The literature "
  "review already supports this direction. Below: the rationale, the design, a six-package work plan with "
  "effort and ownership, the split between automatable and human-gated tasks, key risks, resource needs, a "
  "realistic timeline, and a low-cost feasibility check recommended <b>before</b> committing resources.")
P("<b>Headline:</b> the active analyst effort is bounded (&asymp; 4&ndash;6 weeks of work), but the overall "
  "calendar (&asymp; 1&ndash;3 months) is driven almost entirely by one external item &mdash; approval for "
  "restricted geographic data &mdash; which is administrative lead time, not analytical effort.")

# ---------------- 2. Why reframe ----------------
H1("2. Why the Current Framing Cannot Answer the Question")
P("The research question is causal: does financial-literacy education <i>change</i> spending, saving, and "
  "credit behavior. Three features of the assembled data block that claim:")
BUL([
 "<b>No treatment variable.</b> None of the five datasets (CFPB, SCF, NFCS 2018/2021, NLSY97) record whether "
 "a respondent actually received financial education. Without knowing who was &ldquo;treated,&rdquo; we can only show "
 "that knowledge <i>correlates</i> with behavior &mdash; not that education <i>caused</i> it.",
 "<b>Population mismatch.</b> The question targets teens 13&ndash;22, but none of the datasets contain anyone "
 "under 18; they are adult surveys. The analysis sample is 18&ndash;24 <i>young adults</i>, not teens.",
 "<b>Non-comparable measures.</b> The same-named composite scores are built from different survey items in "
 "each dataset, so they are not a single construct that can be pooled or compared across sources.",
])
P("<b>Net effect:</b> the cleaned data is well suited to <i>describing</i> how financial knowledge relates to "
  "money behavior among young adults, but it cannot isolate the <i>causal</i> effect of financial education, "
  "which is the paper&rsquo;s stated aim.")

# ---------------- 3. Proposed design ----------------
H1("3. The Proposed Design: A Natural Experiment")
P("<b>The idea in plain terms.</b> To prove education causes a change, we need two otherwise-similar groups "
  "&mdash; one that got financial education and one that did not. Over the years, some states passed laws "
  "requiring a personal-finance or economics course to graduate high school, and different states did so in "
  "different years. Whether a student received this education therefore depended largely on <i>which state "
  "they attended high school in and when</i> &mdash; circumstances outside the individual&rsquo;s control, "
  "approximating a natural &ldquo;coin flip.&rdquo;")
P("<b>How it identifies a causal effect.</b> Because adoption was <b>staggered</b> across states and years, "
  "we can compare the adult financial behavior of cohorts that faced a requirement against comparable "
  "cohorts that did not, using a difference-in-differences / event-study framework (state and cohort fixed "
  "effects, standard errors clustered by state). The staggered timing is what lets us separate the effect of "
  "the mandate from general trends.")
P("<b>Outcomes.</b> We measure adult financial behavior in later NLSY97 rounds &mdash; saving, debt, credit, "
  "and net worth. NLSY97 also fields a financial-literacy assessment at roughly ages 25&ndash;30, which "
  "becomes a legitimate knowledge outcome / mechanism (something the 18&ndash;24 framing had to drop).")
P("<b>Precedent.</b> This is the established approach in the literature (Bernheim, Garrett &amp; Maki 2001; "
  "Brown et al. 2016; Urban et al. 2020), which the Paper 1 lit review already supports &mdash; so the design "
  "is well grounded rather than novel-and-untested.")

# ---------------- 4. Carryover ----------------
H1("4. What Already Exists and Carries Over")
P("This is an <b>extension</b>, not a restart. The following assets transfer directly:")
BUL([
 "The reproducible cleaning pipeline and independent-validation harness.",
 "NLSY97 extract handling &mdash; codebook mapping, age anchoring, NLS missing-code logic, CPI deflation.",
 "The household income-to-poverty (&le;200% FPL) underserved indicator.",
 "Pre-treatment control variables: demographics, education, and the <b>ASVAB</b> ability score (a strong "
 "control for prior aptitude, measured before the mandate exposure).",
])

# ---------------- 5. Work plan ----------------
H1("5. Work Plan")
P("Six work packages. &ldquo;Effort&rdquo; is active analyst time; several packages run in parallel (see the "
  "critical path in Section 8).")
TBL(["#", "Work package &amp; objective", "Est. effort", "Owner", "Depends on"],
    [["WP1","<b>Restricted geographic data.</b> Obtain NLSY97 high-school state &amp; timing (not in the public file).",
      "Low labor;<br/><b>weeks&ndash;months</b> lead","PI / Institution","&mdash;"],
     ["WP2","<b>Mandate database.</b> Compile, by state and year, whether a personal-finance/econ course was "
      "required and the first affected graduating class.","1&ndash;2 weeks","Data team","&mdash;"],
     ["WP3","<b>Treatment assignment.</b> Merge WP1 &amp; WP2 to label each respondent exposed / not exposed.",
      "3&ndash;5 days","Data team","WP1, WP2"],
     ["WP4","<b>Outcome extract &amp; cleaning.</b> Pull &amp; clean later-round adult outcomes (saving, debt, "
      "credit, net worth) + the ~age 25&ndash;30 financial-literacy module.","~1 week","Data team","&mdash;"],
     ["WP5","<b>Causal estimation.</b> Difference-in-differences / event-study; state &amp; cohort fixed "
      "effects; SEs clustered by state.","1&ndash;2 weeks","Lydia","WP3, WP4"],
     ["WP6","<b>Robustness.</b> Pre-trend/event-study plots, placebo tests, staggered-adoption estimators, "
      "few-cluster corrections.","~1 week","Lydia","WP5"]],
    [0.35, 2.85, 1.05, 1.0, 0.95])
H2("Package detail")
BUL([
 "<b>WP1 &mdash;</b> The public NLSY97 hides state of residence to protect privacy. The linkage lives in the "
 "restricted <i>Geocode</i> file, released only under a signed data-security agreement with the survey agency "
 "(institutional sponsor required; possibly IRB). This is the project&rsquo;s gate.",
 "<b>WP2 &mdash;</b> Sources are public and free (Council for Economic Education &ldquo;Survey of the States,&rdquo; plus "
 "coding appendices in the precedent papers). The subtle part is dating: a law&rsquo;s passage year differs from "
 "the first graduating class it actually binds.",
 "<b>WP3 &mdash;</b> Straightforward data work once WP1 &amp; WP2 exist; handle students who moved states and "
 "those who did not finish high school.",
 "<b>WP4 &mdash;</b> A new NLSY97 extract via the survey&rsquo;s download tool, then cleaned with the existing "
 "pipeline. Revives the financial-<i>knowledge</i> outcome via the older-age literacy module.",
 "<b>WP5 &amp; WP6 &mdash;</b> The estimation and the validity checks reviewers will expect; owned by Lydia "
 "with the data team supporting.",
])

# ---------------- 6. Division of labor ----------------
H1("6. Division of Labor: Automatable vs. Human-Gated")
P("Rule of thumb: the AI analyst can do anything that is &ldquo;write code, crunch numbers, or compile public "
  "information&rdquo; &mdash; fast. It <b>cannot</b> do things that require a legal signature, an interactive "
  "personal login, or human research-integrity judgment. Most of the <i>labor</i> is automatable; the "
  "<i>gates</i> are not.")
TBL(["Task", "AI analyst?", "Why"],
    [["Compile public sources; draft the mandate database (WP2)","<b>Yes (draft)</b>","Web/code work &mdash; but must be human-verified against the actual laws"],
     ["Sign the restricted-data application (WP1)","<b>No</b>","A legal agreement an accountable person/institution must sign"],
     ["Download the NLSY97 extract (WP4 pull)","<b>No</b>","The survey&rsquo;s tool needs a personal login &amp; interactive selection"],
     ["Clean/merge/code the data (WP3, WP4-clean)","<b>Yes</b>","Pure scripting &mdash; fast once inputs exist"],
     ["Write &amp; run the estimation code (WP5)","<b>Yes (execution)</b>","But the specification choices are Lydia&rsquo;s to own"],
     ["Verify mandate coding; own the identification decisions","<b>No</b>","Research-integrity judgment that must not be auto-rubber-stamped"]],
    [2.35, 1.05, 3.1])

# ---------------- 7. Risks ----------------
H1("7. Risks &amp; Mitigations")
TBL(["Risk", "Mitigation"],
    [["<b>Thin treatment variation</b> (biggest research risk). Few states had mandates during the NLSY97 "
      "high-school window (~1998&ndash;2003), so too few &ldquo;treated&rdquo; respondents could leave the study underpowered.",
      "Run the Section 9 feasibility check <b>first</b>. If variation is too thin, switch treatment source or pair "
      "NLSY97 with a complementary design (e.g., credit-panel or ACS-based) before committing."],
     ["<b>Restricted-data lead time</b> (WP1). Approval is external calendar time on the critical path.",
      "File immediately; run WP2 and WP4 fully in parallel while waiting."],
     ["<b>Mandate-coding validity.</b> Wrong effective dates would bias the entire result.",
      "Cross-check against published appendices; code passage vs. first-affected cohort explicitly; report sensitivity to alternative codings."],
     ["<b>Staggered-adoption econometrics &amp; few clusters.</b> Naive two-way fixed effects can be biased; "
      "few treated states weaken clustered inference.",
      "Use modern estimators (Callaway &amp; Sant&rsquo;Anna; Sun &amp; Abraham); apply wild-cluster bootstrap for few clusters."],
     ["<b>Migration &amp; attrition.</b> Students move; panels lose people.",
      "Define exposure by high-school state; test robustness on movers; use survey weights and attrition checks."]],
    [2.6, 3.9])

# ---------------- 8. Timeline ----------------
H1("8. Timeline &amp; Critical Path")
BUL([
 "<b>Active analyst effort:</b> &asymp; 4&ndash;6 weeks total (much of it compressible by the AI analyst to days).",
 "<b>Calendar time:</b> &asymp; 1&ndash;3 months &mdash; dominated by WP1 (restricted-data approval), which gates WP3 and WP5.",
 "<b>Parallelization:</b> WP2 (mandate database) and WP4 (outcome extract &amp; cleaning) proceed immediately, "
 "independent of the WP1 approval queue, so no time is lost waiting.",
])
TBL(["Phase", "Runs", "Contents"],
    [["Now (no gates)","Days","Feasibility check (Sec. 9); begin WP2; file WP1 application; begin WP4 pull"],
     ["While WP1 pending","Weeks&ndash;months","Finish WP2 (verified) and WP4 (cleaned); pre-register the design"],
     ["After WP1 approved","~2&ndash;3 weeks","WP3 merge &rarr; WP5 estimation &rarr; WP6 robustness"],
     ["Write-up","Ongoing","Results into the Paper 1 draft alongside the lit review"]],
    [1.5, 1.4, 3.6])

# ---------------- 9. Feasibility ----------------
H1("9. Recommended Immediate Next Step: Feasibility Pre-Check")
P("Before anyone files for restricted data, run a half-day, no-gates check: draft the mandate database (WP2) "
  "from public sources and estimate how many states had a financial-education requirement in effect during "
  "the NLSY97 high-school window (~1998&ndash;2003), and thus roughly what share of respondents would be "
  "&ldquo;treated.&rdquo; If that share is healthy, green-light WP1. If only a few states qualify, the study would be "
  "underpowered &mdash; and it is far better to learn that in half a day than after a multi-month data-access "
  "application. This single step de-risks the entire go/no-go decision.")

# ---------------- 10. Decision requested ----------------
H1("10. Decision Requested from the Lead")
BUL([
 "<b>(a)</b> Approve the half-day feasibility pre-check (Section 9)?",
 "<b>(b)</b> Identify an institutional sponsor able to file and sign the restricted-data (Geocode) application (WP1).",
 "<b>(c)</b> Confirm Lydia&rsquo;s availability for the estimation phase (WP5&ndash;WP6).",
 "<b>(d)</b> Confirm the outcome set and age window for the adult-outcome extract (WP4).",
])

# ---------------- Appendix ----------------
H1("Appendix &mdash; Key References &amp; Data Sources")
BUL([
 "Bernheim, Garrett &amp; Maki (2001), &ldquo;Education and saving: The long-term effects of high school financial "
 "curriculum mandates,&rdquo; <i>Journal of Public Economics</i>.",
 "Brown, Grigsby, van der Klaauw, Wen &amp; Zafar (2016), &ldquo;Financial Education and the Debt Behavior of the "
 "Young,&rdquo; <i>Review of Financial Studies</i>.",
 "Urban, Schmeiser, Collins &amp; Brown (2020), on the effects of state financial-education mandates.",
 "Council for Economic Education, <i>Survey of the States</i> (biennial) &mdash; mandate tracking source.",
 "Callaway &amp; Sant&rsquo;Anna (2021); Sun &amp; Abraham (2021); Goodman-Bacon (2021) &mdash; staggered "
 "difference-in-differences methods.",
 "NLSY97 <i>Geocode</i> (restricted-access) &mdash; U.S. Bureau of Labor Statistics / NLS program.",
])
SP(6)
S.append(HRFlowable(width="100%", thickness=0.8, color=BLUE))
S.append(Paragraph("Companion repository documents: docs/cleaning_log.md, docs/variable_dictionary_paper1.md, "
                   "docs/analysis_decisions.md, docs/validation_report_paper1.md.", meta))

doc = SimpleDocTemplate(str(OUT), pagesize=LETTER, topMargin=0.7*inch, bottomMargin=0.7*inch,
                        leftMargin=0.85*inch, rightMargin=0.85*inch, title="Paper 1 Expansion",
                        author="Paper 1 Data Team")
doc.build(S)
print("wrote", OUT)

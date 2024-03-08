
*==============================================================================*
*------------------------------------------------------------------------------*
* ELA Tanzania
* Table 3: Savings and Credit
*------------------------------------------------------------------------------*
*==============================================================================*

clear all
set more off

*==============================================================================*

* Load data
use "$data\ELA Tanzania Panel.dta", clear
* Set panel data
xtset id survey

*==============================================================================*

* Define globals
global Financial Fsavings lnsavings F_savingshomeyn F_savingsupatuyn F_savingsNGOyn F_savingsbankyn F_loan lnloan

global outopts dec(3) pdec(3) adec(3) label nocons keep(treatmentXfollowup followup)

*==============================================================================*
*==============================================================================*

/*
	*** Table 3A: ELA impact on financial market participation
	Outcomes:
	** Savings
	* Any (0/1)
	* Amount (ln)
	* At home (0/1)
	* At ROSCA (0/1)
	* At NGO (0/1)
	* At bank (0/1)
	** Loans
	* Any (0/1)
	* Amount (ln)
	
	ITT estimation 
	Coefficient of interest: treatmentXfollowup
	Standard errors clustered by village
*/

foreach var of global Financial {
	* Mean control group (baseline)
	qui su `var' if treatment == 0 & followup == 0
	local mean_control_baseline = r(mean) 
	
	* Mean control group (follow-up)
	qui su `var' if treatment == 0 & followup == 1
	local mean_control_followup = r(mean) 
	
	* Regression
	qui xtreg `var' followup treatmentXfollowup, fe cluster(villid)
	
	* Output
	outreg2 using "$output\Table_3_Financial.tex", append $outopts addstat(Control group mean baseline, `mean_control_baseline', Control group mean follow-up,`mean_control_followup') nonotes nor2
}

cap erase "$output\Table_3_Financial.txt"



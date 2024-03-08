
*==============================================================================*
*------------------------------------------------------------------------------*
* ELA Tanzania
* Table S5: Savings and Credit
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

global outopts dec(3) pdec(3) adec(3) label nocons nor2 nonotes keep(treatment_clubXfollowup treatment_MFXfollowup)

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
	Coefficients of interest: treatment_clubXfollowup; treatment_MFXfollowup
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
	qui xtreg `var' followup treatment_clubXfollowup treatment_MFXfollowup, fe cluster(villid)
	
	* Test interaction terms for equality
	qui test treatment_clubXfollowup=treatment_MFXfollowup
	local pval = r(p)
	qui xtreg `var' followup treatment_clubXfollowup treatment_MFXfollowup, fe cluster(villid)	
	
	* Output
	outreg2 using "$output\Table_S5_Financial.tex", append $outopts addstat(T1 vs. T2 p-value,`pval',Control group mean baseline, `mean_control_baseline', Control group mean follow-up,`mean_control_followup')
}

cap erase "$output\Table_S5_Financial.txt"



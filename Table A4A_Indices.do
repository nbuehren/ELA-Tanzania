
*==============================================================================*
*------------------------------------------------------------------------------*
* ELA Tanzania
* Table A4A: Robustness - Indices (Multiple hypothesis testing)
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

global Indices z_econ_index z_financial_index z_reproductive_index z_empower_index

global outopts dec(3) pdec(3) adec(3) label nocons nonotes nor2 keep(treatmentXfollowup followup)

*==============================================================================*

/*
	*** Table A4A: ELA impact -- Robustness: Indices
	Outcomes:
	* Economic index (z-score)
	* Financial index (z-score)
	* Reproductive (z-score)
	* Empowerment (z-score)
	
	ITT estimation 
	Coefficient of interest: treatmentXfollowup
	Standard errors clustered by village
*/

foreach var of global Indices {
    * Mean control group (baseline)
	qui su `var' if treatment == 0 & followup == 0
	local mean_control_baseline = r(mean) 
	
	* Mean control group (follow-up)
	qui su `var' if treatment == 0 & followup == 1
	local mean_control_followup = r(mean) 
	
	* Regression
	qui xtreg `var' followup treatmentXfollowup, fe cluster(villid)

	* Output
	outreg2 using "$output\Table_A4A_Indices.tex", append $outopts addstat(Control group mean baseline, `mean_control_baseline', Control group mean follow-up,`mean_control_followup') 
}
cap erase "$output\Table_A4A_Indices.txt"

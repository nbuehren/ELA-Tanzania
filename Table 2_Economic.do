
*==============================================================================*
*------------------------------------------------------------------------------*
* ELA Tanzania
* Table 2: Economic Empowerment Outcomes
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
global Economic any_iga any_daily_earn income IGAF_yes Kfinance_skil 

global outopts dec(3) pdec(3) adec(3) label nocons nor2 nonotes keep(treatmentXfollowup followup)

*==============================================================================*
*==============================================================================*

/*
	*** Table 2: ELA impact on economic outcomes
	Outcomes:
	* Any IGA (0/1)
	* Daily income (0/1)
	* Income (ln)
	* Plan new IGA (0/1)
	* Financial skills (0-4)
	
	ITT estimation 
	Coefficients of interest: treatmentXfollowup
	Standard errors clustered by village
*/

foreach var of global Economic {
	* Mean control group (baseline)
	qui su `var' if treatment == 0 & followup == 0
	local mean_control_baseline = r(mean) 
	
	* Mean control group (follow-up)
	qui su `var' if treatment == 0 & followup == 1
	local mean_control_followup = r(mean) 
	
	* Regression
	qui xtreg `var' followup treatmentXfollowup, fe cluster(villid)

	* Output
	outreg2 using "$output\Table_2_Economic.tex", append $outopts addstat(Control group mean baseline, `mean_control_baseline', Control group mean follow-up,`mean_control_followup') 
}

cap erase "$output\Table_2_Economic.txt" 


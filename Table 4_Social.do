
*==============================================================================*
*------------------------------------------------------------------------------*
* ELA Tanzania
* Table 4: Reproductive Health and Empowerment
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
global Reproductive R_sexever always_condom R_stdever R_sexunwilling M_Devermarried M_children
global Empowerment E_Denrolled Rhiv_skills M_idealmarry_ageF M_idealbaby_no empowerment Attitude_total

global outopts dec(3) pdec(3) adec(3) label nocons keep(treatmentXfollowup followup)

*==============================================================================*
*==============================================================================*

/*
	*** Table 4A: ELA impact on reproductive health, social, and empowerment outcomes
	Outcomes:
	* Ever sex (0/1)
	* Always condom (0/1)
	* Ever STD (0/1)
	* Ever unwilling sex (0/1)
	* Ever married (0/1)
	* Children (0/1)
	
	ITT estimation 
	Coefficient of interest: treatmentXfollowup
	Standard errors clustered by village
*/

foreach var of global Reproductive {
	* Mean control group (baseline)
	qui su `var' if treatment == 0 & followup == 0
	local mean_control_baseline = r(mean) 
	
	* Mean control group (follow-up)
	qui su `var' if treatment == 0 & followup == 1
	local mean_control_followup = r(mean) 
	
	* Regression
	qui xtreg `var' followup treatmentXfollowup, fe cluster(villid)

	* Output
	outreg2 using "$output\Table_4A_Reproductive.tex", append $outopts addstat(Control group mean baseline, `mean_control_baseline', Control group mean follow-up,`mean_control_followup') nonotes nor2	
}
cap erase "$output\Table_4A_Reproductive.txt"

*==============================================================================*

/*
	*** Table 4B: ELA impact on reproductive health, social, and empowerment outcomes
	Outcomes:
	* Enrolled (0/1)
	* HIV knowledge (0-5)
	* Ideal marital age (years)
	* Ideal nb children (#)
	* Gender roles (0-100)
	* Control over life (0-100)
	
	ITT estimation 
	Coefficient of interest: treatmentXfollowup
	Standard errors clustered by village
*/

foreach var of global Empowerment {
	* Mean control group (baseline)
	qui su `var' if treatment == 0 & followup == 0
	local mean_control_baseline = r(mean) 
	
	* Mean control group (follow-up)
	qui su `var' if treatment == 0 & followup == 1
	local mean_control_followup = r(mean) 	
	
	* Regression
	qui xtreg `var' followup treatmentXfollowup, fe cluster(villid)

	* Output
	outreg2 using "$output\Table_4B_Empowerment.tex", append $outopts addstat(Control group mean baseline, `mean_control_baseline', Control group mean follow-up,`mean_control_followup') nonotes nor2
}
cap erase "$output\Table_4B_Empowerment.txt"



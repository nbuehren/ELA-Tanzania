
*==============================================================================*
*------------------------------------------------------------------------------*
* ELA Tanzania
* Table A1: Balance Baseline
*------------------------------------------------------------------------------*
*==============================================================================*

clear all
clear matrix

*==============================================================================*

* Load data
use "$data\ELA Tanzania Panel.dta", clear

*==============================================================================*

** Define globals
global Balance_Baseline young E_Denrolled M_Devermarried M_children any_iga any_daily_earn A_worrymoneyD R_sexever always_condom Rhiv_skills R_stdever R_sexunwilling

*==============================================================================*

*** Summary Stats

log using "$output\Table_A1_Balance_Stats.log", replace

** by treatment group
tabstat young E_Denrolled M_Devermarried M_children any_iga any_daily_earn A_worrymoneyD R_sexever always_condom Rhiv_skills R_stdever R_sexunwilling if survey==0, by(treatment) statistics(mean sd N) 

log close

*==============================================================================*

*** Balance table
* T vs. C
foreach var of global Balance_Baseline {
	xi: qui reg `var' treatment if survey==0, cluster(villid)
	outreg2 using "$output\Table_A1_Balance.tex", append dec(3) pdec(3) label nocons keep(treatment) nor2 nonotes
}
cap erase "$output\Table_A1_Balance.txt"

*==============================================================================*

** Normalized differences

foreach var of global Balance_Baseline {

	** Mean, SD, and N of T;
	qui sum `var' if treatment == 1 & survey == 0
	local mean_t_`var' = r(mean)
	local sd_t_`var' = r(sd)
	local Var_t_`var' = r(Var)
	local N_t_`var' = r(N)

	** Mean, SD, and N of C;
	qui sum `var' if treatment == 0 & survey == 0
	local mean_c_`var' = r(mean)
	local sd_c_`var' = r(sd)
	local Var_c_`var' = r(Var)
	local N_c_`var' = r(N)

	
	** Normalized difference;
	gen nd_`var' = (`mean_t_`var''-`mean_c_`var'')/(sqrt(`Var_t_`var''+`Var_c_`var''))
			
}

log using "$output\Table_A1_Balance_Stats.log", append

tabstat nd_young nd_E_Denrolled nd_M_Devermarried nd_M_children nd_any_iga nd_any_daily_earn nd_A_worrymoneyD nd_R_sexever nd_always_condom nd_Rhiv_skills nd_R_stdever nd_R_sexunwilling if survey==0, statistics(mean) 

log close


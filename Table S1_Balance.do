
*==============================================================================*
*------------------------------------------------------------------------------*
* ELA Tanzania
* Table S1: Balance Baseline
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

log using "$output\Table_S1_Balance_Stats.log", replace

** by treatment group
tabstat young E_Denrolled M_Devermarried M_children any_iga any_daily_earn A_worrymoneyD R_sexever always_condom Rhiv_skills R_stdever R_sexunwilling if survey==0, by(group) statistics(mean sd N) 

log close

*==============================================================================*

*** Balance table
* T1 vs. C and T2 vs. C
foreach var of global Balance_Baseline {
	xi: qui reg `var' treatment_club treatment_MF if survey==0, cluster(villid)
	outreg2 using "$output\Table_S1_Balance.tex", append dec(3) pdec(3) label nocons keep(treatment_club treatment_MF) nor2
}
cap erase "$output\Table_S1_Balance.txt"

*==============================================================================*

** Normalized differences

foreach var of global Balance_Baseline {

	** Mean, SD, and N of T1;
	qui sum `var' if treatment_club == 1 & survey == 0
	local mean_t1_`var' = r(mean)
	local sd_t1_`var' = r(sd)
	local Var_t1_`var' = r(Var)
	local N_t1_`var' = r(N)

	** Mean, SD, and N of C;
	qui sum `var' if control_group == 1 & survey == 0
	local mean_c_`var' = r(mean)
	local sd_c_`var' = r(sd)
	local Var_c_`var' = r(Var)
	local N_c_`var' = r(N)

	
	** Normalized difference;
	gen nd1_`var' = (`mean_t1_`var''-`mean_c_`var'')/(sqrt(`Var_t1_`var''+`Var_c_`var''))
		
	** Mean, SD, and N of T2;
	qui sum `var' if treatment_MF == 1 & survey == 0
	local mean_t2_`var' = r(mean)
	local sd_t2_`var' = r(sd)
	local Var_t2_`var' = r(Var)
	local N_t2_`var' = r(N)
	
	** Normalized difference;
	gen nd2_`var' = (`mean_t2_`var''-`mean_c_`var'')/(sqrt(`Var_t2_`var''+`Var_c_`var''))
	
}

log using "$output\Table_S1_Balance_Stats.log", append

tabstat nd1_young nd2_young nd1_E_Denrolled nd2_E_Denrolled nd1_M_Devermarried nd2_M_Devermarried nd1_M_children nd2_M_children nd1_any_iga nd2_any_iga nd1_any_daily_earn nd2_any_daily_earn nd1_A_worrymoneyD nd2_A_worrymoneyD nd1_R_sexever nd2_R_sexever nd1_always_condom nd2_always_condom nd1_Rhiv_skills nd2_Rhiv_skills nd1_R_stdever nd2_R_stdever nd1_R_sexunwilling nd2_R_sexunwilling if survey==0, statistics(mean) 

log close


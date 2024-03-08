
*==============================================================================*
*------------------------------------------------------------------------------*
* ELA Tanzania
* Table A2: Attrition
*------------------------------------------------------------------------------*
*==============================================================================*

clear all
set more off

*==============================================================================*

* Load data
use "$data\ELA Tanzania Attrition.dta", clear
count

*==============================================================================*

** Define globals
global Controls young E_Denrolled M_Devermarried M_children any_iga any_daily_earn A_worrymoneyD R_sexever Rhiv_skills R_stdever R_sexunwilling

global Interactions young_T E_Denrolled_T M_Devermarried_T M_children_T any_iga_T any_daily_earn_T A_worrymoneyD_T R_sexever_T Rhiv_skills_T R_stdever_T R_sexunwilling_T 

global outopts dec(3) pdec(3) adec(3) label nocons sideway nor2 nonotes

*==============================================================================*
*==============================================================================*

** Only treatment indicator
su attrition 
local mean_dep = r(mean)
xi: qui reg attrition treatment i.branchno, cluster(villid) 
outreg2 using "$output\Table_A2_Attrition.tex", replace $outopts addstat(Mean dep. var,`mean_dep') keep(treatment)

** Treatment indicator + controls
su attrition 
local mean_dep = r(mean)
xi: qui reg attrition treatment $Controls m_* i.branchno, cluster(villid) 
test $Controls
local pvalue = r(p)
outreg2 using "$output\Table_A2_Attrition.tex", append $outopts addstat(Mean dep. var,`mean_dep',p-value Characteristics,`pvalue') keep(treatment $Controls)

** Treatment indicator + controls + interaction terms
su attrition 
local mean_dep = r(mean)
xi: qui reg attrition treatment $Controls m_* $Interactions i.branchno, cluster(villid) 
test $Controls
local pvalue = r(p)
test $Interactions
local pvalue1 = r(p)
outreg2 using "$output\Table_A2_Attrition.tex", append $outopts addstat(Mean dep. var,`mean_dep',p-value Characteristics,`pvalue',p-value Interactions,`pvalue1') keep(treatment $Controls $Interactions)

cap erase "$output\Table_A2_Attrition.txt"


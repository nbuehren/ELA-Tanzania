
*==============================================================================*
*------------------------------------------------------------------------------*
* ELA Tanzania
* Table S2: Attrition
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

global Interactions1 young_T1 E_Denrolled_T1 M_Devermarried_T1 M_children_T1 any_iga_T1 any_daily_earn_T1 A_worrymoneyD_T1 R_sexever_T1 Rhiv_skills_T1 R_stdever_T1 R_sexunwilling_T1 

global Interactions2 young_T2 E_Denrolled_T2 M_Devermarried_T2 M_children_T2 any_iga_T2 any_daily_earn_T2 A_worrymoneyD_T2 R_sexever_T2 Rhiv_skills_T2 R_stdever_T2 R_sexunwilling_T2

global outops dec(3) pdec(3) adec(3) label nocons sideway nor2

*==============================================================================*
*==============================================================================*

** Only treatment indicators
su attrition 
local mean_dep = r(mean)
xi: qui reg attrition treatment_club treatment_MF i.branchno, cluster(villid) 
outreg2 using "$output\Table_S2_Attrition.tex", replace addstat(Mean dep. var,`mean_dep') keep(treatment_club treatment_MF) $outops

** Treatment indicators + controls
su attrition 
local mean_dep = r(mean)
xi: qui reg attrition treatment_club treatment_MF $Controls i.branchno, cluster(villid) 
test $Controls
local pvalue = r(p)
outreg2 using "$output\Table_S2_Attrition.tex", append addstat(Mean dep. var,`mean_dep',p-value Characteristics,`pvalue') keep(treatment_club treatment_MF $Controls) $outops

** Treatment indicators + controls + interaction terms
su attrition 
local mean_dep = r(mean)
xi: qui reg attrition treatment_club treatment_MF $Controls $Interactions1 $Interactions2 i.branchno, cluster(villid) 
test $Controls
local pvalue = r(p)
test $Interactions1
local pvalue1 = r(p)
test $Interactions2
local pvalue2 = r(p)
outreg2 using "$output\Table_S2_Attrition.tex", append addstat(Mean dep. var,`mean_dep',p-value Characteristics,`pvalue',p-value Interactions1,`pvalue1',p-value Interactions2,`pvalue2') keep(treatment_club treatment_MF $Controls $Interactions1 $Interactions2) $outops

cap erase "$output\Table_S2_Attrition.txt"


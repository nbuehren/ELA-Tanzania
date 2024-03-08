
*==============================================================================*
*------------------------------------------------------------------------------*
* ELA Tanzania
* Table A3: Selection
*------------------------------------------------------------------------------*
*==============================================================================*

clear all
set more off

*==============================================================================*

* Load data
use "$data\ELA Tanzania Panel.dta", clear

*==============================================================================*

** Define globals
global Controls young E_Denrolled M_Devermarried M_children any_iga any_daily_earn A_worrymoneyD R_sexever Rhiv_skills R_stdever R_sexunwilling

global Interactions young_T E_Denrolled_T M_Devermarried_T M_children_T any_iga_T any_daily_earn_T A_worrymoneyD_T R_sexever_T Rhiv_skills_T R_stdever_T R_sexunwilling_T 

global outopts dec(3) pdec(3) label nocons sideway nor2 nonotes

*==============================================================================*

** Treatment assignment; Branch dummies
xi: qui reg clubmember treatment i.branchno m_* if survey==0, cluster(villid)
outreg2 using "$output\Table_A3_Selection.tex", append $outopts keep(treatment)

** Treatment assignment; Branch dummies; Adolescent characteristics
xi: qui reg clubmember treatment $Controls i.branchno m_* if survey==0, cluster(villid)
test  $Controls
local pvalue = r(p)
outreg2 using "$output\Table_A3_Selection.tex", append $outopts keep(treatment $Controls) addstat(p-value for characteristics,`pvalue') adec(3)

** Treatment assignment; Branch dummies; Adolescent characteristics; Interactions
xi: qui reg clubmember treatment $Controls $Interactions i.branchno m_* if survey==0, cluster(villid)
test  $Controls
local pvalue = r(p)
test $Interactions
local pvalue1 = r(p)
outreg2 using "$output\Table_A3_Selection.tex", append $outopts keep(treatment $Controls $Interactions) addstat(p-value for characteristics,`pvalue',p-value for treatment interactions ,`pvalue1') adec(3)

cap erase "$output\Table_A3_Selection.txt"


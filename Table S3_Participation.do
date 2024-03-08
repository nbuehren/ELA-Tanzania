
*==============================================================================*
*------------------------------------------------------------------------------*
* ELA Tanzania
* Table 1: Participation in ELA
*------------------------------------------------------------------------------*
*==============================================================================*

clear all
clear matrix

*==============================================================================*

* Load data
use "$data\ELA Tanzania Panel.dta", clear
* Set panel data
xtset id survey

global outopts dec(3) pdec(3) label nocons nor2 keep(treatment_club treatment_MF)

*==============================================================================*
*==============================================================================*

log using "$output\Table_S3_Participation.log", replace

/*
	*** Table 1: Participation in ELA intervention
	Outcomes:
	* Heard about ELA (0/1)
	* Ever participated (0/1)
	* Ever participated (if heard) (0/1)
	* Member of ELA microfinance (0/1)
	* Joined in last 6 months (0/1)
	* Currently participating (0/1)
	
	ITT estimation 
	Standard errors clustered by village
*/

*** Means by group
tabstat know_ela clubmember mfmember clubstart stillgo if survey==0, by(group)
tabstat clubmember if survey==0 & know_ela == 1, by(group)

log close

*** Differences by group
** Heard about ELA (0/1)
* T1 - C and T2 - C
xi: qui reg know_ela treatment_club treatment_MF i.branchno  if survey==0, cluster(villid) 
outreg2 using "$output\Table_S3_Participation.tex", replace $outopts
* T2 - T1
xi: qui reg know_ela treatment_MF i.branchno if survey==0 & control_group==0, cluster(villid) 
outreg2 using "$output\Table_S3_Participation.tex", append $outopts

** Ever participated (0/1)
* T1 - C and T2 - C
xi: qui reg clubmember treatment_club treatment_MF i.branchno if survey==0, cluster(villid) 
outreg2 using "$output\Table_S3_Participation.tex", append $outopts
* T2 - T1
xi: qui reg clubmember treatment_MF i.branchno if survey==0 & control_group==0, cluster(villid) 
outreg2 using "$output\Table_S3_Participation.tex", append $outopts

** Ever participated, if heard about ELA (0/1)
* T1 - C and T2 - C
xi: qui reg clubmember treatment_club treatment_MF i.branchno if survey==0 & know_ela == 1, cluster(villid) 
outreg2 using "$output\Table_S3_Participation.tex", append $outopts
* T2 - T1
xi: qui reg clubmember treatment_MF i.branchno if survey==0 & control_group==0 & know_ela == 1, cluster(villid) 
outreg2 using "$output\Table_S3_Participation.tex", append $outopts

** Member of ELA microfinance (0/1)
* T1 - C and T2 - C
xi: qui reg mfmember treatment_club treatment_MF i.branchno if survey==0, cluster(villid) 
outreg2 using "$output\Table_S3_Participation.tex", append $outopts
* T2 - T1
xi: qui reg mfmember treatment_MF i.branchno if survey==0 & control_group==0, cluster(villid) 
outreg2 using "$output\Table_S3_Participation.tex", append $outopts

** Joined in last 6 months (0/1)
* T1 - C and T2 - C
xi: qui reg clubstart treatment_club treatment_MF i.branchno if survey==0, cluster(villid) 
outreg2 using "$output\Table_S3_Participation.tex", append $outopts
* T2 - T1
xi: qui reg clubstart treatment_MF i.branchno if survey==0 & control_group==0, cluster(villid) 
outreg2 using "$output\Table_S3_Participation.tex", append $outopts

** Currently participating (0/1)
* T1 - C and T2 - C
xi: qui reg stillgo treatment_club treatment_MF i.branchno if survey==0, cluster(villid) 
outreg2 using "$output\Table_S3_Participation.tex", append $outopts
* T2 - T1
xi: qui reg stillgo treatment_MF i.branchno if survey==0 & control_group==0, cluster(villid) 
outreg2 using "$output\Table_S3_Participation.tex", append $outopts

cap erase "$output\Table_S3_Participation.txt"

*==============================================================================*

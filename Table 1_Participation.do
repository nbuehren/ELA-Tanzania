
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

global output_options dec(3) pdec(3) label nocons keep(treatment) nor2 nonotes

*==============================================================================*
*==============================================================================*

log using "$output\Table1_Participation.log", replace

/*
	*** Table 1: Participation in ELA intervention
	Outcomes:
	* Heard about ELA (0/1)
	* Ever participated (0/1)
	* Ever participated (if heard) (0/1)
	* Joined in last 6 months (0/1)
	* Currently participating (0/1)
	
	ITT estimation 
	Standard errors clustered by village
*/

*** Means by group
tabstat know_ela clubmember clubstart stillgo if survey==0, by(treatment)
tabstat clubmember if survey==0 & know_ela == 1, by(treatment)

log close

*** Treatment - Control differences
** Heard about ELA (0/1)
xi: qui reg know_ela treatment i.branchno  if survey==0, cluster(villid) 
outreg2 using "$output\Table_1_Participation.tex", replace $output_options

** Ever participated (0/1)
xi: qui reg clubmember treatment i.branchno if survey==0, cluster(villid) 
outreg2 using "$output\Table_1_Participation.tex", append $output_options

** Ever participated, if heard about ELA (0/1)
xi: qui reg clubmember treatment i.branchno if survey==0 & know_ela == 1, cluster(villid) 
outreg2 using "$output\Table_1_Participation.tex", append $output_options

** Joined in last 6 months (0/1)
xi: qui reg clubstart treatment i.branchno if survey==0, cluster(villid) 
outreg2 using "$output\Table_1_Participation.tex", append $output_options

** Currently participating (0/1)
xi: qui reg stillgo treatment i.branchno if survey==0, cluster(villid) 
outreg2 using "$output\Table_1_Participation.tex", append $output_options


cap erase "$output\Table_1_Participation.txt"

*==============================================================================*

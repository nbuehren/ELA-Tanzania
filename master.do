* ===============================================================
* Master do-file for 
	* "What Can We Learn from No Impact? 
	*  BRAC's Empowerment and Livelihood for Adolescents Programme in Tanzania" 
* ===============================================================

	* * * Switchboard
	local run 				= 1
	local installpackages 	= 0
	
	* * * Path Tree 
	* Folder
	global path 			= "C:\Users\Isabelle\Dropbox\BRAC_Tanzania\Replication Files\JDS Revision" // SET THIS TO WHERE YOU DOWNLOADED THE ELA FOLDER
	* Data
	global data 			= "$path\01_Data"
	* Code
	global code 			= "$path\02_Code"
	* Output
	global output     		= "$path\03_Output"

	* * * Packages
	if `installpackages'==1{
		ssc install dataout, replace
		ssc install sxpose, replace
		ssc install outreg2, replace
		ssc install estout, replace
	}
	
	
	* * * Run data
	if `run'==1{
		include "$code\Table 1_Participation.do"
		include "$code\Table 2_Economic.do"
		include "$code\Table 3_Financial.do"
		include "$code\Table 4_Social.do"
		include "$code\Table A1_Balance.do"
		include "$code\Table A2_Attrition.do"
		include "$code\Table A3_Selection.do"
		include "$code\Table A4A_Indices.do"
		include "$code\Table A4B_IPW.do"
		include "$code\Table S1_Balance.do"
		include "$code\Table S2_Attrition.do"
		include "$code\Table S3_Participation.do"
		include "$code\Table S4_Economic.do"
		include "$code\Table S5_Financial.do"
		include "$code\Table S6_Social.do"
	}


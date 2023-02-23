# This script requires being run as an administrator
#Requires -RunAsAdministrator

# Debloat some optional Windows features based on their IDs

# Set the default path of the bloatware list file

# Clear the screen
Clear-Host

[String] $sBloatWareFilePath = "..\data\bloat_opfs.list"
If ( Test-Path -Path "$sBloatWareFilePath" -PathType Leaf ) {
	Write-Host "List of bloatwares found!"
	[String[]] $aBloatwareList = Get-Content -Path "$sBloatWareFilePath"
	
	# Iterate over the list of bloatwares
	ForEach ( $sBloatID in $aBloatwareList ) {		
		# Disable the feature
		Disable-WindowsOptionalFeature -Online -FeatureName "${sBloatID}" -NoRestart
		Write-Host "Disabled: ${sBloatID}"
	}

	# Prompt the user if they want to restart their machine
	[String] $sRPromptTitle    = 'Restart Recommended'
	[String] $sRPromptQuestion = 'It is strongly recommended that you restart your computer now. Do you want to restart?'
	[String[]] $sRPromptChoices  = '&Yes', '&No'
	
	# Present the prompt
	$sRUserDecision = $Host.UI.PromptForChoice($sRPromptTitle, $sRPromptQuestion, $sRPromptChoices, 0)
	
	# Choice = 'No'/Default
	If ($sRUserDecision -eq 0) {

		# Clear the screen
		Clear-Host

		# Ask the user to save and close their work and confirm on the restart
		Write-Host 'Please save and close your work to prevent data loss!'
		Write-Host "After you've saved your work, confirm [Yes] on the prompt below - "
		Restart-Computer -Confirm
	}
	Else {
		Write-Host 'Skipping Restart!'
		Write-Host 'Done!'
    		Write-Host 'Please ensure you restart your machine as soon as possible to avoid any issues!'
		Exit 0
	}
}
Else {
	Write-Host "Bloatware file list not found!"
	Exit 1
}

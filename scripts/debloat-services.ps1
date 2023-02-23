# Require the script to be run as administrator
#Requires -RunAsAdministrator

# Stop certain services & their automatic startup based on the service IDs

# Clear the screen
Clear-Host

# Set the default path of the file containing the list of service IDs
[String] $sBloatWareFilePath = "..\data\bloat_svcs.list"

Write-Host "Bloatwares are defined in: $sBloatWareFilePath"
If ( Test-Path -Path "$sBloatWareFilePath" -PathType Leaf ) {

	# Define an array of strings to store the IDs of various services
	[String[]] $aBloatwareList = Get-Content -Path "$sBloatWareFilePath"
	
	# Iterate over the list of service IDs
	ForEach ( $sBloatID in $aBloatwareList ) {		
		
		# Check if the service is running
		If ( $(Get-Service -Name "$sBloatID" | Select-Object -Property Status | ForEach-Object { $_.Status } ) -eq "Running" )
		{
			Write-Host "Service Running: $sBloatID"
			Write-Host "Stopping Service: $sBloatID"
			Set-Service -Name "$sBloatID" -Status "Stopped"
		}

		# Check if the service has auto start enabled
		If ( $(Get-Service -Name "$sBloatID" | Select-Object -Property StartType | ForEach-Object { $_.StartType } ) -ne "Disabled" ) {
			
			Write-Host "Automatic Startup Enabled: $sBloatID"
			Write-Host "Disabling Automatic Startup: $sBloatID"
		}
	}
	
	Exit 0
}
Else {
	Write-Host "Bloatware file list not found!"
	Exit 1
}

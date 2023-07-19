function Connect-Exo {
	# Checks that EXO v2 module is installed. If not prompt for install. Then connects/prompts for AAD credentials.
	$module = Get-Module ExchangeOnlineManagement -ListAvailable
	if ($module.count -eq 0) {
		Write-Host Exchange Online PowerShell V2 module is not available  -ForegroundColor yellow  
		$confirm = Read-Host Are you sure you want to install module? [Y] Yes [N] No 
		if ($confirm -match "[yY]") {
			Write-host "Installing Exchange Online PowerShell module"
			Install-Module ExchangeOnlineManagement -Repository PSGallery -AllowClobber -Force
			Import-Module ExchangeOnlineManagement
		}
		else { 
			Write-Host "EXO V2 module is required to connect Exchange Online. Please install module using Install-Module ExchangeOnlineManagement cmdlet."
			exit
		}
	}
	
	Connect-ExchangeOnline -ShowBanner:$false
}

Write-Host -NoNewline "Establishing connection to Exchange Online..."
Connect-Exo
Write-Host "done.`n"

# Load all emails into an array
Write-Host -NoNewline "Downloading raw data from Exchange Online..."
$O365Data = Get-Recipient -ResultSize Unlimited -RecipientTypeDetails 'UserMailbox'
Write-Host "done.`n"

$UPNs = @()

# Cycle through each user for their UPN
foreach ($user in $O365Data) {
	$userUPN = $user.primarysmtpaddress
	$UPNs += $userUPN.ToLower() -replace "`n","" -replace "`r",""
}

# Disconnect Exchange Online session
Write-Host -NoNewline "Disconnecting Exchange Online connection..."
Disconnect-ExchangeOnline -Confirm:$false -InformationAction Ignore -ErrorAction SilentlyContinue
Write-Host "done.`n"

# Import the CSV
Write-Host -NoNewline "Importing CSV..."
$gotoData = Import-Csv -Path "./thecargroup- Organization Export.csv"
Write-Host "done.`n"

$unmatchedEmails = @()
$matchedEmails = @()

# Cycle through each GTC user to match with UPNs
foreach ($user in $gotoData) {
	$email = $user."Email Address" -replace "`n","" -replace "`r",""
	
	if ($UPNs.Contains($email)) {
		$matchedEmails += $email
	}
	else {
		if ($email -eq "") {
		}
		else {
			$unmatchedEmails += $email
		}
	}
}

#$unmatchedEmails = $unmatchedEmails -replace "`n","" -replace "`r",""

# Output text files for matched and unmatched UPNs
$unmatchedEmails | Out-File "./unmatchedEmails.txt"
$matchedEmails | Out-File "./matchedEmails.txt"



Write-Host "Done. Outputs written to 'unmatchedEmails.txt' and 'matchedEmails.txt'`n"



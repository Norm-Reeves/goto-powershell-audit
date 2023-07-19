# goto-powershell-audit

PowerShell script that audits GoToConnect for our standards.

Audit Details:
=========
User Audit

  • Outputs to matchedEmails.txt and unmatchedEmails.txt in same folder as script/.exe.
  
  • There are multiple vendors and shared accounts which this script does not currently filter out.
  
  • User export from GoTo Connect will need to be placed in the same folder as the script and named "thecargroup- Organization Export.csv"

Important to Note:
=========
• Script/.exe does not need to be elevated to work unless ExchangeOnlineManagement module is not installed.

Download .exe:
=========


Change Log:
============
1.0:

  • Created Initial Release. Introduced 'User Audit' feature. 
	  • Compares GoTo Connect accounts with active Exchange accounts to output lists of matched and unmatched users.

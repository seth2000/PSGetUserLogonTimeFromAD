# Authors: Seth Lee            

 
# Variables 
# Reads the hostname, sets to the local hostname if left blank 

function getLogonAndLogoff ($hostname) {

	if ($hostname.length -eq 0){$hostname = $env:computername} 
 
	$startDate =  (Get-Date (Get-Date -Format d)).AddHours(2) #  (Get-Date).AddDays(-1)

	$endDate = get-date
	 
	 
	# Writes a line with all the parameters selected for report 
	# write-output "Type`tDate`tUser`tIP`n" 
	 
	# Store each event from the Security Log with the specificed dates and computer in an array 
	$log = Get-Eventlog -LogName Security -ComputerName $hostname -after $startDate -before $endDate 
	 
	foreach ($i in $log){ 
		# Logon Successful Events 
		# Local (Logon Type 2) 
		if (( $i.EventID -eq 4624 ) -and ($i.ReplacementStrings[8] -eq 2) -and ($i.ReplacementStrings[12] -ne "{00000000-0000-0000-0000-000000000000}") ) 	{ 
			$LoginUserName = $i.ReplacementStrings[5]
			if ($LoginUserName.Contains(".")) {
				write-output  "Logon, $($i.TimeGenerated), $($i.ReplacementStrings[5]),$($hostname)"
			}
		} 
		
		#Remote (Logon Type 10) 
		if (($i.EventID -eq 4624 ) -and ($i.ReplacementStrings[8] -eq 10) -and ($i.ReplacementStrings[12] -ne "{00000000-0000-0000-0000-000000000000}")) { 
			$LoginUserName = $i.ReplacementStrings[5]
			if ($LoginUserName.Contains(".")) {
				write-output  "Logon, $($i.TimeGenerated), $($i.ReplacementStrings[5]),$($hostname)" #"`t"$i.ReplacementStrings[18] 
			}
		} 
		
		# Logoff Events 
		# if ($i.EventID -eq 4647 )  { 
		#	$LoginUserName = $i.ReplacementStrings[1]
		#	if ($LoginUserName.Contains(".")) {
		#		write-output  "Logoff, $($i.TimeGenerated), $($i.ReplacementStrings[1]),$($hostname)"
		#		#write-output -NoNewline "Logoff,"$i.TimeGenerated","$i.ReplacementStrings[1]","$hostname	
		#	}
		#}  
		
	}
}

write-output "Type,Date,Username,Server" 

getLogonAndLogoff ("serversdev")  
getLogonAndLogoff ("serversdev1")  
getLogonAndLogoff ("serversdev2")  
getLogonAndLogoff ("serversts")  
getLogonAndLogoff ("serversts0")  
getLogonAndLogoff ("serversts1")  
getLogonAndLogoff ("serversts2")  



# Get-Eventlog -LogName Security -ComputerName serversts -after $endDate -before $endDate



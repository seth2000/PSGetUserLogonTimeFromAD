# Authors: Seth Lee            

 
# Generate the login report and send everyday.

# Get the full user name from ADUser
function GetUserFullName ($aliasName) {
  return (Get-ADUser -filter {samaccountName -eq $aliasName} | select name).name
}

# generate the filename with today's date
$new_file = "\\acodeservers\Logs$\LoginTime" + $(get-date -f yyyyMMdd) + ".csv"

# Extract all logon events to the file
\\acodeservers\Logs$\ListUserLogin.ps1 > $new_file 

# remove the .old if already exit
$old_file = "$new_file" + ".old"
If (Test-Path $old_file){
	Remove-Item $old_file
}

# change the name to .old
Rename-Item $new_file $old_file

# find the first login record group by Useranem
Import-Csv $old_file |  
Sort username, date |
Group username |
Select 	@{ name= "username" ; Expression = {$_.name}} , 
        @{ name= "fullname" ; Expression = {GetUserFullName($_.name)} } , 
        @{ name= "LoginTime" ; Expression = {($_.group | select -first 1).Date}} , 
		@{ name= "Server" ; Expression = {($_.group | select -first 1).Server}}  | 
Export-Csv -Path $new_file -NoTypeInformation

# send email to myself and I will forward it to Shaun later

Send-MailMessage -SmtpServer smptserver -To to@email.com -Cc seth@seth.com -From seth@seth.com -Subject "Login record" -Body "Hi, Shaun,`nHere is the login active from  Sydney servers this morning.`nCheers, `n Seth" -attachment $new_file



# debug area

#Send-MailMessage -SmtpServer mail.amegroup.com -To seth@seth.com -From seth@seth.com -Subject "Login record" -Body "Hi, Shaun,`nHere is the login for recently" -attachment \\acodeservers\Logs$\LoginTime$(get-date -f yyyyMMdd).csv


#$new_file = "\\acodeservers\Logs$\LoginTime" + $((get-date).adddays(-1) -f yyyyMMdd) + ".csv"

#Import-Csv $new_file |  
#Sort username, date |
#Group username |
#Select @{ name= "username" ; Expression = {($_.group | select -first 1).username}} , @{ name= "LoginTime" ; Expression = {($_.group | select -first 1).Date}} , @{ name= "Server" ; Expression = {($_.group | select -first 1).Server}} 



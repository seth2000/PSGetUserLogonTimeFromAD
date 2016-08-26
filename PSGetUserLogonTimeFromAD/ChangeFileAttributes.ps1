#
# ChangeFileAttributes.ps1
#

Get-ChildItem -Path "C:\Folder" -Include *.xls* -Recurse | foreach {$_.Attributes = 'ReadOnly, Hidden'}


# filter by date
$compareDate = (Get-Date).AddDays(-208)
Get-ChildItem F: *.xls* -Recurse | Where-Object { $_.LastWriteTime -lt $compareDate } |  foreach {$_.Attributes = 'ReadOnly, Hidden'}


#delete files
Get-ChildItem -Path "F:\DeleteFolder" -Include *.xls* -Recurse | Remove-Item -Force
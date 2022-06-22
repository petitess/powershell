#Set-Location c:\dp

Set-Location 'C:\dp'

$number = 001

Get-ChildItem "c:\dp\$_" | Sort-Object length -Descending | ForEach {Rename-Item -Path "c:\dp\$_" -NewName ((""+$number+++"."+$_.Name))}

Get-ChildItem "c:\dp\$_" | Sort-Object {Get-Random} | ForEach {Rename-Item -Path "c:\dp\$_" -NewName (("0"+$number+++"."+$_.Name))}

(Get-ChildItem "c:\dp\$_").Length

Get-ChildItem C:\x\$_ | ForEach {Rename-Item -Path C:\x\$_ -NewName ((""+$number+++"."+$_.Name))}

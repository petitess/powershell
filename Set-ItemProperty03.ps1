#Open THis Computer
$RegPathA = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
Set-ItemProperty -Path $RegPathA  -Name "LaunchTo" -Value 1 -Type "DWord" | Out-Null
#Diabled All Sounds for a user
New-ItemProperty -Path HKCU:\AppEvents\Schemes -Name "(Default)" -Value ".None" -Force | Out-Null

Get-ComputerInfo | Select-Object CsDNSHostName, @{Name="Win version"; Expression = {$_.WindowsProductName +' '+ $_.WindowsVersion}}

Get-Process | Select-Object -Property ProcessName,@{Name="Start Day"; Expression = {$_.StartTime.DayOfWeek}}

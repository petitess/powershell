Get-ComputerInfo | Select-Object CsDNSHostName, @{Name="Win version"; Expression = {$_.WindowsProductName +' '+ $_.WindowsVersion}}

Get-Process | Select-Object -Property ProcessName,@{Name="Start Day"; Expression = {$_.StartTime.DayOfWeek}}

Get-Process | Select-Object Name, CPU, @{Name="Memory (MB)";Expression={$_.PM/1MB}} 

Get-Service | Select-Object DisplayName, Status, @{Name='Comments'; Expression={if ($_.Status -eq 'Running') {'All good!'} else {'Needs attention.'}}}

Get-ComputerInfo | Select-Object `
CsDNSHostName, `
@{Name="WindowsProductId"; Expression = {($_.WindowsProductId).Substring(0,10)}}

Get-ComputerInfo | Select-Object `
CsDNSHostName, `
@{label="Win version"; Expression = {$_.WindowsProductName +' '+ $_.WindowsVersion}}, `
BiosName, `
@{label="WindowsProductId"; Expression = {($_.WindowsProductId).Substring(0,10)}}

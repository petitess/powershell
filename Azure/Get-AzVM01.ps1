Get-AzVM -Status | Where-Object { $_.PowerState -match "VM running" -and $_.Name -notmatch "vmvda"} 

$TagKey = "AutoShutdown"
$VMs = Get-AzVM -Status | Where-Object { $_.Tags.Keys -eq $TagKey -and $_.Name -match "vmvdaprod" -and $_.PowerState -eq "VM running" }
$VMs | Select-Object -Last 1

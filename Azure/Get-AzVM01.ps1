Get-AzVM -Status | Where-Object { $_.PowerState -match "VM running" -and $_.Name -notmatch "vmvda"} 

$VMsize = 'Standard_D8ads_v5'
$TagKey = "Restart"
$TagValues = "GroupA" 

$VMs = Get-AzVM -Status | Where-Object { $_.Tags.Keys -eq $TagKey -and $_.Tags.Values -eq $TagValues -and $_.Name -match "vmvda" }

$VMs | ForEach-Object {
        if ($_.PowerState -eq "VM running" ) {
                $_.OSProfile = $null
                $_.HardwareProfile.VmSize = $VMsize
                Update-AzVM -VM $_ -ResourceGroupName $_.ResourceGroupName
                Write-Output "Updated size: $($_.Name)"
        }if ($_.PowerState -eq "VM deallocated" ) {
                $_.OSProfile = $null
                $_.HardwareProfile.VmSize = $VMsize
                Update-AzVM -VM $_ -ResourceGroupName $_.ResourceGroupName
                Write-Output "Updated size: $($_.Name)"
        }
}

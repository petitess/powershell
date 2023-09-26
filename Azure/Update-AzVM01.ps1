$TagKey = "AutoShutdown"
$TagValues = "GroupA"

$VMs = Get-AzVM -Status | Where-Object { $_.Tags.Keys -eq $TagKey -and $_.Tags.Values -eq $TagValues -and $_.PowerState -eq "VM deallocated" }

$VMs | ForEach-Object {
        $_.HardwareProfile.VmSize = 'Standard_D8ads_v5'
        Update-AzVM -VM $_ -ResourceGroupName $_.ResourceGroupName
        Write-Output "Updated size: $($_.Name)"
}

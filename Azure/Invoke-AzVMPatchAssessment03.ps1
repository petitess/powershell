$TagKey = "UpdateManagement"
$TagValues = "Critical_Monthly_GroupA"

$VMs = Get-AzVM -Status | Where-Object { $_.Tags.Keys -eq $TagKey -and $_.Tags.Values -eq $TagValues -and $_.PowerState -eq "VM running"}

ForEach ($VM in $VMs) {
    Invoke-AzVMPatchAssessment   `
        -ResourceGroupName $VM.ResourceGroupName `
        -VMName $VM.Name `
}

$TagKey = "UpdateManagement"
$TagValues = "Critical_Monthly_GroupB"

$VMs = Get-AzVM -Status | Where-Object { $_.Tags.Keys -eq $TagKey -and $_.Tags.Values -eq $TagValues -and $_.PowerState -eq "VM running"}

ForEach ($VM in $VMs) {
    Invoke-AzVMPatchAssessment   `
        -ResourceGroupName $VM.ResourceGroupName `
        -VMName $VM.Name `
}

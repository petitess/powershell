$VMs = Get-AzVM -Status `
| Where-Object { $_.Name -notmatch "vmadc" -and $_.Name -notmatch "vmvda" -and $_.Name -notmatch "vmpvs" -and $_.PowerState -eq "VM running"}

ForEach ($VM in $VMs) {
    Invoke-AzVMPatchAssessment   `
        -ResourceGroupName $VM.ResourceGroupName `
        -VMName $VM.Name `
}

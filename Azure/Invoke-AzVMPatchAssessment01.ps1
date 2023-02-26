$VMs = Get-AzVM
$VMs

ForEach ($VM in $VMs) {
    Invoke-AzVMPatchAssessment -ResourceGroupName $VM.ResourceGroupName -VMName $VM.Name
}

$VMs = Get-AzVM
$VMs

ForEach ($VM in $VMs) {
    Invoke-AzVmAssessPatch -ResourceGroupName $VM.ResourceGroupName -VMName $VM.Name
}

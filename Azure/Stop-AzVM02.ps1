$TagKey = "AutoShutdown"
$TagValues = "Yes"

$VMs = Get-AzVM | Where-Object {$_.Tags.Keys -eq $TagKey -and $_.Tags.Values -eq $TagValues}

ForEach ($VM in $VMs) {

Stop-AzVM -ResourceGroupName $VM.ResourceGroupName -Name $VM.Name -Force

}

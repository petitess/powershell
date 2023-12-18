Connect-AzAccount -Identity

$TagKey = "AutoShutdown"
$VMs = Get-AzVM -Status | Where-Object { $_.Tags.Keys -eq $TagKey -and $_.Name -match "vmvdaprod" -and $_.PowerState -eq "VM running" }
$lastVm = $VMs | Select-Object -Last 1

$scriptCode = "((query user) -split '\n' -replace '\s\s+', ';' | convertfrom-csv -Delimiter ';').Count | Write-Output"

$I = Invoke-AzVMRunCommand -ResourceGroupName $lastVm.ResourceGroupName -Name $lastVm.Name -CommandId 'RunPowerShellScript' -ScriptString $scriptCode
$output = $I.Value[0].Message

if ([int]$output -lt 14) {
    Write-Output "$output users on $($lastVm.Name). No action."
}
else {
    if ($lastVm.Name -eq 'vmvdaprod24') {
        Write-Output "All VDA running"
    }
    else {
        Write-Output "$output users on $($lastVm.Name). Starting next VDA."
        $VMs = Get-AzVM -Status | Where-Object { $_.Tags.Keys -eq $TagKey -and $_.Name -match "vmvdaprod" -and $_.PowerState -eq "VM deallocated" }
        $firstVm = $VMs | Select-Object -First 1
        Write-Output "$($firstVm.Name) starting"
        Start-AzVM -ResourceGroupName $firstVm.ResourceGroupName -Name $firstVm.Name
    }
}

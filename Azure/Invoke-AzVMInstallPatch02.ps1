#Disable alerts
Set-AzContext -Subscription 'InfrastructureLegacy'
$RG = "rg-alert-b3-guld-log"
$gold = Get-AzScheduledQueryRule -ResourceGroupName $RG | Select-Object Name, Enabled, Id
$gold | ForEach-Object {
    $enabled = Get-AzResource -ResourceId $_.Id
    $enabled.Properties.enabled = "False"
    $enabled | Set-AzResource -Force
    Write-Output "Disabled: $($_.Name)"
}

#Patch VMs
$subscriptions = @(
    'InfrastructureLegacy'
    'sub-infra-prod-01'
)

$subscriptions | ForEach-Object {
    Set-AzContext -Subscription $_
    $TagKey = "UpdateManagement"
    $TagValues = "GroupA"
    $VMs = Get-AzVM -Status | Where-Object { $_.Tags.Keys -eq $TagKey -and $_.Tags.Values -eq $TagValues -and $_.PowerState -eq "VM running" }
    ForEach ($VM in $VMs) {
        Invoke-AzVMInstallPatch  `
            -ResourceGroupName $VM.ResourceGroupName `
            -VMName $VM.Name `
            -Windows `
            -RebootSetting IfRequired `
            -MaximumDuration PT4H `
            -ClassificationToIncludeForWindows Critical, Security, Definition
        Write-Output "Patched: $($VM.Name)"
    }
}

#Enable alerts
Set-AzContext -Subscription 'InfrastructureLegacy'
$RG = "rg-alert-b3-guld-log"
$gold = Get-AzScheduledQueryRule -ResourceGroupName $RG | Select-Object Name, Enabled, Id
if(!$gold.Properties.Enabled) {
$gold | ForEach-Object {
    Update-AzScheduledQueryRule -Name $_.Name  -ResourceGroupName $RG -Enabled
    Write-Output "Enabled: $($_.Name)"
}
}

Invoke-AzVMInstallPatch `
-ResourceGroupName rg-vmmonprod01 `
-VMName vmmonprod01 `
-Linux `
-RebootSetting IfRequired `
-MaximumDuration PT4H `
-ClassificationToIncludeForLinux Critical, Security

$TagKey = "UpdateManagement"
$TagValues = "Critical_Monthly_GroupA"

$VMs = Get-AzVM | Where-Object {$_.Tags.Keys -eq $TagKey -and $_.Tags.Values -eq $TagValues}
$VMs
ForEach ($VM in $VMs) {
    Invoke-AzVMInstallPatch  `
    -ResourceGroupName rg-vmmgmtprod01 `
    -VMName vmmgmtprod01 `
    -Windows `
    -RebootSetting IfRequired `
    -MaximumDuration PT4H `
    -ClassificationToIncludeForWindows Critical, Security
}

param (
    [Parameter(Mandatory)]
    [string]$SUBNAME,

    [Parameter(Mandatory)]
    [string]$NEWMG
)
Connect-AzAccount -Identity

$OldMg = "xxxx-b710-439d-b5bd-xxx"
$Sub = Get-AzManagementGroupSubscription -GroupName $OldMg | Where-Object { $_.DisplayName -eq $SUBNAME }
if ($null -ne $Sub) {
    $SubId = $($Sub.Id).Replace("/providers/Microsoft.Management/managementGroups/$OldMg/subscriptions/", "")
    New-AzManagementGroupSubscription -GroupName $NEWMG -SubscriptionId $SubId
}

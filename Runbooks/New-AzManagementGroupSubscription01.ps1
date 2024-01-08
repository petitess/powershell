param (
    [Parameter(Mandatory)]
    [Alias('Subscription Name')]
    [string]$SUBNAME,

    [Parameter(Mandatory)]
    [Alias('Management Group Id')]
    [string]$NEWMG
)
Connect-AzAccount -Identity

<#
Prerequisite:
Automation account must be 'Management Group Contributor' and 'Owner at Root Scope('/')
New-AzRoleAssignment -Scope '/' -RoleDefinitionName 'Management Group Contributor' -ObjectId $ObjectId
New-AzRoleAssignment -Scope '/' -RoleDefinitionName 'Owner' -ObjectId $ObjectId
#>

$OldMg = "xxxx-b710-439d-b5bd-xxxx"
$Sub = Get-AzManagementGroupSubscription -GroupName $OldMg | Where-Object { $_.DisplayName -eq $SUBNAME }
if ($null -ne $Sub) {
    $SubId = $($Sub.Id).Replace("/providers/Microsoft.Management/managementGroups/$OldMg/subscriptions/", "")
    $Result = New-AzManagementGroupSubscription -GroupName $NEWMG -SubscriptionId $SubId
    Write-Output "$($Result.DisplayName) moved to $NEWMG" 
}else {
    Write-Output "Did not find any subscription with this name in Tenant Root Group"
}

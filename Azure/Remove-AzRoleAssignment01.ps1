$Subscriptions = (Get-AzSubscription | Where-Object { $_.Name -like "sub*" }).Name

$Subscriptions | ForEach-Object {
    $SubName = $_
    Write-Output $SubName
    $SubId = (Set-AzContext $SubName ).Subscription.Id
    $ObjectId = (Get-AzADGroup -DisplayName "grp-rbac-$SubName-Owner").Id
    if ($null -ne $ObjectId) {
        Write-Output "Id: $ObjectId"
        $Assigment = Get-AzRoleAssignment -Scope "/subscriptions/$SubId" -RoleDefinitionName "Owner" -ObjectId $ObjectId
        Write-Output "Assigment: $Assigment"
        Write-Output $($null -ne $Assigment) 
        if ($null -ne $Assigment) {
            Remove-AzRoleAssignment -ObjectId $ObjectId -RoleDefinitionName "Owner" -Scope "/subscriptions/$SubId"
        }
    }
}

$SubName = "sub-supplier-stg-01"
$SubId = (Set-AzContext $SubName ).Subscription.Id
$ObjectId = (Get-AzADGroup -DisplayName "grp-rbac-$SubName-Owner").Id
if ($null -ne $ObjectId) {
    Write-Output "Id: $ObjectId"
    $Assigment = Get-AzRoleAssignment -Scope "/subscriptions/$SubId" -RoleDefinitionName "Owner" -ObjectId $ObjectId
    Write-Output "Assigment: $Assigment"
    Write-Output $($null -ne $Assigment) 
    if ($null -ne $Assigment) {
        Remove-AzRoleAssignment -ObjectId $ObjectId -RoleDefinitionName "Owner" -Scope "/subscriptions/$SubId"
    }
}

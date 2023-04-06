Install-Module -Name AzureAD -Confirm:$false -Force -Scope CurrentUser

Connect-AzureAD

# Get Service Principal using objectId
$sp = Get-AzureADServicePrincipal -ObjectId "xxx-a8f0-4cbe-99c0-76f772adbbd4"

# Get Azure AD App role assignments using objectId of the Service Principal
$assignments = Get-AzureADServiceAppRoleAssignment -ObjectId $sp.ObjectId -All $true

New-AzureADServiceAppRoleAssignment -ObjectId $sp.ObjectId

# Remove all users and groups assigned to the application
$assignments | ForEach-Object {
    if ($_.PrincipalType -eq "User") {
        Remove-AzureADUserAppRoleAssignment -ObjectId $_.PrincipalId -AppRoleAssignmentId $_.ObjectId
    } elseif ($_.PrincipalType -eq "Group") {
        Remove-AzureADGroupAppRoleAssignment -ObjectId $_.PrincipalId -AppRoleAssignmentId $_.ObjectId
    }
}
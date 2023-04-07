Connect-AzAccount

$user = Get-AzADUser -UserPrincipalName ""

New-AzRoleAssignment -Scope '/' -RoleDefinitionName 'Owner' -ObjectId $user.Id

Get-AzRoleAssignment -ObjectId $user.Id -Scope "/"

Remove-AzRoleAssignment -Scope '/' -RoleDefinitionName 'Owner' -ObjectId $user.Id


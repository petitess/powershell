Connect-AzAccount

$user = Get-AzADUser -UserPrincipalName ""

New-AzRoleAssignment -Scope '/' -RoleDefinitionName 'Owner' -ObjectId $user.Id

Get-AzRoleAssignment -ObjectId $user.Id -Scope "/"

Remove-AzRoleAssignment -Scope '/' -RoleDefinitionName 'Owner' -ObjectId $user.Id

New-AzRoleAssignment -Scope '/' -RoleDefinitionName 'Management Group Contributor' -ObjectId $user.Id
New-AzRoleAssignment -Scope '/' -RoleDefinitionName 'Management Group Reader' -ObjectId $user.Id


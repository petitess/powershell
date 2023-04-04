Connect-AzAccount

$user = Get-AzADUser -UserPrincipalName ""

New-AzRoleAssignment -Scope '/' -RoleDefinitionName 'Owner' -ObjectId $user.Id

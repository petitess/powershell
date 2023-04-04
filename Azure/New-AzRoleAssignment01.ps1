Connect-AzAccount 

$app = Get-AzADServicePrincipal -DisplayName "xxx-Infrastruktur-sp-governance-01"

New-AzRoleAssignment -Scope '/' -RoleDefinitionName 'Owner' -ObjectId $app.Id

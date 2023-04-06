$pathConfig = "..\iac\config.json"
$jsonConfig = Get-Content $pathConfig | Out-String | ConvertFrom-Json

$jsonConfig.tenantID

$TenantID = $jsonConfig.tenantID

$GraphAppId = "00000003-0000-0000-c000-000000000000"

#$PermissionName = "Group.Create"

$PermissionName = "Directory.ReadWrite.All"


$managedIdentity = "id-script-governance-prod-we-01"

#Install-Module AzureAD

Connect-AzureAD -TenantId $TenantID

$managedIdentity = (Get-AzureADServicePrincipal -Filter "displayName eq '$managedIdentity'")

Start-Sleep -Seconds 10

$GraphServicePrincipal = Get-AzureADServicePrincipal -Filter "appId eq '$GraphAppId'"

$AppRole = $GraphServicePrincipal.AppRoles | `

Where-Object { $_.Value -eq $PermissionName -and $_.AllowedMemberTypes -contains "Application" }

New-AzureAdServiceAppRoleAssignment -ObjectId $managedIdentity.ObjectId -PrincipalId $managedIdentity.ObjectId `
-ResourceId $GraphServicePrincipal.ObjectId -Id $AppRole.Id

$AppRoleAssignmentId = Get-AzureADServiceAppRoleAssignedTo -ObjectId $managedIdentity.ObjectId
Remove-AzureAdServiceAppRoleAssignment -ObjectId $managedIdentity.ObjectId -AppRoleAssignmentId $AppRoleAssignmentId.ObjectId
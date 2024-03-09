#### [Microsoft Graph permissions reference](https://learn.microsoft.com/en-us/graph/permissions-reference)
-------

#### Install the Microsoft Graph PowerShell SDK
```pwsh
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

Install-Module Microsoft.Graph -Scope AllUsers

Get-InstalledModule Microsoft.Graph
```
#### Connect
```pwsh
Connect-MgGraph -TenantId "xxx" -Scopes 'User.Read.All'

Connect-MgGraph -Scopes "User.Read.All", `
"Group.Read.All", `
"MailboxSettings.Read", `
"PrivilegedEligibilitySchedule.ReadWrite.AzureADGroup", `
"PrivilegedAccess.ReadWrite.AzureADGroup", `
"PrivilegedAccess.Read.AzureADGroup", `
"PrivilegedAccess.ReadWrite.AzureADGroup", `
"RoleManagement.ReadWrite.Directory"

Get-MgContext

Get-MgUser -All

Disconnect-MgGraph
```
#### Connecte using access token
```pwsh
$accessToken = az account get-access-token --resource-type ms-graph --query "accessToken" -o tsv
Connect-MgGraph -AccessToken ($accessToken | ConvertTo-SecureString -AsPlainText -Force)
```
#### PIM
```pwsh
#PIM 
$user = Get-MgUser -All | Where-Object {$_.UserPrincipalName -eq "kar.sek.ext@ssg.se"}
Get-MgRoleManagementDirectoryRoleEligibilityScheduleInstance -All -Filter "principalId eq '$($user.Id)'"  | Format-List
#Get PIM request
Get-MgRoleManagementDirectoryRoleAssignmentScheduleRequest -All -Filter "principalId eq '$($user.Id)'" | Format-List
#Get PIM groups
Get-MgGroup -All | Where-Object {$_.isAssignableToRole -like "True"} | Select-Object DisplayName,Id

Get-MgIdentityGovernancePrivilegedAccessGroupEligibilityScheduleRequest | ConvertTo-Json

(Get-Command get-mg*Privileged*group*).Name
```
#### Assign Admin consent to an enterprise app
```pwsh
Connect-MgGraph -Scopes "Sites.Read.All" -ClientId "xxx-3eb5-4440-baff-xxx" -TenantId "xxx-b710-439d-b5bd-xxx"
```
#### Remove both user and admin consent permissions from application
```pwsh
Connect-MgGraph -Scopes "User.ReadWrite.All", "Application.ReadWrite.All", "DelegatedPermissionGrant.ReadWrite.All"
# Get Service Principal using objectId
$sp = Get-MgServicePrincipal -ServicePrincipalId 48d2bebb-aea1-4139-979c-b5332e18232a
# Get all delegated permissions for the service principal
$spOAuth2PermissionsGrants = Get-MgServicePrincipalOauth2PermissionGrant -ServicePrincipalId $sp.Id -All
# Remove all delegated permissions
$spOAuth2PermissionsGrants | ForEach-Object {
    Remove-MgOauth2PermissionGrant -OAuth2PermissionGrantId $_.Id
}
```
#### Remove admin consent permissions from application
```pwsh
Connect-MgGraph -Scopes "User.ReadWrite.All", "Application.ReadWrite.All", "DelegatedPermissionGrant.ReadWrite.All"
# Get Service Principal using objectId
$sp = Get-MgServicePrincipal -ServicePrincipalId 453d37f9-20e5-4325-bc00-67d1581a0232
# Get all delegated permissions for the service principal
$spOAuth2PermissionsGrants = Get-MgServicePrincipalOauth2PermissionGrant -ServicePrincipalId $sp.Id -All
# Remove only delegated permissions granted with admin consent
$spOAuth2PermissionsGrants | Where-Object { $_.ConsentType -eq "AllPrincipals" } | ForEach-Object {
    Remove-MgOauth2PermissionGrant -OAuth2PermissionGrantId $_.Id
}
```
#### Remove user consent permissions from application
```pwsh
Connect-MgGraph -Scopes "User.ReadWrite.All", "Application.ReadWrite.All", "DelegatedPermissionGrant.ReadWrite.All"
# Get Service Principal using objectId
$sp = Get-MgServicePrincipal -ServicePrincipalId 453d37f9-20e5-4325-bc00-67d1581a0232
# Get all delegated permissions for the service principal
$spOAuth2PermissionsGrants = Get-MgServicePrincipalOauth2PermissionGrant -ServicePrincipalId $sp.Id -All
# Remove only delegated permissions granted with user consent
$spOAuth2PermissionsGrants | Where-Object { $_.ConsentType -ne "AllPrincipals" } | ForEach-Object {
    Remove-MgOauth2PermissionGrant -OAuth2PermissionGrantId $_.Id
}
```

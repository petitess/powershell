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

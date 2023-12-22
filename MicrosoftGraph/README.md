#### Install the Microsoft Graph PowerShell SDK
```pwsh
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

Install-Module Microsoft.Graph -Scope AllUsers

Get-InstalledModule Microsoft.Graph
```
#### Connect
```pwsh
Connect-MgGraph -TenantId "xxx" -Scopes 'User.Read.All'

Connect-MgGraph -Scopes "User.Read.All","MailboxSettings.Read","PrivilegedEligibilitySchedule.ReadWrite.AzureADGroup","PrivilegedAccess.ReadWrite.AzureADGroup"

Get-MgContext

Get-MgUser -All

Disconnect-MgGraph
```

# powershell
##### AD connect sync
```powershell
Start-ADSyncSyncCycle -PolicyType Initial
```
##### Get All Groups for the current user is a member of
```powershell
(get-aduser $env:USERNAME -Properties memberof | select -expand memberof | get-adgroup) | select Name,groupscope | sort name
```
##### Get All Groups for the current user is a member of
```powershell
Get-ADPrincipalGroupMembership $env:username | select name
```
##### Add admin to user
```powershell
net localgroup Administratörer "AzureAD\xxx@xx.se" /add
net localgroup Administratörer "AzureAD\xxx@xx.se" /delete
```
##### Install the Az.Accounts PowerShell module manually
- Download `Az.Accounts`: https://www.powershellgallery.com/packages/Az.Accounts/
- Rename the `.nupkg` file to `.zip`
- Extract the contents of the zip file to folder `Az.Accounts`.
- Copy the `Az.Accounts` folder to `C:\Program Files\WindowsPowerShell\Modules\Az.Accounts`
- Run these command:
```powershell
Get-ChildItem -Path "C:\Program Files\WindowsPowerShell\Modules\Az.Accounts" -Recurse | Unblock-File
Get-Module -ListAvailable -Name Az.Accounts
Import-Module -Name Az.Accounts
```

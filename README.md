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

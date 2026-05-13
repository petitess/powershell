Connect to Azure using a service principal account
```pwsh
$Password = $env:mg_root_01_secret | ConvertTo-SecureString -asPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential($env:mg_root_01_id, $Password)
Connect-AzAccount -ServicePrincipal -TenantId $env:tenant -Credential $Credential
```

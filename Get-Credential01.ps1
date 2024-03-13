$appid = "xxxxx-f137-4e11-b18e-6db395c662aa"
$tenantid = 'bcee8bc2-b710-439d-b5bd-f5b83846ddee'
$secret = ConvertTo-SecureString -String 'xxxxxx-ar2BRfWQlj4iWElQANwX~m4R7-MaGcr1' -AsPlainText -Force
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $appid, $secret
$ClientSecretCredential = Get-Credential -Credential $Credential
# Enter client_secret in the password prompt.
Connect-MgGraph -TenantId $tenantid -ClientSecretCredential $ClientSecretCredential
Get-MgContext

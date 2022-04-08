#Configure "Run as accounts" in your Automation Account

#Use this script to login
$connection = Get-AutomationConnection -Name AzureRunAsConnection
$connectionResult = Connect-AzAccount `
-ServicePrincipal `
-Tenant $connection.TenantID `
-ApplicationId $connection.ApplicationID `
-CertificateThumbprint $connection.CertificateThumbprint
"Login successful.."

#Run you script
$RG = Get-AzResourceGroup -Name *
Write-Output $RG | select ResourceGroupName
$RG | Remove-AzResourceGroup -Force

$Credential = Get-Credential 
$PSCredentialPath = "C:\tools\monitorsp.xml"

$Credential | Export-Clixml -Path $PSCredentialPath

$Credential = Import-Clixml $PSCredentialPath

try {
    az login --service-principal --username $Credential.username --password $Credential.GetNetworkCredential().Password --tenant $tenantId | Out-Null
    $Token = az account get-access-token --output tsv --query accessToken
}
catch {
    $Error[0]
    Write-Output "Failed authentication step"
    exit 2
}

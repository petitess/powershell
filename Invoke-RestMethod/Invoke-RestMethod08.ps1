###GET
$SubscriptionId = (Get-AzSubscription -SubscriptionName "sub-infra-dev-01" | Where-Object {$_.State -eq "Enabled"} ).Id
$ResourceGroupName = "rg-infra-cert-dev-we-01"
$KvName = "kv-infra-cert-dev-we-01"
$ApiVersion = "2021-05-01-preview"
$DiagName = "diag-xxxx"
$URL = "https://management.azure.com/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.KeyVault/vaults/$KvName/providers/Microsoft.Insights/diagnosticSettings/$($DiagName)?api-version=$ApiVersion"

$headers = @{
    "Authorization" = "Bearer $((Get-AzAccessToken).Token)"
    "Content-type"  = "application/json"
}

(Invoke-RestMethod -Method GET -URI $URL -Headers $headers).properties.logs


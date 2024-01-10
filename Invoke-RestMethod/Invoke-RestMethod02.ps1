###GET Key valut secret
$subscriptionId = (Get-AzSubscription -SubscriptionName "sub-prod-01").Id
$RessourceGroupName = "rg-infra-prod-sc-01"
$KvName = "kv-infra-prod-01"
$SecretName = "a-sec"
$ApiVersion = "2023-07-01"
$URL = "https://management.azure.com/subscriptions/$subscriptionId/resourceGroups/$RessourceGroupName/providers/Microsoft.KeyVault/vaults/$KvName/secrets/$($SecretName)?api-version=$ApiVersion"
$headers = @{
    "Authorization" = "Bearer $((Get-AzAccessToken).Token)"
    "Content-type"  = "application/json"
}
(Invoke-RestMethod -Method GET -URI $URL -Headers $headers) | ConvertTo-Json

###PUT Key valut secret
$subscriptionId = (Get-AzSubscription -SubscriptionName "sub-prod-01").Id
$RessourceGroupName = "rg-infra-prod-sc-01"
$KvName = "kv-infra-prod-01"
$SecretName = "a-sec"
$ApiVersion = "2023-07-01"
$URL = "https://management.azure.com/subscriptions/$subscriptionId/resourceGroups/$RessourceGroupName/providers/Microsoft.KeyVault/vaults/$KvName/secrets/$($SecretName)?api-version=$ApiVersion"
$headers = @{
    "Authorization" = "Bearer $((Get-AzAccessToken).Token)"
    "Content-type"  = "application/json"
}
$Body = ConvertTo-Json @{
    properties = @{
        value= "booom"
    }
}
Invoke-RestMethod -Method PUT -URI $URL -Headers $headers -Body $Body

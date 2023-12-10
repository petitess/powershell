###UPDATE
$subscriptionId = (Get-AzSubscription -SubscriptionName "sub-default-01").Id
$apiversion = "2021-04-01"
$URL = "https://management.azure.com/subscriptions/$($subscriptionId)/providers/Microsoft.Resources/tags/default?api-version=$apiversion"

$headers = @{
    "Authorization" = "Bearer $((Get-AzAccessToken).Token)"
    "Content-type"  = "application/json"
}

$bodyNewRessourceGroup = @"
{
    "operation":"merge",
    "properties": {
      "tags": {
        "SYSTEM" : "$(Get-Date)"
      }
    }
  }
"@

Invoke-RestMethod -Method PATCH -URI $URL -body $bodyNewRessourceGroup -Headers $headers

###GET
$subscriptionId = (Get-AzSubscription -SubscriptionName "sub-default-01").Id
$apiversion = "2021-04-01"
$URL = "https://management.azure.com/subscriptions/$($subscriptionId)/providers/Microsoft.Resources/tags/default?api-version=$apiversion"

$headers = @{
    "Authorization" = "Bearer $((Get-AzAccessToken).Token)"
    "Content-type"  = "application/json"
}

Invoke-RestMethod -Method GET -URI $URL -Headers $headers | ConvertTo-Json

(Invoke-RestMethod -Method GET -URI $URL -Headers $headers).properties.tags 

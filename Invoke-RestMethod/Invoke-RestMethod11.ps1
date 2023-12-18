Connect-AzAccount -Identity

Set-AzContext "sub-infra-dev-01"

$subscriptionId = (Get-AzSubscription -SubscriptionName "sub-infra-dev-01").Id
$apiversion="2023-01-01"
#GET datastore
$URL = "https://management.azure.com/subscriptions/$($subscriptionId[0])/providers/Microsoft.Security/pricings?api-version=$apiversion"

$headers = @{
    "Authorization" = "Bearer $((Get-AzAccessToken).Token)"
    "Content-type"  = "application/json"
  }

Invoke-RestMethod -Method GET -URI $URL -Headers $headers
(Invoke-RestMethod -Method GET -URI $URL -Headers $headers).value

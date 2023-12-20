###GET
$subscriptionId = (Get-AzSubscription -SubscriptionName "sub-b3care-prod-01").Id
$RessourceGroupName = "rg-vmmgmtprod01"
$Location = "swedencentral"
$apiversion="2020-01-01"
$URL = "https://management.azure.com/subscriptions/$subscriptionId/resourceGroups/$RessourceGroupName/providers/Microsoft.Security/locations/$Location/jitNetworkAccessPolicies?api-version=$apiversion"

$headers = @{
    "Authorization" = "Bearer $((Get-AzAccessToken).Token)"
    "Content-type"  = "application/json"
  }

Invoke-RestMethod -Method GET -URI $URL -Headers $headers
(Invoke-RestMethod -Method GET -URI $URL -Headers $headers).value

###DELETE
$subscriptionId = (Get-AzSubscription -SubscriptionName "sub-b3care-prod-01").Id
$RessourceGroupName = "rg-vmmgmtprod01"
$Location = "swedencentral"
$apiversion="2020-01-01"
$URL = "https://management.azure.com/subscriptions/$subscriptionId/resourceGroups/$RessourceGroupName/providers/Microsoft.Security/locations/$Location/jitNetworkAccessPolicies/default?api-version=$apiversion"

$headers = @{
    "Authorization" = "Bearer $((Get-AzAccessToken).Token)"
    "Content-type"  = "application/json"
  }

Invoke-RestMethod -Method DELETE -URI $URL -Headers $headers

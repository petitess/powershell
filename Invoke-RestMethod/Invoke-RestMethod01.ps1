###CREATE
$subscriptionId = (Get-AzSubscription -SubscriptionName "Name").Id
$RessourceGroupName = "rg-restapi01"
$Location = "northeurope"
$apiversion="2022-09-01"
$URL = "https://management.azure.com/subscriptions/$subscriptionId/resourceGroups/$($RessourceGroupName)?api-version=$apiversion"

$headers = @{
    "Authorization" = "Bearer $((Get-AzAccessToken).Token)"
    "Content-type"  = "application/json"
  }

$bodyNewRessourceGroup = @"
    {
        "location": "$location"
    }
"@

Invoke-RestMethod -Method PUT -URI $URL -body $bodyNewRessourceGroup -Headers $headers
###UPDATE
$subscriptionId = (Get-AzSubscription -SubscriptionName "sub-default-01").Id
$RessourceGroupName = "rg-xxx"
$Location = "swedencentral"
$apiversion="2022-09-01"
$URL = "https://management.azure.com/subscriptions/$subscriptionId/resourceGroups/$($RessourceGroupName)?api-version=$apiversion"

$headers = @{
    "Authorization" = "Bearer $((Get-AzAccessToken).Token)"
    "Content-type"  = "application/json"
  }

$bodyNewRessourceGroup = @"
    {
        "location": "$location",
        "tags": {
            "SYSTEM" : "$(Get-Date)"
        }
    }
"@

Invoke-RestMethod -Method PATCH -URI $URL -body $bodyNewRessourceGroup -Headers $headers



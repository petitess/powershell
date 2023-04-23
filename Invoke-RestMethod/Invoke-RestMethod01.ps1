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



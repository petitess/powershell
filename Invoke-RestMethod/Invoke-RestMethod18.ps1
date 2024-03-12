Disconnect-AzAccount
Connect-AzAccount
Set-AzContext "sub-infra-dev-01"

###GET
$SubscriptionId = (Get-AzSubscription -SubscriptionName "sub-infra-dev-01" | Where-Object {$_.State -eq "Enabled"} ).Id
$Location = "westeurope"
$ApimName = "apim-infra-apim-dev-we-01"
$ApiVersion = "2021-08-01"
$URL = "https://management.azure.com/subscriptions/$SubscriptionId/providers/Microsoft.ApiManagement/locations/$Location/deletedservices/$($ApimName)?api-version=$ApiVersion"
$headers = @{
    "Authorization" = "Bearer $((Get-AzAccessToken).Token)"
    "Content-type"  = "application/json"
}

###List deleted API Management instances
Invoke-RestMethod -Method GET -URI $URL -Headers $headers
###Recover a soft deleted instance
Invoke-RestMethod -Method PUT -URI $URL -Headers $headers
###Purge a soft-deleted instance
Invoke-RestMethod -Method DELETE -URI $URL -Headers $headers

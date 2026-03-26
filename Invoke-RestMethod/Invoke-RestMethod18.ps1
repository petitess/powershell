###GET
$SubscriptionId = "abc"
$Location = "swedencentral"
$ApimName = "apim-dev-almi-01"
$RgName = "rg-apim-dev-01"
$ApiVersion = "2024-05-01"
$Token = az account get-access-token --query accessToken -o tsv
###Remove the resource
$URL = "https://management.azure.com/subscriptions/$SubscriptionId/resourceGroups/$RgName/providers/Microsoft.ApiManagement/service/$($ApimName)?api-version=$ApiVersion"
###Purge a soft-deleted instance
$URL = "https://management.azure.com/subscriptions/$SubscriptionId/providers/Microsoft.ApiManagement/locations/$Location/deletedservices/$($ApimName)?api-version=$ApiVersion"
$headers = @{
    "Authorization" = "Bearer $Token"
    "Content-type"  = "application/json"
}

###List deleted API Management instances
Invoke-RestMethod -Method GET -URI $URL -Headers $headers
###Recover a soft deleted instance
Invoke-RestMethod -Method PUT -URI $URL -Headers $headers
###Purge a soft-deleted instance
Invoke-RestMethod -Method DELETE -URI $URL -Headers $headers

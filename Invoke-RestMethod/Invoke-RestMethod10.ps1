###GET Azure Machine Learning workspace
$subscriptionId = (Get-AzSubscription -SubscriptionName "sub-default-01").Id
$RessourceGroupName = "karol.sek-rg"
$mlName = "ml-default-01"
$apiversion="2023-10-01"
$URL = "https://management.azure.com/subscriptions/$subscriptionId/resourceGroups/$($RessourceGroupName)/providers/Microsoft.MachineLearningServices/workspaces/$($mlName)?api-version=$apiversion"

$headers = @{
    "Authorization" = "Bearer $((Get-AzAccessToken).Token)"
    "Content-type"  = "application/json"
  }

Invoke-RestMethod -Method GET -URI $URL -Headers $headers
(Invoke-RestMethod -Method GET -URI $URL -Headers $headers).properties

#GET datastore
$dataStore = "workspaceworkingdirectory"
$URL = "https://management.azure.com/subscriptions/$subscriptionId/resourceGroups/$($RessourceGroupName)/providers/Microsoft.MachineLearningServices/workspaces/$($mlName)/datastores/$($dataStore)?api-version=$apiversion"

$headers = @{
    "Authorization" = "Bearer $((Get-AzAccessToken).Token)"
    "Content-type"  = "application/json"
  }

Invoke-RestMethod -Method GET -URI $URL -Headers $headers
(Invoke-RestMethod -Method GET -URI $URL -Headers $headers).properties

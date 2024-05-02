###https://learn.microsoft.com/en-us/rest/api/azure/devops/distributedtask/elasticpools/update?view=azure-devops-rest-6.1

$Token = az account get-access-token --query accessToken --output tsv
$URL = "https://dev.azure.com/ssgse/_apis/distributedtask/elasticpools?api-version=6.1-preview.1"
$headers = @{
    "Authorization" = "Bearer $Token"
    "Content-type"  = "application/json"
}
(Invoke-RestMethod -Method GET -URI $URL -Headers $headers).value | Where-Object {$_.azureId -like "*vmss-infra-devops-dev-we-01"} | ConvertTo-Json 


$Token = az account get-access-token --query accessToken --output tsv
$URL = "https://dev.azure.com/ssgse/_apis/distributedtask/elasticpools/46?api-version=6.1-preview.1"
$headers = @{
    "Authorization" = "Bearer $Token"
    "Content-type" = "application/json"
}
$Body = ConvertTo-Json @{
    desiredIdle    = 3
}
Invoke-RestMethod -Method PATCH -URI $URL -Headers $headers -Body $Body

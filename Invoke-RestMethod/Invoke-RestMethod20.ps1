###https://learn.microsoft.com/en-us/rest/api/azure/devops/distributedtask/elasticpools/update?view=azure-devops-rest-6.1

$Time = Get-Date -Format "HH"

Get-Date -Format "HH:mm K"

$Token = $(az account get-access-token --query accessToken --output tsv)
$URL = "https://dev.azure.com/xxxse/_apis/distributedtask/elasticpools?api-version=6.1-preview.1"
$headers = @{
    "Authorization" = "Bearer $Token"
    "Content-type"  = "application/json"
}
$Pools = (Invoke-RestMethod -Method GET -URI $URL -Headers $headers).value | Where-Object { $_.azureId -like "*vmss-infra-devops*" }

$Pools | ForEach-Object {

    $URL = "https://dev.azure.com/xxxse/_apis/distributedtask/elasticpools/$($_.poolId)?api-version=6.1-preview.1"
    $headers = @{
        "Authorization" = "Bearer $Token"
        "Content-type"  = "application/json"
    }
    $Body = ConvertTo-Json @{
        desiredIdle = $Time -gt 17 ? 0 : 1
    }
    Write-Output "Number of agents to keep on standby: $($Time -gt 17 ?  0 : 1) " 
    Invoke-RestMethod -Method PATCH -URI $URL -Headers $headers -Body $Body
}

$Token = (Get-AzAccessToken -ResourceTypeName MSGraph).Token
$ObjectId = "x-25a8d733fc56"
$URL = "https://graph.microsoft.com/v1.0/applications/$ObjectId"
$headers = @{
    "Authorization" = "Bearer $Token"
    "Content-type"  = "application/json"
}
(Invoke-RestMethod -Method GET -URI $URL -Headers $headers) | ConvertTo-Json
$URL2 = "https://graph.microsoft.com/v1.0/applications/$ObjectId/addPassword"
$Body = ConvertTo-Json @{
    passwordCredential = @{
        displayName = "mgraph_secret_2"
    }
}
(Invoke-RestMethod -Method POST -URI $URL2 -Headers $headers -Body $Body) | ConvertTo-Json

#### GET
```pwsh
$Token = ""
$URL = ""
$headers = @{
    "Authorization" = "Bearer $Token"
    "Content-type"  = "application/json"
}
(Invoke-RestMethod -Method GET -URI $URL -Headers $headers) | ConvertTo-Json
```
#### PUT
```pwsh
$Token = ""
$URL = "x"
$headers = @{
    "Authorization" = "Bearer $Token)"
    "Content-type"  = "application/json"
}
$Body = ConvertTo-Json @{
    properties = @{
        value= "booom"
    }
}
Invoke-RestMethod -Method PUT -URI $URL -Headers $headers -Body $Body
```

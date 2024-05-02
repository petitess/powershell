#### POST
```pwsh
$Token = az account get-access-token --query accessToken --output tsv
$URL = "https://localhost:7200/api/Auth/login"
$headers = @{
    "Authorization" = "Bearer $Token"
    "Content-type" = "application/json"
}
$Body = ConvertTo-Json @{
    email    = "x@x.x"
    password = "12345.abC"
    
}
$I = Invoke-RestMethod -Method POST -URI $URL -Headers $headers -Body $Body
$I.token
```

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
    "Authorization" = "Bearer $Token"
    "Content-type"  = "application/json"
}
$Body = ConvertTo-Json @{
    properties = @{
        value= "booom"
    }
}
Invoke-RestMethod -Method PUT -URI $URL -Headers $headers -Body $Body
```

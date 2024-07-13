
$Token = (Get-AzAccessToken).Token
$SubId = (Get-AzSubscription -SubscriptionName "sub-test-01").Id
$StRgName = "rg-st-01"
$StName = "stterraform001"
$ApiVer = "2022-09-01"
$url = "https://management.azure.com/subscriptions/$SubId/resourceGroups/$StRgName/providers/Microsoft.Storage/storageAccounts/$($StName)?api-version=$ApiVer"
$headers = @{
    "Authorization" = "Bearer $Token"
}
$I = Invoke-RestMethod -Method GET -URI $URL -Headers $headers
$I

$Token = (Get-AzAccessToken -ResourceUrl 'https://storage.azure.com/').Token
$URL = "https://stterraform001.blob.core.windows.net/opsgenie-terraform-1-azure/terraform.tfstate"
$Date = Get-Date (Get-Date).ToUniversalTime() -Format 'R'
$headers = @{
    "Authorization" = "Bearer $Token"
    "x-ms-date"     = $Date
    "x-ms-version"  = "2020-04-08"
}
$I = Invoke-RestMethod -Method GET -URI $URL -Headers $headers
$I

$Token = (Get-AzAccessToken -ResourceUrl 'https://storage.azure.com/').Token
$URL = "https://stterraform001.table.core.windows.net/?restype=service&comp=properties"
$Date = Get-Date (Get-Date).ToUniversalTime() -Format 'R'
$headers = @{
    "Authorization" = "Bearer $Token"
    "x-ms-date"     = $Date
    "x-ms-version"  = "2020-04-08"
}
$I = Invoke-RestMethod -Method GET -URI $URL -Headers $headers
$I

$Token = (Get-AzAccessToken -ResourceUrl 'https://storage.azure.com/').Token
$URL = "https://stterraform001.table.core.windows.net/Tables"
$Date = Get-Date (Get-Date).ToUniversalTime() -Format 'R'
$headers = @{
    "Authorization" = "Bearer $Token"
    "x-ms-date"     = $Date
    "x-ms-version"  = "2020-04-08"
    "Accept"        = "application/json;odata=fullmetadata"
}
$I = Invoke-RestMethod -Method GET -URI $URL -Headers $headers
$I.value

$Token = (Get-AzAccessToken -ResourceUrl 'https://storage.azure.com/').Token
$URL = "https://stterraform001.table.core.windows.net/userpasswordexpiration"
$Date = Get-Date (Get-Date).ToUniversalTime() -Format 'R'
$Body = ConvertTo-Json @{
    "PartitionKey"      = "passwordexpiration"
    "RowKey"            = ([guid]::NewGuid().tostring())
    "WriteTime"         = (Get-Date -Format "yyyyMMdd")
    "UserPrincipalName" = "Success"
    "Name"              = "Success"
    "Mail"              = "Success"
    "ExpiryDate"        = "Success"
}
$headers = @{
    "Authorization"  = "Bearer $Token"
    "x-ms-date"      = $Date
    "Content-type"   = "application/json"
    "Content-Length" = $Body.Length
    "x-ms-version"   = "2020-04-08"
    "Accept"         = "application/json;odata=fullmetadata"
}

$I = Invoke-RestMethod -Method POST -URI $URL -Headers $headers -Body $Body
$I

$Token = (Get-AzAccessToken -ResourceUrl 'https://storage.azure.com/').Token
$URL = "https://stterraform001.table.core.windows.net/userpasswordexpiration"
$Date = Get-Date (Get-Date).ToUniversalTime() -Format 'R'
$headers = @{
    "Authorization" = "Bearer $Token"
    "x-ms-date"     = $Date
    "x-ms-version"  = "2020-04-08"
    "Accept"        = "application/json;odata=fullmetadata"
}
$I = Invoke-RestMethod -Method GET -URI $URL -Headers $headers
$I.value.'odata.id'

$I.value.'odata.id' | ForEach-Object {
    $Token = (Get-AzAccessToken -ResourceUrl 'https://storage.azure.com/').Token
    $URL = $_
    $Date = Get-Date (Get-Date).ToUniversalTime() -Format 'R'
    $headers = @{
        "Authorization" = "Bearer $Token"
        "x-ms-date"     = $Date
        "Content-type"  = "application/json"
        "x-ms-version"  = "2020-04-08"
        "Accept"        = "application/json;odata=fullmetadata"
        "If-Match"      = "*"
    }
    $I = Invoke-RestMethod -Method Delete -URI $URL -Headers $headers #-Body $Body
    $I

    $Token = (Get-AzAccessToken -ResourceUrl 'https://storage.azure.com/').Token
$URL = "https://stterraform0001.file.core.windows.net/file01/karolsfil.txt"
$Date = Get-Date (Get-Date).ToUniversalTime() -Format 'R'
$headers = @{
    "Authorization"       = "Bearer $Token"
    "x-ms-date"           = $Date
    "x-ms-version"        = "2022-11-02"
    "x-ms-content-length" = 1000000
    "x-ms-type"           = "file"
    "x-ms-file-request-intent" = "backup"
}
$I = Invoke-RestMethod -Method PUT -URI $URL -Headers $headers
$I

$Token = (Get-AzAccessToken -ResourceUrl 'https://storage.azure.com/').Token
$URL = "https://stterraform0001.file.core.windows.net/file01/matrix.jpg"
$Date = Get-Date (Get-Date).ToUniversalTime() -Format 'R'
$headers = @{
    "Authorization"       = "Bearer $Token"
    "x-ms-date"           = $Date
    "x-ms-version"        = "2022-11-02"
    "x-ms-file-request-intent" = "backup"
}
$I = Invoke-RestMethod -Method GET -URI $URL -Headers $headers
$I

$Token = (Get-AzAccessToken -ResourceUrl 'https://storage.azure.com/').Token
$URL = "https://stterraform0001.file.core.windows.net/file01?restype=directory&comp=list"
$Date = Get-Date (Get-Date).ToUniversalTime() -Format 'R'
$headers = @{
    "Authorization"       = "Bearer $Token"
    "x-ms-date"           = $Date
    "x-ms-version"        = "2022-11-02"
    "x-ms-file-request-intent" = "backup"
}
$I = Invoke-RestMethod -Method GET -URI $URL -Headers $headers
$I
}
##Upload files
$Token = (Get-AzAccessToken -ResourceUrl 'https://storage.azure.com/').Token
$URL = "https://stabcprod01.blob.core.windows.net/abc/README.md"
$Date = Get-Date (Get-Date).ToUniversalTime() -Format 'R'
$Content = Get-Content .\README.md
$headers = @{
    "Authorization"  = "Bearer $Token"
    "x-ms-date"      = $Date
    "Content-type"   = "application/octet-stream"
    "x-ms-version"   = "2020-04-08"
    "Accept"         = "application/octet-stream;odata=fullmetadata"
    "x-ms-blob-content-disposition" = "attachment" 
    "x-ms-blob-type"= "BlockBlob"  
}

$I = Invoke-RestMethod -Method PUT -URI $URL -Headers $headers -Body $Content
$I

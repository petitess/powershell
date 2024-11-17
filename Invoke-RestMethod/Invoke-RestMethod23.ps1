$SAS = "sv=2022-11-02&ss=t&srt=sco&sp=xxxxx"
$URL = "https://sttrustprod01.table.core.windows.net/cars?$SAS"
$Date = Get-Date (Get-Date).ToUniversalTime() -Format 'R'
$headers = @{
    "x-ms-date"    = $Date
    "x-ms-version" = "2020-04-08"
    "Accept"       = "application/json"
}

$I = Invoke-RestMethod -Method GET -URI $URL -Headers $headers
$I


$SAS = "sv=2022-11-02&ss=t&srt=sco&sp=xxxxx"
$URL = "https://sttrustprod01.table.core.windows.net/cars?$SAS"
$Date = Get-Date (Get-Date).ToUniversalTime() -Format 'R'
$Body = ConvertTo-Json @{
    "PartitionKey" = "cars"
    "RowKey"       = ([guid]::NewGuid().tostring())
    "make"         = "Honda"
    "model"        = "Accord"
    "year"         = "2022"
    "color"        = "black"
}
$headers = @{
    "x-ms-date"      = $Date
    "x-ms-version"   = "2020-04-08"
    "Accept"         = "application/json"
    "Content-Length" = $Body.Length
    "Content-type"   = "application/json"
}

$I = Invoke-WebRequest -Method Post -URI $URL -Headers $headers -Body $Body
$I


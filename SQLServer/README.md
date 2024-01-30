```pwsh
Install-Module SQLServer
```
```pwsh
$I = Invoke-Sqlcmd `
-Query "SELECT TOP (10) * from [$Database].dbo.Stocks ORDER by Id DESC" `
-ServerInstance $Server `
-Database $Database `
-Username $Username `
-Password $Password `
-ConnectionTimeout 15 `
-TrustServerCertificate

$I | ForEach-Object {
    Write-Output $($_.Symbol.ToString() + " " + $_.CompanyName + " " + $_.MarketCap.ToString())
}
```

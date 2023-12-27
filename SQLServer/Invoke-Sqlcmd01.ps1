$Server = "DESKTOP-CFCPFSG"
$Database = "Database01"
$Username = "sa" 
$Password = "12345"

$X = @(
    [pscustomobject]@{Symbol = 'TSLA'; CompanyName = 'Tesla Inc';  Purchase = 200; LastDiv = 0; Industry = 'Automotive'; MarketCap = 834000156000}
    [pscustomobject]@{Symbol = 'INTC'; CompanyName = 'Intel Corporation';  Purchase = 30; LastDiv = 0.5; Industry = 'Technology'; MarketCap = 212000424000}
    [pscustomobject]@{Symbol = 'NIO'; CompanyName = 'Nio Inc';  Purchase = 10; LastDiv = 0; Industry = 'Steel'; MarketCap = 16000452000}
    [pscustomobject]@{Symbol = 'MMM'; CompanyName = '3M Company';  Purchase = 100; LastDiv = 6; Industry = 'Consumer goods'; MarketCap = 60452000532}
    [pscustomobject]@{Symbol = 'BA'; CompanyName = 'Boeing Co';  Purchase = 200; LastDiv = 0; Industry = 'Transportation'; MarketCap = 0}
)

$X | Where-Object {
Invoke-Sqlcmd `
-Query @"
INSERT INTO Stocks
    (
    [Symbol],
	[CompanyName],
	[Purchase],
	[LastDiv],
	[Industry],
	[MarketCap]
    )
VALUES
    ( 
	'$($_.Symbol)',
    '$($_.CompanyName)',
    $($_.Purchase),
    $($_.LastDiv),
    '$($_.Industry)',
    $($_.MarketCap)
	)
"@ `
-ServerInstance $Server `
-Database $Database `
-Username $Username `
-Password $Password `
-ConnectionTimeout 15 `
-TrustServerCertificate
}

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

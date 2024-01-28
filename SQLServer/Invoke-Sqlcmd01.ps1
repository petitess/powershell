$Server = "DESKTOP-CFCPFSG"
$Database = "Database01"
$Username = "sa" 
$Password = "12345"

$X = @(
    [pscustomobject]@{Symbol = 'TSLA'; CompanyName = 'Tesla Inc';  Purchase = 200; LastDiv = 0; Industry = 'Automotive'; MarketCap = 834000156000}
    [pscustomobject]@{Symbol = 'INTC'; CompanyName = 'Intel Corporation';  Purchase = 30; LastDiv = 0.5; Industry = 'Technology'; MarketCap = 212000424000}
    [pscustomobject]@{Symbol = 'NIO'; CompanyName = 'Nio Inc';  Purchase = 10; LastDiv = 0; Industry = 'Steel'; MarketCap = 16000452000}
    [pscustomobject]@{Symbol = 'MMM'; CompanyName = '3M Company';  Purchase = 100; LastDiv = 6; Industry = 'Consumer goods'; MarketCap = 60452000532}
    [pscustomobject]@{Symbol = 'BA'; CompanyName = 'Boeing Co';  Purchase = 200; LastDiv = 0; Industry = 'Transportation'; MarketCap = 120452000532}
    [pscustomobject]@{Symbol = 'AXP'; CompanyName = 'American Express Company';  Purchase = 150; LastDiv = 2; Industry = 'Banking'; MarketCap = 135452000532}
    [pscustomobject]@{Symbol = 'AAPL'; CompanyName = 'Apple Inc';  Purchase = 160; LastDiv = 0; Industry = 'Technology'; MarketCap = 3135452000532}
    [pscustomobject]@{Symbol = 'CSCO'; CompanyName = 'Cisco Systems Inc';  Purchase = 50; LastDiv = 1; Industry = 'Technology'; MarketCap = 220452000532}
    [pscustomobject]@{Symbol = 'MCD'; CompanyName = 'McDonalds Corporation';  Purchase = 200; LastDiv = 6; Industry = 'Food'; MarketCap = 220332000532}
    [pscustomobject]@{Symbol = 'JNJ'; CompanyName = 'Johnson & Johnson';  Purchase = 100; LastDiv = 4; Industry = 'Medical technologies'; MarketCap = 320452000532}
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


$Y = @(
    [pscustomobject]@{Title = 'Tesla stock rocks'; Content = 'Tesla is undervalued';  StockId = 1}
    [pscustomobject]@{Title = 'Microsoft is growing'; Content = 'Sales hit all-time high. Test';  StockId = 2}
    [pscustomobject]@{Title = 'Azure grew 9% in a year'; Content = 'Azure Open AI gets attention';  StockId = 2}
    [pscustomobject]@{Title = 'Love Tesla'; Content = 'I love tesla stock';  StockId = 1} 
    [pscustomobject]@{Title = 'Johnson & Johnson to pay $150M'; Content = 'Johnson & Johnson to pay nearly $150M over its role fueling opioid epidemic';  StockId = 11} 
    [pscustomobject]@{Title = 'Johnson & Johnson to pay $700M'; Content = 'Johnson & Johnson to Pay $700 Million to Settle Baby Powder Probe';  StockId = 11} 
)

$Y | Where-Object {
Invoke-Sqlcmd `
-Query @"
INSERT INTO Comments
    (
    [Title],
    [Content],
    [CreatedOn],
    [StockId]
    )
VALUES
    ( 
	'$($_.Title)',
    '$($_.Content)',
    '$(Get-Date -Format "yyyy-MM-dd HH:mm")',
    $($_.StockId)
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

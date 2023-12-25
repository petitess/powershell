$I = Invoke-Sqlcmd `
-Query "SELECT TOP (10) * from [sqldb-weather-01].dbo.WeatherInfo ORDER by Id DESC" `
-ServerInstance "sql-x-prod-01.database.windows.net" `
-Database "sqldb-weather-01" `
-Username "azadmin" `
-Password "x" `
-ConnectionTimeout 10

$I | ForEach-Object {
    Write-Output $($_.Temperature.ToString() + " " + $_.City + " " + $_.Localtime)
}

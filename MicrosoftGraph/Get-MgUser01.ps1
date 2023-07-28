Get-MgUser -All

Get-MgUser -Filter "DisplayName eq 'Karol'"

Get-MgUser -Filter "startsWith(DisplayName, 'A')"

Get-MgUser -Filter 'accountEnabled eq true' -All

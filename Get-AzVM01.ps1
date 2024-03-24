$azureSubs = Get-AzSubscription
$azureSubs | ForEach-Object {Select-AzSubscription $_ | Out-Null; Get-AzVM -WarningAction SilentlyContinue}

$IpList = @(
    [PSCustomObject]@{ip = '10.107.2.20'; name = 'func-formmanager-dev-01'; zone = 'privatelink.azurewebsites.net' }
    [PSCustomObject]@{ip = '10.107.2.20'; name = 'func-formmanager-dev-01.scm'; zone = 'privatelink.azurewebsites.net' }
    [PSCustomObject]@{ip = '10.107.5.28'; name = 'kv-abc-dev-01'; zone = 'privatelink.vaultcore.azure.net' }
    [PSCustomObject]@{ip = '10.107.5.11'; name = 'stfuncabcdev01'; zone = 'privatelink.blob.core.windows.net' }
    [PSCustomObject]@{ip = '10.107.5.27'; name = 'stdocabcdev01'; zone = 'privatelink.blob.core.windows.net' }
    [PSCustomObject]@{ip = '10.107.4.8'; name = 'sql-app-abc-dev-01'; zone = 'privatelink.database.windows.net' }
)

$IpList | ForEach-Object {
    Add-DnsServerResourceRecordA `
        -ComputerName "vmdcprod01" `
        -ZoneName $_.zone `
        -Name $_.name `
        -IPv4Address $_.ip
} 

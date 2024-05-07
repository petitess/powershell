$ZoneName = "xxx.se"
$RgZoneName = "publicdns"
#A Resource Id
Get-AzDnsRecordSet -ZoneName $ZoneName `
-ResourceGroupName $RgZoneName `
-RecordType A | Where-Object {$null -ne $_.TargetResourceId} | Select-Object `
@{label="name"; Expression = {$_.Name}}, `
@{label="targetResource"; Expression = {$_.TargetResourceId}} | ConvertTo-Json

#A IP address
Get-AzDnsRecordSet -ZoneName $ZoneName `
-ResourceGroupName $RgZoneName `
-RecordType A | Where-Object {$_.Records.Count -gt 0} | Select-Object `
@{label="name"; Expression = {$_.Name}}, `
@{label="ipv4Address"; Expression = {$_.Records[0].Ipv4Address}} | ConvertTo-Json

#CNAME name
Get-AzDnsRecordSet -ZoneName $ZoneName `
-ResourceGroupName $RgZoneName `
-RecordType CNAME | Where-Object {$_.Records.Count -gt 0} | Select-Object `
@{label="name"; Expression = {$_.Name}}, `
@{label="cname"; Expression = {$_.Records[0].Cname}} | ConvertTo-Json

#CNAME Resource Id
Get-AzDnsRecordSet -ZoneName $ZoneName `
-ResourceGroupName $RgZoneName `
-RecordType CNAME | Where-Object {$null -ne $_.TargetResourceId} | Select-Object `
@{label="name"; Expression = {$_.Name}}, `
@{label="targetResource"; Expression = {$_.TargetResourceId}} | ConvertTo-Json

#MX
Get-AzDnsRecordSet -ZoneName $ZoneName `
-ResourceGroupName $RgZoneName `
-RecordType MX | Select-Object `
@{label="name"; Expression = {$_.Name}}, `
@{label="exchange"; Expression = {$_.Records}} | ConvertTo-Json

#NS
Get-AzDnsRecordSet -ZoneName $ZoneName `
-ResourceGroupName $RgZoneName `
-RecordType NS | Select-Object `
@{label="name"; Expression = {$_.Name}}, `
@{label="records"; Expression = {$_.Records}} | ConvertTo-Json

#PTR
Get-AzDnsRecordSet -ZoneName $ZoneName `
-ResourceGroupName $RgZoneName `
-RecordType PTR

#SOA
Get-AzDnsRecordSet -ZoneName $ZoneName `
-ResourceGroupName $RgZoneName `
-RecordType SOA | Select-Object `
@{label="name"; Expression = {$_.Name}}, `
@{label="SOARecord"; Expression = {$_.Records}} | ConvertTo-Json

#SRV
Get-AzDnsRecordSet -ZoneName $ZoneName `
-ResourceGroupName $RgZoneName `
-RecordType SRV | Select-Object `
@{label="name"; Expression = {$_.Name}}, `
@{label="SRVRecords"; Expression = {$_.Records}} | ConvertTo-Json

#TXT version 1
Get-AzDnsRecordSet -ZoneName $ZoneName `
-ResourceGroupName $RgZoneName `
-RecordType TXT | Select-Object `
@{label="name"; Expression = {$_.Name}}, `
@{label="TXTRecords"; Expression = {$_.Records}} | ConvertTo-Json

#TXT version 2
$Token = (Get-AzAccessToken).Token
$SubId = "x-ed09cf9d9043"
$RgName = "publicdns"
$URL = "https://management.azure.com/subscriptions/$SubId/resourceGroups/$RgName/providers/Microsoft.Network/dnsZones/$ZoneName/TXT?api-version=2023-07-01-preview"
$headers = @{
    "Authorization" = "Bearer $Token"
    "Content-type"  = "application/json"
}
$TXT = (Invoke-RestMethod -Method GET -URI $URL -Headers $headers).value #| ConvertTo-Json

$TXT | ForEach-Object {
    $_ | Select-Object `
    @{label = 'name'; Expression = { $_.name } }, `
    @{label = 'TXTRecords'; Expression = { $_.properties.TXTRecords } } | ConvertTo-Json
}

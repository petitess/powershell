$RG = "rg-alert-xx-guld"
$gold = Get-AzScheduledQueryRule -ResourceGroupName $RG | Select-Object Name, Enabled, Id
#disable
$gold | ForEach-Object {
    $enabled = Get-AzResource -ResourceId $_.Id
    $enabled.Properties.enabled = "False"
    $enabled | Set-AzResource -Force
}
#enable
$gold | ForEach-Object {
    Update-AzScheduledQueryRule -Name $_.Name  -ResourceGroupName $RG -Enabled
}

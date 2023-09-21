$ApiNames = (Get-AzApplicationInsightsWebTest).Name
$Status = "True" #"False"

$allWebtests = Get-AzResource -ResourceGroupName $ResourceGroupName `
| Where-Object -Property ResourceType -EQ "microsoft.insights/webtests"

ForEach ($ApiName in $ApiNames) {
    $alertId = $allWebtests | Where-Object {$_.Name -like "$ApiName*"} `
    | Select-Object -ExpandProperty ResourceId
    $enabled = Get-AzResource -ResourceId $alertId
    $enabled.Properties.Enabled = $Status
    $enabled | Set-AzResource -Force
}

Connect-AzAccount
Set-AzContext "sub-b3care-test-01"
Get-AzContext

$Temp = (Get-date).AddDays(-30)
$date = Get-Date $Temp -Format "yyyy/MM/dd HH:mm:ss"
$date
$deploy = Get-AzDeployment | Where-Object { $_.Timestamp -lt $date }
$deploy | ForEach-Object {
    Remove-AzDeployment -Name $_.DeploymentName
}

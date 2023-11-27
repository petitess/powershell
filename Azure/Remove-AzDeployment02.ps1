$subscriptions = @(
    'sub-xxx-test-01'
)

$subscriptions | ForEach-Object {
    $con = Set-AzContext -Subscription $_
    Write-Output "$(($con.Subscription.Name).ToUpper()):"
    $Temp = (Get-date).AddDays(-1)
    $date = Get-Date $Temp -Format "yyyy/MM/dd HH:mm:ss"
    $deploy = Get-AzDeployment | Where-Object { $_.Timestamp -lt $date }
    $deploy | ForEach-Object {
        Remove-AzDeployment -Name $_.DeploymentName
        Write-Output "Removed: $($_.DeploymentName)"
    }
    $RGs = Get-AzResourceGroup
    $RGs | ForEach-Object {
        Write-Output "$(($_.ResourceGroupName).ToUpper()):"
        $deployRg = Get-AzResourceGroupDeployment -ResourceGroupName $_.ResourceGroupName | Where-Object { $_.Timestamp -lt $date }
        $deployRg | ForEach-Object {
            Remove-AzResourceGroupDeployment -ResourceGroupName $_.ResourceGroupName -Name $_.DeploymentName
            Write-Output "Removed: $($_.DeploymentName)"
        }
    }
}

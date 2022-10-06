$rgname = "rg-infra-prod-sc-01"
$aaname = "aa-infra-prod-01"
$runname = "run-test01"
$schename = "StopVM01"
$starttime = "23:00"
$guid = ((New-Guid).Guid).substring(0,8)

$aa = Get-AzAutomationAccount -ResourceGroupName $rgname -AutomationAccountName $aaname

$run = Get-AzAutomationRunbook -AutomationAccountName $aa.AutomationAccountName -ResourceGroupName $aa.ResourceGroupName | Where-Object {$_.AutomationAccountName -eq $runname}

if ($null -eq $run) {
New-AzAutomationRunbook -Name $runname -AutomationAccountName $aa.AutomationAccountName -Type PowerShell -ResourceGroupName $aa.ResourceGroupName
}

if ($null -eq $run) {
Publish-AzAutomationRunbook -Name $runname -ResourceGroupName $aa.ResourceGroupName -AutomationAccountName $aa.AutomationAccountName
}

New-AzAutomationSchedule -Name $schename -AutomationAccountName $aa.AutomationAccountName -ResourceGroupName $aa.ResourceGroupName -StartTime $starttime -DayInterval 1 -TimeZone "Europe/Berlin"


Register-AzAutomationScheduledRunbook -RunbookName $runname -ScheduleName $schename -AutomationAccountName $aa.AutomationAccountName -ResourceGroupName $aa.ResourceGroupName
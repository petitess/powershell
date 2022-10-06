$rgname = "rg-infra-prod-sc-01"
$aaname = "aa-infra-prod-01"
$runname = "run-test01"
$schename = "StopVM01"
$starttime = "12:45"

$aa = Get-AzAutomationAccount -ResourceGroupName $rgname -AutomationAccountName $aaname

$run = Get-AzAutomationRunbook -AutomationAccountName $aa.AutomationAccountName -ResourceGroupName $aa.ResourceGroupName | Where-Object {$_.Name -eq $runname}

$sche = Get-AzAutomationScheduledRunbook -AutomationAccountName $aa.AutomationAccountName -ResourceGroupName $aa.ResourceGroupName | Where-Object {$_.RunbookName -eq $runname}

if ($null -eq $run) {
New-AzAutomationRunbook -Name $runname -AutomationAccountName $aa.AutomationAccountName -Type PowerShell -ResourceGroupName $aa.ResourceGroupName
}

if ($null -eq $run) {
Publish-AzAutomationRunbook -Name $runname -ResourceGroupName $aa.ResourceGroupName -AutomationAccountName $aa.AutomationAccountName
}

New-AzAutomationSchedule -Name $schename -AutomationAccountName $aa.AutomationAccountName -ResourceGroupName $aa.ResourceGroupName -StartTime $starttime -DayInterval 1 -TimeZone "Europe/Berlin"

if ($null -eq $sche) {
Register-AzAutomationScheduledRunbook -RunbookName $runname -ScheduleName $schename -AutomationAccountName $aa.AutomationAccountName -ResourceGroupName $aa.ResourceGroupName
}


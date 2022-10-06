$rgname = "rg-infra-prod-sc-01"
$aaname = "aa-infra-prod-01"
$runname = "run-test01"
$schename = "StopVM01-test"
$starttime = "12:45"

$now = Get-Date -UFormat "%R"
$time = "20:00"
$Temp = (Get-date).AddDays(1)
$tomorrow = Get-Date $Temp -UFormat "%m/%d/%Y $time"
$today = Get-Date -UFormat "%m/%d/%Y $time"

$aa = Get-AzAutomationAccount -ResourceGroupName $rgname -AutomationAccountName $aaname

$run = Get-AzAutomationRunbook -AutomationAccountName $aa.AutomationAccountName -ResourceGroupName $aa.ResourceGroupName | Where-Object {$_.Name -eq $runname}

$sche = Get-AzAutomationScheduledRunbook -AutomationAccountName $aa.AutomationAccountName -ResourceGroupName $aa.ResourceGroupName | Where-Object {$_.RunbookName -eq $runname}

if ($null -eq $run) {
New-AzAutomationRunbook -Name $runname -AutomationAccountName $aa.AutomationAccountName -Type PowerShell -ResourceGroupName $aa.ResourceGroupName
}

if ($null -eq $run) {
Publish-AzAutomationRunbook -Name $runname -ResourceGroupName $aa.ResourceGroupName -AutomationAccountName $aa.AutomationAccountName
}

if ($null -eq $sche) {
if ($now -ge "19:55"){
New-AzAutomationSchedule -Name $schename -AutomationAccountName $aa.AutomationAccountName -ResourceGroupName $aa.ResourceGroupName -StartTime $tomorrow -DayInterval 1 -TimeZone "Europe/Berlin"
}else {
New-AzAutomationSchedule -Name $schename -AutomationAccountName $aa.AutomationAccountName -ResourceGroupName $aa.ResourceGroupName -StartTime $today -DayInterval 1 -TimeZone "Europe/Berlin"
}
}

if ($null -eq $sche) {
Register-AzAutomationScheduledRunbook -RunbookName $runname -ScheduleName $schename -AutomationAccountName $aa.AutomationAccountName -ResourceGroupName $aa.ResourceGroupName
}

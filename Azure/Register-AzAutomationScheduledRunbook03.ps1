$now = Get-Date -UFormat "%R"
$temp = (Get-date).AddDays(1)
$tomorrow = Get-Date $temp -UFormat "%m/%d/%Y"
$today = Get-Date -UFormat "%m/%d/%Y"


$aaname = "aa-infra-prod-01"
$runbookname01 = "run-BackupSqlVm01"
$infrargname = "rg-infra-prod-sc-01"
$schedulename01 = "sch-BackupSqlVm01"
$schedulename02 = "sch-BackupSqlVm02"
$schedulename03 = "sch-BackupSqlVm03"
$scheduletime01 = "10:00:00"
$scheduletime02 = "13:00:00"
$scheduletime03 = "16:00:00"

#create and connect first schedule
$sche01 = Get-AzAutomationSchedule -ResourceGroupName $infrargname `
-AutomationAccountName $aaname | Where-Object {$_.Name -eq $schedulename01}
if ($null -eq $sche01) {
    if ($now -ge "09:55"){
    New-AzAutomationSchedule -Name $schedulename01 `
    -AutomationAccountName $aaname -ResourceGroupName $infrargname `
    -StartTime "$tomorrow $scheduletime01" -DayInterval 1 -TimeZone "Europe/Berlin"
    }else {
    New-AzAutomationSchedule -Name $schedulename01 `
    -AutomationAccountName $aaname -ResourceGroupName $infrargname `
    -StartTime "$today $scheduletime01" -DayInterval 1 -TimeZone "Europe/Berlin"
    }
    }
$reg01 = Get-AzAutomationScheduledRunbook `
-AutomationAccountName $aaname `
-ResourceGroupName $infrargname | Where-Object {$_.ScheduleName -eq $scheduletime01}
if ($null -eq $reg01) {
Register-AzAutomationScheduledRunbook -RunbookName $runbookname01 `
-ScheduleName $schedulename01 -AutomationAccountName $aaname -ResourceGroupName $infrargname
}

#create and connect second schedule
$sche02 = Get-AzAutomationSchedule -ResourceGroupName $infrargname `
-AutomationAccountName $aaname | Where-Object {$_.Name -eq $schedulename02}
if ($null -eq $sche02) {
    if ($now -ge "12:55"){
    New-AzAutomationSchedule -Name $schedulename02 `
    -AutomationAccountName $aaname -ResourceGroupName $infrargname `
    -StartTime "$tomorrow $scheduletime02" -DayInterval 1 -TimeZone "Europe/Berlin"
    }else {
    New-AzAutomationSchedule -Name $schedulename03 `
    -AutomationAccountName $aaname -ResourceGroupName $infrargname `
    -StartTime "$today $scheduletime02" -DayInterval 1 -TimeZone "Europe/Berlin"
    }
    }
$reg02 = Get-AzAutomationScheduledRunbook `
-AutomationAccountName $aaname `
-ResourceGroupName $infrargname | Where-Object {$_.ScheduleName -eq $scheduletime02}
if ($null -eq $reg02) {
Register-AzAutomationScheduledRunbook -RunbookName $runbookname01 `
-ScheduleName $schedulename02 -AutomationAccountName $aaname -ResourceGroupName $infrargname
}


#create and connect third schedule
$sche03 = Get-AzAutomationSchedule -ResourceGroupName $infrargname `
-AutomationAccountName $aaname | Where-Object {$_.Name -eq $schedulename03}
if ($null -eq $sche03) {
    if ($now -ge "15:55"){
    New-AzAutomationSchedule -Name $schedulename03 `
    -AutomationAccountName $aaname -ResourceGroupName $infrargname `
    -StartTime "$tomorrow $scheduletime03" -DayInterval 1 -TimeZone "Europe/Berlin"
    }else {
    New-AzAutomationSchedule -Name $schedulename03 `
    -AutomationAccountName $aaname -ResourceGroupName $infrargname `
    -StartTime "$today $scheduletime03" -DayInterval 1 -TimeZone "Europe/Berlin"
    }
    }
$reg03 = Get-AzAutomationScheduledRunbook `
-AutomationAccountName $aaname `
-ResourceGroupName $infrargname | Where-Object {$_.ScheduleName -eq $scheduletime03}
if ($null -eq $reg03) {
Register-AzAutomationScheduledRunbook -RunbookName $runbookname01 `
-ScheduleName $schedulename03 -AutomationAccountName $aaname -ResourceGroupName $infrargname
}



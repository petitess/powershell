$now = Get-Date -UFormat "%R"
$temp = (Get-date).AddDays(1)
$tomorrow = Get-Date $temp -UFormat "%m/%d/%Y "
$today = Get-Date -UFormat "%m/%d/%Y "

$aaname = "aa-infra-prod-01"
$runbookname01 = "run-BackupSqlVm01"
$infrargname = "rg-infra-prod-sc-01"

$schedules = @(
    [pscustomobject]@{name = 'sch-BackupSqlVm06'; time = '10:00:00'; pre = '09:55' }
    [pscustomobject]@{name = 'sch-BackupSqlVm05'; time = '13:00:00'; pre = '12:55' }
    [pscustomobject]@{name = 'sch-BackupSqlVm04'; time = '16:00:00'; pre = '15:55' }
)

foreach ($schedule in $schedules) {
    $sche01 = Get-AzAutomationSchedule -ResourceGroupName $infrargname `
        -AutomationAccountName $aaname | Where-Object { $_.Name -eq $schedule.name }
    if ($null -eq $sche01) {
        if ($now -ge $schedule.pre) {
            New-AzAutomationSchedule -Name $schedule.name `
                -AutomationAccountName $aaname -ResourceGroupName $infrargname `
                -StartTime "$($tomorrow)$($schedule.time)" -DayInterval 1 -TimeZone "Europe/Berlin"
        }
        else {
            New-AzAutomationSchedule -Name $schedule.name `
                -AutomationAccountName $aaname -ResourceGroupName $infrargname `
                -StartTime "$($today)$($schedule.time)" -DayInterval 1 -TimeZone "Europe/Berlin"
        }
    }
    $reg01 = Get-AzAutomationScheduledRunbook `
        -AutomationAccountName $aaname `
        -ResourceGroupName $infrargname | Where-Object { $_.ScheduleName -eq $schedule.name }
    if ($null -eq $reg01) {
        Register-AzAutomationScheduledRunbook -RunbookName $runbookname01 `
            -ScheduleName $schedule.name -AutomationAccountName $aaname -ResourceGroupName $infrargname
    }
}

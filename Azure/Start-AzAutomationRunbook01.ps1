$holidays = $(
    '2023-12-25'
    '2023-12-26'
    '2024-01-01'
    '2024-03-29'
    '2024-04-01'
    '2024-05-01'
    '2024-05-09'
    '2024-06-06'
    '2024-12-25'
    '2024-12-26'
)

$holidays | ForEach-Object {
    $today = Get-Date -Format "yyyy/MM/dd"
    if ($_ -eq $today) {
        Write-Output "Holiday. Shutting down unused VMs"
        Start-AzAutomationRunbook -Name "run-TryStopVm01" -ResourceGroupName "rg-aa-prod-01" -AutomationAccountName "aa-prod-01"
        Start-AzAutomationRunbook -Name "run-TryStopVm02" -ResourceGroupName "rg-aa-prod-01" -AutomationAccountName "aa-prod-01"
        Start-AzAutomationRunbook -Name "run-TryStopVm03" -ResourceGroupName "rg-aa-prod-01" -AutomationAccountName "aa-prod-01"
        Start-AzAutomationRunbook -Name "run-TryStopVm04" -ResourceGroupName "rg-aa-prod-01" -AutomationAccountName "aa-prod-01"
    }
    else {
        Write-Output "Business day. No action."
    }
}

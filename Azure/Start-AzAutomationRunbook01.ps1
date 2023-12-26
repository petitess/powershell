$day = (Get-Date).DayOfWeek
$holidays = $(
    '2023-12-25'
    '2023-12-26'
    '2024-01-01'
    '2024-03-28'
    '2024-03-29'
    '2024-04-01'
    '2024-05-01'
    '2024-05-09'
    '2024-05-20'
    '2024-06-06'
    '2024-06-21'
    '2024-06-22'
    '2024-12-23'
    '2024-12-24'
    '2024-12-25'
    '2024-12-26'
    '2024-12-30'
    '2024-12-31'
)

$holidays | ForEach-Object {
    $today = (Get-Date -Format "yyyy-MM-dd")
    if ($_ -eq $today) {
        Write-Output "Röd dag. Stänger ner VDA. $($_)"
        Start-AzAutomationRunbook -Name "run-TryStopVm01" -ResourceGroupName "rg-aa-prod-01" -AutomationAccountName "aa-prod-01"
        Start-AzAutomationRunbook -Name "run-TryStopVm02" -ResourceGroupName "rg-aa-prod-01" -AutomationAccountName "aa-prod-01"
        Start-AzAutomationRunbook -Name "run-TryStopVm03" -ResourceGroupName "rg-aa-prod-01" -AutomationAccountName "aa-prod-01"
        Start-AzAutomationRunbook -Name "run-TryStopVm04" -ResourceGroupName "rg-aa-prod-01" -AutomationAccountName "aa-prod-01"
    }
    else {

        Write-Output "No action. $(Get-Date -Format "yyyy-MM-dd") ≠ $($_)"
    }
}

if ($day -eq "Saturday" -or $day -eq "Sunday"){
    Start-AzAutomationRunbook -Name "run-TryStopVm01" -ResourceGroupName "rg-aa-prod-01" -AutomationAccountName "aa-prod-01"
    Start-AzAutomationRunbook -Name "run-TryStopVm02" -ResourceGroupName "rg-aa-prod-01" -AutomationAccountName "aa-prod-01"
    Start-AzAutomationRunbook -Name "run-TryStopVm03" -ResourceGroupName "rg-aa-prod-01" -AutomationAccountName "aa-prod-01"
    Start-AzAutomationRunbook -Name "run-TryStopVm04" -ResourceGroupName "rg-aa-prod-01" -AutomationAccountName "aa-prod-01"
    $testVDA = (Get-AzVM -Name "vmvdatest01")
    Stop-AzVM -ResourceGroupName $testVDA.ResourceGroupName -Name $testVDA.Name -Force
}

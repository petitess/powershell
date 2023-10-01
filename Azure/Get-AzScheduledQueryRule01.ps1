$sub = Get-AzSubscription

$sub | ForEach-Object {
    Set-AzContext -Subscription $_.Name
    $agName = "AG-Critical-Guld-LogAnalytics"
    $ag = Get-AzActionGroup | Where-Object {$_.Name -eq $agName}
    Get-AzScheduledQueryRule | Where-Object { $_.ActionGroup -eq $ag.id } | Select-Object Name, {$ag.Name} | Out-File ($agName + ".txt") -Append
} 

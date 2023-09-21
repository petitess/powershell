$TagKey = "AutoShutdown"
$TagValues = "GroupC"

$VMs = Get-AzVM | Where-Object { $_.Tags.Keys -eq $TagKey -and $_.Tags.Values -eq $TagValues }

ForEach ($VM in $VMs) {
    $scriptCode = @'
$X = ((query user) -split "\n" -replace '\s\s+', ';' | convertfrom-csv -Delimiter ';').STATE
if ($X -contains "Active") {
    Write-Output "ActiveUsers"
    }else{
    Write-Output "ShutdownSystem"
    }
'@

    $I = Invoke-AzVMRunCommand -ResourceGroupName $VM.ResourceGroupName -Name $VM.Name -CommandId 'RunPowerShellScript' -ScriptString $scriptCode
    $output = $I.Value[0].Message

    if ($output -eq "ShutdownSystem") {

        #Stop-AzVM -ResourceGroupName $VM.ResourceGroupName -Name $VM.Name -Force
        Write-Output "$($VM.Name) No active users on the system" ##$VM.Name
    }else {
        Write-Output "$($VM.Name) Active users on the system"
    }
}

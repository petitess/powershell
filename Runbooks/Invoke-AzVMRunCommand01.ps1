Connect-AzAccount -Identity

$scriptCode = @'
$SvcName = 'cLABatchService'
Start-Service -Name $SvcName
$Svc =  (Get-Service $SvcName).DisplayName
$Status = (Get-Service $SvcName).Status
Write-Output "$Svc $Status"
'@
$I = Invoke-AzVMRunCommand -ResourceGroupName 'rg-vmclatest01' -Name 'vmclatest01' -CommandId 'RunPowerShellScript' -ScriptString $scriptCode
$output = $I.Value[0].Message
Write-Output $output

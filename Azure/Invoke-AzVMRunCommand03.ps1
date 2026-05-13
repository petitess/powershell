Connect-AzAccount -Identity

$ErrorActionPreference = 'Stop'

$localmachineScript = @'
$ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest -Uri https://aka.ms/installazurecliwindowsx64 -OutFile .\AzureCLI.msi; Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'; Remove-Item .\AzureCLI.msi
'@

$VmList = @(
    'vmmgmtprod01'
    'vmmgmtprod02'
    'vmmgmtprod03'
    'vmvenprod01'
    'vmvenprod02'
    'vmvenprod03'
    'vmvenprod04'
)

$VMs = Get-AzVM -Status | Where-Object { $_.Name -in $VmList -and $_.PowerState -eq "VM running" }

$VMs | ForEach-Object -Verbose {
    $rgname = $_.ResourceGroupName
    $vmname = $_.Name
    Invoke-AzVMRunCommand -ResourceGroupName $rgname -Name $vmname -CommandId 'RunPowerShellScript' -ScriptString $localmachineScript
    Write-Output "Azure CLI installed on $vmname in $rgname"
}

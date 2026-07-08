$VMs = @(
    [pscustomobject]@{ Name = "vm01"; RgName = "rg-vm01"; SubName = "sub-prod01" }
    [pscustomobject]@{ Name = "vm02"; RgName = "rg-vm02"; SubName = "sub-prod01" }
    [pscustomobject]@{ Name = "vm03"; RgName = "rg-vm03"; SubName = "sub-prod01" }
)

ForEach ($VM in $VMs) {
    Set-AzContext -Subscription $VM.SubName
    # Invoke-AzVMInstallPatch  `
    #     -ResourceGroupName $VM.RgName `
    #     -VMName $VM.Name `
    #     -Windows `
    #     -RebootSetting IfRequired `
    #     -MaximumDuration PT1H `
    #     -ClassificationToIncludeForWindows Critical, Security, Definition
    Write-Output "Patched: $($VM.VmName)"
}
#################
#Run Visual Studio Installer
$VMs = @(
    [pscustomobject]@{ Name = "vmvenprod01"; RgName = "rg-vmvenprod01" }
    [pscustomobject]@{ Name = "vmvenprod02"; RgName = "rg-vmvenprod02" }
    [pscustomobject]@{ Name = "vmvenprod03"; RgName = "rg-vmvenprod03" }
    [pscustomobject]@{ Name = "vmvenprod04"; RgName = "rg-vmvenprod04" }
)
$localmachineScript = @'
Start-Process -Wait -FilePath "C:\Program Files (x86)\Microsoft Visual Studio\Installer\vs_installer.exe" -ArgumentList "updateall --quiet --norestart"
'@

$VMs[0] | ForEach-Object {
    $VM = $_
    Write-Output "Start Date: $(Get-Date -Format "dd-MMMM-yyyy hh:mm")"
    Write-Output "Checking: $($VM.Name)"
    $VMX = Get-AzVM -Status | Where-Object { $_.PowerState -match "VM running" -and $_.Name -eq $VM.Name -and $_.ResourceGroupName -eq $VM.RgName } 
    if ($VMX) {
        Write-Output "Running: $($VM.Name)"
        $RunC = Invoke-AzVMRunCommand -ResourceGroupName $VM.RgName -Name $VM.Name -CommandId 'RunPowerShellScript' -ScriptString $localmachineScript
        Write-Output "Run Command Result1: $($RunC.Value[0].DisplayStatus)"
        Write-Output "Run Command Result2: $($RunC.Value[1].DisplayStatus)"

        Write-Output "End Date: $(Get-Date -Format "dd-MMMM-yyyy hh:mm")"
    }
    else {
        Write-Output "Stopped: $($VM.Name)"
    }
}

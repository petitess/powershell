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

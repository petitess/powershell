Get-AzContext

$vault = Get-AzRecoveryServicesVault -Name rsv-infra-prod-01 -ResourceGroupName rg-infra-prod-sc-01
Set-AzRecoveryServicesVaultContext -Vault $vault

$VirtualMachines = Get-AzVM | Where-Object {$_.name -like "vmctxprod*"}

foreach ($Vm in $VirtualMachines) {
$backupcontainer = Get-AzRecoveryServicesBackupContainer `
    -ContainerType "AzureVM" `
    -FriendlyName $Vm.Name
    
$item = Get-AzRecoveryServicesBackupItem `
    -Container $backupcontainer `
    -WorkloadType "AzureVM"
Backup-AzRecoveryServicesBackupItem -Item $item -ExpiryDateTimeUTC (Get-Date).AddDays(30)
}

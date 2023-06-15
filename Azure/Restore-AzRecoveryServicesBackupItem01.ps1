$vms = @(
    "vmdcprod01"
    "vmmgmtprod01"
    "vmwebprod02"
    "vmsqlprod01"
)

$targetVault = Get-AzRecoveryServicesVault -Name "rsv-infra-prod-01" -ResourceGroupName "rg-infra-prod-sc-01"
Set-AzRecoveryServicesVaultContext -Vault $targetVault

foreach ($vm in $vms) {
$vmx = Get-AzVM -Name $vm
$namedContainer = Get-AzRecoveryServicesBackupContainer  -ContainerType "AzureVM" -FriendlyName $vmx.Name -VaultId $targetVault.ID
$backupitem = Get-AzRecoveryServicesBackupItem -Container $namedContainer  -WorkloadType "AzureVM" -VaultId $targetVault.ID

$startDate = (Get-Date).AddDays(-4)
$endDate = Get-Date
$rp = Get-AzRecoveryServicesBackupRecoveryPoint -Item $backupitem `
-StartDate $startdate.ToUniversalTime() `
-EndDate $enddate.ToUniversalTime() `
-VaultId $targetVault.ID
$rp[0]

$restorejob = Restore-AzRecoveryServicesBackupItem -RecoveryPoint $rp[0] `
-StorageAccountName "strestoreprod01" `
-StorageAccountResourceGroupName "rg-restore-prod-01" `
-VaultId $targetVault.ID `
-TargetResourceGroupName "rg-restore-prod-01" `
-TargetSubnetName "snet-restore-prod-01" `
-TargetVNetName "vnet-restore-prod-01" `
-TargetVNetResourceGroup "rg-restore-prod-01" `
-TargetVMName ($vmx.Name).Replace("prod", "restore")
$restorejob
}

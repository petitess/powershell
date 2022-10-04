$rsvname = "rsv-infra-prod-01"
$infrargname = "rg-infra-prod-sc-01"

$vault = Get-AzRecoveryServicesVault -Name $rsvname -ResourceGroupName $infrargname
Set-AzRecoveryServicesVaultContext -Vault $vault


$backupcontainer = Get-AzRecoveryServicesBackupContainer `
    -ContainerType "AzureVM" `
    -FriendlyName vmdcprod01

$item = Get-AzRecoveryServicesBackupItem `
    -Container $backupcontainer `
    -WorkloadType "AzureVM"

Get-AzRecoveryServicesBackupRecoveryPoint -Item $item -RecoveryPointId 7701367240882239739

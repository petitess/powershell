$backupcontainer = Get-AzRecoveryServicesBackupContainer `
    -ContainerType "AzureVM" `
    -FriendlyName vmdcprod01

$item = Get-AzRecoveryServicesBackupItem `
    -Container $backupcontainer `
    -WorkloadType "AzureVM"

Get-AzRecoveryServicesBackupRecoveryPoint -Item $item -RecoveryPointId 7701367240882239739 | select RecoveryPointId, RecoveryPointTime

Import-Module ADSync

Get-ADSyncScheduler

Start-ADSyncSyncCycle -PolicyType Delta

Start-ADSyncSyncCycle -PolicyType Initial

Get-ADSyncConnectorRunStatus

Import-Module ADSync

Get-ADSyncScheduler

Start-ADSyncSyncCycle -PolicyType Delta

Start-ADSyncSyncCycle -PolicyType Initial

Get-ADSyncConnectorRunStatus

https://docs.microsoft.com/en-us/azure/active-directory/hybrid/how-to-connect-sync-feature-scheduler#scheduler-and-installation-wizard

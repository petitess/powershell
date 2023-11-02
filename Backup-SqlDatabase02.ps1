$database = (Get-SqlDatabase -ServerInstance "vmsqlprod01" | Where-Object {$_.RecoveryModel -ne "Simple"}).Name

$database | ForEach-Object {
    $date = Get-Date -Format "yyyy_MM_dd_HH_mm"
    $container = 'https://stbackupb3careprod01.blob.core.windows.net/vmsqlprod01-transaction-log'
    $fileName = $_ + "_" + $date+".bak"
    $server = 'vmsqlprod01'
    $backupFile = $container + '/' + $fileName
    Write-Output $_
    Backup-SqlDatabase -ServerInstance $server -Database $_ -BackupFile $backupFile -BackupAction Log -CompressionOption On
}

$database = (Get-SqlDatabase -ServerInstance "vmsqlprod01").Name

$database | ForEach-Object {
    $date = Get-Date -Format "yyyy_MM_dd_HH_mm"
    $container = 'https://stbackupXXXXprod01.blob.core.windows.net/vmsqlprod01-full-backup'
    $fileName = $_ + "_" + $date+".bak"
    $server = 'vmsqlprod01'
    $backupFile = $container + '/' + $fileName
    Backup-SqlDatabase -ServerInstance $server -Database $_ -BackupFile $backupFile -CompressionOption On
}

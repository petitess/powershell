$server = 'vmsqlprod01'
$database = (Get-SqlDatabase -ServerInstance $server | Where-Object {$_.RecoveryModel -ne "Simple"}).Name
$database | ForEach-Object {
    $date = Get-Date -Format "yyyy_MM_dd_HH_mm"
    $container = 'https://stbackupXXXprod02.blob.core.windows.net/vmsqlprod01-transaction-log'
    $fileName = $container + '/' + $_ + "_" + $date+".bak"
    Backup-SqlDatabase -ServerInstance $server -Database $_ `
        -CompressionOption On -MaxTransferSize 4194304 -BlockSize 65536 `
        -BackupFile $fileName
}

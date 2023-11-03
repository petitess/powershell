$server = 'vmsqlprod02'
$database = (Get-SqlDatabase -ServerInstance $server).Name
$database | ForEach-Object {
    $date = Get-Date -Format "yyyy_MM_dd_HH_mm"
    $container = 'https://stbackupXXXprod01.blob.core.windows.net/vmsqlprod02-full-backup'
    $fileName1 = $container + '/' + $_ + "_" + $date +"_1.bak"
    $fileName2 = $container + '/' + $_ + "_" + $date +"_2.bak"
    $fileName3 = $container + '/' + $_ + "_" + $date +"_3.bak"
    $fileName4 = $container + '/' + $_ + "_" + $date +"_4.bak"
    Backup-SqlDatabase -ServerInstance $server -Database $_ `
        -CompressionOption On -MaxTransferSize 4194304 -BlockSize 65536 `
        -BackupFile $fileName1, $fileName2, $fileName3, $fileName4
}

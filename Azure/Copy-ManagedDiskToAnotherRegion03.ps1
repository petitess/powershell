# SOURCE
$snapshotResourceGroup = "rg-backup-prod-02"
# DESTINATION
$StorageAccount = "stxxxrecoveryprod02"
$StorageAccountBlob = "comp-vhd-we"
$StorageAccountKey = 'xxxxxxqmW+Mx2pFSLR9UfRgrnu5CsXOOnB7mjSWtfc/OxvRRpo7XmkitDr4pxxxxxx'

$Snapshots = Get-AzSnapshot -ResourceGroupName $snapshotResourceGroup #| Where-Object { $_.Name -match 'vmmgmt' }

$Snapshots | ForEach-Object  {
    $snapshotaccess = Grant-AzSnapshotAccess -ResourceGroupName $SnapshotResourceGroup -SnapshotName $_.Name -DurationInSecond 3600 -Access Read -ErrorAction stop 
    $DestStorageContext = New-AzStorageContext –StorageAccountName $storageaccount -StorageAccountKey $StorageAccountKey -ErrorAction stop

    Write-Output "START COPY"
    Start-AzStorageBlobCopy -AbsoluteUri $snapshotaccess.AccessSAS -DestContainer $StorageAccountBlob -DestContext $DestStorageContext -DestBlob "$(($_.Name).Replace('snap-', '')).vhd" -Force -ErrorAction stop
    Write-Output "END COPY"
}

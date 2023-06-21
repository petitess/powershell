# SOURCE
$SnapshotResourceGroup = "rg-backup-prod-01"
$SnapshotName = "snap-vmadcprod02-20230620-2200"

# DESTINATION
$StorageAccount = "staaatest01"
$StorageAccountBlob = "vmadcprod01-02-vhd"
$storageaccountResourceGroup = "rg-aaa-test"
$vhdname = "vmadcprod02-20230620"


#SA_KEY
$StorageAccountKey = (Get-AzStorageAccountKey -Name $StorageAccount -ResourceGroupName $StorageAccountResourceGroup).value[0]
$snapshot = Get-AzSnapshot -ResourceGroupName $SnapshotResourceGroup -SnapshotName $SnapshotName

#GRANTING ACCESS
$snapshotaccess = Grant-AzSnapshotAccess -ResourceGroupName $SnapshotResourceGroup -SnapshotName $SnapshotName -DurationInSecond 3600 -Access Read -ErrorAction stop 
   
$DestStorageContext = New-AzStorageContext –StorageAccountName $storageaccount -StorageAccountKey $StorageAccountKey -ErrorAction stop

Write-Output "START COPY"
Start-AzStorageBlobCopy -AbsoluteUri $snapshotaccess.AccessSAS -DestContainer $StorageAccountBlob -DestContext $DestStorageContext -DestBlob "$($vhdname).vhd" -Force -ErrorAction stop
Write-Output "END COPY, CREATE A NEW DISK MANUALLY IN THE PORTAL FROM STORAGE BLOB"

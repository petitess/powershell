
$context = New-AzStorageContext -StorageAccountName "backupstorage" -StorageAccountKey "LSU1rS1V2KeY3jJvg6deH8CSIMyDKac6cfvhw=="
#Container se-db06

$blobs = Get-AzStorageBlob -Container "se-db06" -Context $context 
$blobs | select name, lastmodified, versionid, length
$files = ($blobs | Measure-Object | %{$_.count})
$containersize = ($blobs | Measure-Object -Sum Length).Sum / 1GB
Write-Output "    Container Size: $containersize (Gbytes) and $files files"
###COPY TO ANOTHER CONTAINER
$newcontainer = "se-db06-backup"

$blobs | Start-AzStorageBlobCopy -DestContainer $newcontainer -DestContext $context



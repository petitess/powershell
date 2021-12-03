﻿
$context = New-AzStorageContext -StorageAccountName "b3carenlbackupstorage" -StorageAccountKey "glKWUDoaKGV/Dk6WjsVznz0RurYBmtuqoMfTQGRPJ0POUBriuLSU1rS1V2KeY3jJvg6deH8CSIMyDKac6cfvhw=="
#Container b3care-se-db06

$blobs = Get-AzStorageBlob -Container "b3care-se-db06" -Context $context 
$blobs | select name, lastmodified, versionid, length
$files = ($blobs | Measure-Object | %{$_.count})
$containersize = ($blobs | Measure-Object -Sum Length).Sum / 1GB
Write-Output "    Container Size: $containersize (Gbytes) and $files files"
###COPY TO ANOTHER CONTAINER
$newcontainer = "b3care-se-db06-backup"

$blobs | Start-AzStorageBlobCopy -DestContainer $newcontainer -DestContext $context


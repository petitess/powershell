
$context = New-AzStorageContext -StorageAccountName "backupstorage" -StorageAccountKey "Jvg6deH8CSIMyDKac6cfvhw=="
#Container size

$blobs = Get-AzStorageBlob -Container "db06" -Context $context -IncludeVersion 
#$blobs | select name, lastmodified, versionid, length
$files = ($blobs | Measure-Object | %{$_.count})
$containersize = ($blobs | Measure-Object -Sum Length).Sum / 1GB
Write-Output "    Container Size: $containersize (Gbytes) and $files files"

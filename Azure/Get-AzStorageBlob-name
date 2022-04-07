#Lists blobs containing a name phrase
param($Timer)
$lifecycle = [DateTime]::UtcNow.AddDays(-1)     # 15 day

$context = New-AzStorageContext -StorageAccountName "backupstorage" -StorageAccountKey "glKWUDoaKGg6deH8CSIMyDKac6cfvhw=="
Get-AzStorageBlob -Container "b3care-se-db01" -Context $context | Where-Object {$_.Name -like "*2022_04_07*"} | select Name, LastModified

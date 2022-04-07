param($Timer)
$lifecycle = [DateTime]::UtcNow.AddDays(-1)     # 15 day

$context = New-AzStorageContext -StorageAccountName "backupstorage" -StorageAccountKey "glKWUDoaKGV/eY3jJvg6deH8CSIMyDKac6cfvhw=="
Get-AzStorageBlob -Container "se-db01" -Context $context | Where-Object {$_.Name -like "*2022_04_07*"} | select Name, LastModified
Get-AzStorageBlob -Container "se-db02" -Context $context | Where-Object {$_.Name -like "*2022_04_07*"} | select Name, LastModified
Get-AzStorageBlob -Container "se-db03" -Context $context | Where-Object {$_.Name -like "*2022_04_07*"} | select Name, LastModified
Get-AzStorageBlob -Container "se-db04" -Context $context | Where-Object {$_.Name -like "*2022_04_07*"} | select Name, LastModified
Get-AzStorageBlob -Container "se-db06" -Context $context | Where-Object {$_.Name -like "*2022_04_07*"} | select Name, LastModified
Get-AzStorageBlob -Container "se-db07" -Context $context | Where-Object {$_.Name -like "*2022_04_07*"} | select Name, LastModified
Get-AzStorageBlob -Container "se-db09" -Context $context | Where-Object {$_.Name -like "*2022_04_07*"} | select Name, LastModified
Get-AzStorageBlob -Container "se-db12" -Context $context | Where-Object {$_.Name -like "*2022_04_07*"} | select Name, LastModified
Get-AzStorageBlob -Container "se-db13" -Context $context | Where-Object {$_.Name -like "*2022_04_07*"} | select Name, LastModified


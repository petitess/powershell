#Gets blobs from multiple containers and sends them to a file
$context = New-AzStorageContext -StorageAccountName "backupstorage" -StorageAccountKey "glKWUDoaKGV/eY3jJvg6deH8CSIMyDKac6cfvhw=="
$blob1 = Get-AzStorageBlob -Container "se-db01" -Context $context | Where-Object {$_.Name -like "*2022_04_07*"} | select Name, LastModified
$blob2 = Get-AzStorageBlob -Container "se-db02" -Context $context | Where-Object {$_.Name -like "*2022_04_07*"} | select Name, LastModified
$blob3 = Get-AzStorageBlob -Container "se-db03" -Context $context | Where-Object {$_.Name -like "*2022_04_07*"} | select Name, LastModified
$blob4 = Get-AzStorageBlob -Container "se-db04" -Context $context | Where-Object {$_.Name -like "*2022_04_07*"} | select Name, LastModified
$blob5 = Get-AzStorageBlob -Container "se-db06" -Context $context | Where-Object {$_.Name -like "*2022_04_07*"} | select Name, LastModified
$blob6 = Get-AzStorageBlob -Container "se-db07" -Context $context | Where-Object {$_.Name -like "*2022_04_07*"} | select Name, LastModified
$blob7 = Get-AzStorageBlob -Container "se-db09" -Context $context | Where-Object {$_.Name -like "*2022_04_07*"} | select Name, LastModified
$blob8 = Get-AzStorageBlob -Container "se-db12" -Context $context | Where-Object {$_.Name -like "*2022_04_07*"} | select Name, LastModified
$blob9 = Get-AzStorageBlob -Container "se-db13" -Context $context | Where-Object {$_.Name -like "*2022_04_07*"} | select Name, LastModified

$blob1,$blob2,$blob3,$blob4,$blob5,$blob5,$blob6,$blob7,$blob8,$blob9 | Out-File C:\Users\KarolSek\Desktop\lista.txt

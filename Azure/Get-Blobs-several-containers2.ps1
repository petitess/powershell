$context = New-AzStorageContext -StorageAccountName "backupstorage" -StorageAccountKey "glKWUDoaKGV/Dk6WjMyDKac6cfvhw=="

$containers = Get-AzStorageContainer -Context $context

foreach ($container in $containers) {

$blobs = Get-AzStorageBlob -Container $container.Name -Context $context | Where-Object {$_.Name -like "*2022_04_07*"}
$blobs

}

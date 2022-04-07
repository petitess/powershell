$context = New-AzStorageContext -StorageAccountName "b3carenlbackupstorage" -StorageAccountKey "glKWUDoaKGV/Dk6WjsVznz0RurYBmtuqoMfTQGRPJ0POUBriuLSU1rS1V2KeY3jJvg6deH8CSIMyDKac6cfvhw=="

$containers = Get-AzStorageContainer -Context $context

foreach ($container in $containers) {

$blobs = Get-AzStorageBlob -Container $container.Name -Context $context | Where-Object {$_.Name -like "*2022_04_07*"}
$blobs

}

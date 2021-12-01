$azstorcontext = New-AzStorageContext -StorageAccountName backupstorage -StorageAccountKey "aKGV/Dk6WjsVznz0RurYBmtuqoMfTQGRPJ0POUBriuLSU1rS1V2KeY3jJvg6deH8CSIMyDKac6cfvhw=="
$sizesOverall = @()
$containers = Get-AzStorageContainer -Context $azstorcontext
foreach ($container in $containers)
{
    Write-Output $container.Name
    $contblobs = get-azstorageblob -container $container.name -Context $azstorcontext
    Write-Output "  Blobs: $($contblobs.count)"
    $containersize = ($contblobs | Measure-Object -Sum Length).Sum / 1GB
    Write-Output "    Container Size: $containersize) (Gbytes)"
    $sizesOverall    
}

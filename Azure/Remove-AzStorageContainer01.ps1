$ctx = New-AzStorageContext -StorageAccountName "strestore01" -StorageAccountKey "CXPDFziXVeyZWxx4X5gzb14dDaTNuB0vEODyeVaV7+AStyUmsww=="
$containers = Get-AzStorageContainer -Context $ctx

foreach ($cont in $containers) {
    Remove-AzStorageContainer -Name $cont.Name -Context $ctx -Force
}

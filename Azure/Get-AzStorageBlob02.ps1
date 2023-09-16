$stName = "stxrecoveryprod02" 
$stRgName = "rg-xrecovery-prod-01"
$stContainer = "care-vhd-we"

$stKey = (Get-AzStorageAccountKey -ResourceGroupName $stRgName -Name $stName).Value[0]
$storage_account = New-AzStorageContext -StorageAccountName $stName  -StorageAccountKey $stKey  

$containers = Get-AzStorageContainer -Context $storage_account -Name $stContainer
$blobs = Get-AzStorageBlob -Container $containers.Name -Context $storage_account

$files = ($blobs | Measure-Object | %{$_.count})
$containersize = ($blobs | Measure-Object -Sum Length).Sum / 1GB
Write-Output "Container Size: $containersize (Gbytes) and $files files"

$stName = "stxrecoveryprod02" 
$stRgName = "rg-xrecovery-prod-01"
$stContainer = "care-vhd-we"

$stKey = (Get-AzStorageAccountKey -ResourceGroupName $stRgName -Name $stName).Value[0]
$storage_account = New-AzStorageContext -StorageAccountName $stName  -StorageAccountKey $stKey  

$containers = Get-AzStorageContainer -Context $storage_account -Name $stContainer
$blobs = Get-AzStorageBlob -Container $containers.Name -Context $storage_account 
$blobs | Select-Object Name, LastModified, @{Name="Size(GB)";Expression={$_.Length/1GB}}

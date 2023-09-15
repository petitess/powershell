$stName = "stxrecoveryprod02" 
$stRgName = "rg-xrecovery-prod-01"
$stContainer = "care-vhd-we"
$vhdUri = "https://stxrecoveryprod02.blob.core.windows.net/$stContainer/"

$st = Get-AzStorageAccount -Name $stName  -ResourceGroupName $stRgName
$stKey = (Get-AzStorageAccountKey -ResourceGroupName $stRgName -Name $stName).Value[0]
$storage_account = New-AzStorageContext -StorageAccountName $stName  -StorageAccountKey $stKey

$containers = Get-AzStorageContainer -Context $storage_account -Name $stContainer
$blobs = Get-AzStorageBlob -Container $containers.Name -Context $storage_account | Where-Object {$_.Name -match "vmmgmt" -and $_.BlobProperties.BlobCopyStatus -eq "Success"}

$config = New-AzDiskConfig -Location "westeurope" -SkuName Premium_LRS -DiskSizeGB ($blobs[0] | ForEach-Object {[math]::truncate($_.Length / 1GB)}) -OsType Windows -HyperVGeneration V1 -Architecture X64 -CreateOption Import -SourceUri ($vhdUri+$blobs[0].Name) -StorageAccountId $st.Id
New-AzDisk -ResourceGroupName "rg-vmmgmtprod01" -DiskName 'vmmgmt-disk' -Disk $config

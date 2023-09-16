$destination_path = 'D:\temp'
$stName = "stxrecoveryprod02" 
$stRgName = "rg-xrecovery-prod-01"
$stContainer = "care-vhd-we"

$stKey = (Get-AzStorageAccountKey -ResourceGroupName $stRgName -Name $stName).Value[0]
$storage_account = New-AzStorageContext -StorageAccountName $stName  -StorageAccountKey $stKey  
$containers = Get-AzStorageContainer -Context $storage_account -Name $stContainer

Write-Host 'Starting Storage Dump...'

foreach ($container in $containers) {
    Write-Host -NoNewline 'Processing: ' . $container.Name . '...'

    $container_path = $destination_path + '\' + $container.Name

    if (!(Test-Path -Path $container_path )) {
        New-Item -ItemType directory -Path $container_path
    }
    #Download blobs with specific name
    $blobs = Get-AzStorageBlob -Container $container.Name -Context $storage_account | Where-Object { $_.Name -like "*vmadcprod03*" }

    Write-Host -NoNewline ' Downloading files...'    

    foreach ($blob in $blobs) {        
        $fileNameCheck = $container_path + '\' + $blob.Name
        
        if (!(Test-Path $fileNameCheck )) {
            Get-AzStorageBlobContent `
                -Container $container.Name -Blob $blob.Name -Destination $container_path `
                -Context $storage_account
        }            
    }  
    Write-Host ' Done.'
}
Write-Host 'Download complete.'

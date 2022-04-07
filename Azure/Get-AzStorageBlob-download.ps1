$destination_path = 'C:\test'

$storage_account = New-AzStorageContext -StorageAccountName "backupstorage" -StorageAccountKey "glKWUDoaKGV/Dk6WjsVzneH8CSIMyDKac6cfvhw=="

$containers = Get-AzStorageContainer -Context $storage_account

Write-Host 'Starting Storage Dump...'

foreach ($container in $containers)
{
    Write-Host -NoNewline 'Processing: ' . $container.Name . '...'

    $container_path = $destination_path + '\' + $container.Name

    if(!(Test-Path -Path $container_path ))
    {
        New-Item -ItemType directory -Path $container_path
    }
#Download blobs with specific name
    $blobs = Get-AzStorageBlob -Container $container.Name -Context $storage_account | Where-Object {$_.Name -like "*Alvangen_ccdb_bac*"}

    Write-Host -NoNewline ' Downloading files...'    

    foreach ($blob in $blobs)
    {        
        $fileNameCheck = $container_path + '\' + $blob.Name
        
        if(!(Test-Path $fileNameCheck ))
        {
            Get-AzStorageBlobContent `
            -Container $container.Name -Blob $blob.Name -Destination $container_path `
            -Context $storage_account
        }            
    }  

    Write-Host ' Done.'
}

Write-Host 'Download complete.'

param($Timer)
$lifecycle = [DateTime]::UtcNow.AddHours(-360)     # 15 day
$context = New-AzStorageContext -StorageAccountName "backupstorage" -StorageAccountKey "POUBriuLSU1rS1V2KeY3jJvg6deH8CSIMyDKac6cfvhw=="
#Container se-db01
$blobs = Get-AzStorageBlob -Container "se-db01" -Context $context | Where-Object { $_.LastModified.UtcDateTime -lt $lifecycle -and $_.BlobType -eq "PageBlob" -and $_.Name -like "*.bak"} 
$blobs | %{$_.ICloudBlob.BreakLease()}
$blobs| Remove-AzStorageBlob
Write-Output "Clear DB backup files - Storage account: nlbackupstorage, Container: se-db01"; 

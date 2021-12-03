
param($Timer)
$lifecycle = [DateTime]::UtcNow.AddHours(-360)     # 15 day
$context = New-AzureStorageContext -StorageAccountName "b3carenlbackupstorage" -StorageAccountKey "glKWUDoaKGV/Dk6WjsVznz0RurYBmtuqoMfTQGRPJ0POUBriuLSU1rS1V2KeY3jJvg6deH8CSIMyDKac6cfvhw=="
#Container b3care-se-db01
$blobs = Get-AzureStorageBlob -Container "b3care-se-db01" -Context $context | Where-Object { $_.LastModified.UtcDateTime -lt $lifecycle -and $_.BlobType -eq "PageBlob" -and $_.Name -like "*.bak"} 
$blobs | %{$_.ICloudBlob.BreakLease()}
$blobs| Remove-AzureStorageBlob
#Container b3care-se-db02
$blobs = Get-AzureStorageBlob -Container "b3care-se-db02" -Context $context | Where-Object { $_.LastModified.UtcDateTime -lt $lifecycle -and $_.BlobType -eq "PageBlob" -and $_.Name -like "*.bak"} 
$blobs | %{$_.ICloudBlob.BreakLease()}
$blobs| Remove-AzureStorageBlob
#Container b3care-se-db03
$blobs = Get-AzureStorageBlob -Container "b3care-se-db03" -Context $context | Where-Object { $_.LastModified.UtcDateTime -lt $lifecycle -and $_.BlobType -eq "PageBlob" -and $_.Name -like "*.bak"} 
$blobs | %{$_.ICloudBlob.BreakLease()}
$blobs| Remove-AzureStorageBlob
#Container b3care-se-db04
$blobs = Get-AzureStorageBlob -Container "b3care-se-db04" -Context $context | Where-Object { $_.LastModified.UtcDateTime -lt $lifecycle -and $_.BlobType -eq "PageBlob" -and $_.Name -like "*.bak"} 
$blobs | %{$_.ICloudBlob.BreakLease()}
$blobs| Remove-AzureStorageBlob
#Container b3care-se-db06
$blobs = Get-AzureStorageBlob -Container "b3care-se-db06" -Context $context | Where-Object { $_.LastModified.UtcDateTime -lt $lifecycle -and $_.BlobType -eq "PageBlob" -and $_.Name -like "*.bak"} 
$blobs | %{$_.ICloudBlob.BreakLease()}
$blobs| Remove-AzureStorageBlob
#Container b3care-se-db07
$blobs = Get-AzureStorageBlob -Container "b3care-se-db07" -Context $context | Where-Object { $_.LastModified.UtcDateTime -lt $lifecycle -and $_.BlobType -eq "PageBlob" -and $_.Name -like "*.bak"} 
$blobs | %{$_.ICloudBlob.BreakLease()}
$blobs| Remove-AzureStorageBlob
#Container b3care-se-db09
$blobs = Get-AzureStorageBlob -Container "b3care-se-db09" -Context $context | Where-Object { $_.LastModified.UtcDateTime -lt $lifecycle -and $_.BlobType -eq "PageBlob" -and $_.Name -like "*.bak"} 
$blobs | %{$_.ICloudBlob.BreakLease()}
$blobs| Remove-AzureStorageBlob
#Container b3care-se-db12
$blobs = Get-AzureStorageBlob -Container "b3care-se-db12" -Context $context | Where-Object { $_.LastModified.UtcDateTime -lt $lifecycle -and $_.BlobType -eq "PageBlob" -and $_.Name -like "*.bak"} 
$blobs | %{$_.ICloudBlob.BreakLease()}
$blobs| Remove-AzureStorageBlob
#Container b3care-se-db13
$blobs = Get-AzureStorageBlob -Container "b3care-se-db13" -Context $context | Where-Object { $_.LastModified.UtcDateTime -lt $lifecycle -and $_.BlobType -eq "PageBlob" -and $_.Name -like "*.bak"} 
$blobs | %{$_.ICloudBlob.BreakLease()}
$blobs| Remove-AzureStorageBlob
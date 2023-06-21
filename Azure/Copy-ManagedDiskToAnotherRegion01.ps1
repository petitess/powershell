# Download AzCopy https://learn.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10#download-and-install-azcopy
# Name of the Managed Disk you are starting with

$sourceDiskName = "vmadcprod02-OS-orginal"
# Name of the resource group the source disk resides in
$sourceRG = "rg-backup-prod-01"
# Name you want the destination disk to have
$targetDiskName = "vmadcprod02-OS-2023-06-orginal"
# Name of the resource group to create the destination disk in
$targetRG = "rg-infra-prod-we-01"
# Azure region the target disk will be in
$targetLocate = "westeurope"

# Gather properties of the source disk
$sourceDisk = Get-AzDisk -ResourceGroupName $sourceRG -DiskName $sourceDiskName

# Create the target disk config, adding the sizeInBytes with the 512 offset, and the -Upload flag
# If this is an OS disk, add this property: -OsType $sourceDisk.OsType
$targetDiskconfig = New-AzDiskConfig -SkuName 'Premium_LRS' -UploadSizeInBytes $($sourceDisk.DiskSizeBytes+512) -Location $targetLocate -CreateOption 'Upload'

# Create the target disk (empty)
$targetDisk = New-AzDisk -ResourceGroupName $targetRG -DiskName $targetDiskName -Disk $targetDiskconfig

# Get a SAS token for the source disk, so that AzCopy can read it
$sourceDiskSas = Grant-AzDiskAccess -ResourceGroupName $sourceRG -DiskName $sourceDiskName -DurationInSecond 86400 -Access 'Read'

# Get a SAS token for the target disk, so that AzCopy can write to it
$targetDiskSas = Grant-AzDiskAccess -ResourceGroupName $targetRG -DiskName $targetDiskName -DurationInSecond 86400 -Access 'Write'

# Download AzCopy https://learn.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10#download-and-install-azcopy
# Begin the copy!
.\azcopy copy $sourceDiskSas.AccessSAS $targetDiskSas.AccessSAS --blob-type PageBlob

# Revoke the SAS so that the disk can be used by a VM
Revoke-AzDiskAccess -ResourceGroupName $sourceRG -DiskName $sourceDiskName

# Revoke the SAS so that the disk can be used by a VM
Revoke-AzDiskAccess -ResourceGroupName $targetRG -DiskName $targetDiskName

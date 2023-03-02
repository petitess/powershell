$Now = Get-Date -Format "yyyyMMdd-HHmm"
$resourceGroupName = 'rg-vmdctest01' 
$location = 'swedencentral' 
$snapshotResourceGroupName = "rg-ps"


$vms = Get-AzVM `
-ResourceGroupName $resourceGroupName `
| Where-Object {$_.Name -match "vmdc"}

foreach ($vm in $vms) {
    $snapshot =  New-AzSnapshotConfig `
        -SourceUri $vm.StorageProfile.OsDisk.ManagedDisk.Id `
        -Location $location `
        -CreateOption copy
    New-AzSnapshot `
        -Snapshot $snapshot `
        -SnapshotName "snap-$($vm.name)-$Now" `
        -ResourceGroupName $snapshotResourceGroupName
}

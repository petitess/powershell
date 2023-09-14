$Now = Get-Date -Format "yyyyMMdd"
$location = 'swedencentral' 
$snapshotResourceGroupName = "rg-backup-prod-02"

$disks = Get-AzDisk | Where-Object { $_.Name -notmatch "vmvda" -and $_.Name -notmatch "vmmtd" -and $_.Name -notmatch "vmpvsupdater" -and $_.DiskState -eq "Attached"}

foreach ($d in $disks) {
    $snapshot =  New-AzSnapshotConfig `
        -SourceUri $d.Id `
        -Location $location `
        -CreateOption copy
    New-AzSnapshot `
        -Snapshot $snapshot `
        -SnapshotName "snap-$($d.name)-$Now" `
        -ResourceGroupName $snapshotResourceGroupName
}

$OldSnapshots = Get-AzSnapshot -ResourceGroupName $snapshotResourceGroupName | Where-Object {$_.TimeCreated -lt (Get-Date).AddDays(-1)}
$OldSnapshots.Count
foreach ($OldSnapshot in $OldSnapshots) {
    Remove-AzSnapshot -ResourceGroupName $snapshotResourceGroupName -SnapshotName $OldSnapshot.Name -Force -Confirm:$false
}

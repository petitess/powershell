$snapshotResourceGroupName = "rg-snap"

$OldSnapshots = Get-AzSnapshot -ResourceGroupName $snapshotResourceGroupName | Where-Object {$_.TimeCreated -gt 0 -and $_.Name -match "vmdc"}
$OldSnapshots.Count
foreach ($OldSnapshot in $OldSnapshots) {
    Remove-AzSnapshot -ResourceGroupName $snapshotResourceGroupName -SnapshotName $OldSnapshot.Name -Force -Confirm:$false
}

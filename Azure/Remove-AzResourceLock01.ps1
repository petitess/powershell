foreach ($lock in Get-AzResourceLock | Where-Object { $_.ResourceGroupName -like "rg-vm*" }) {

    Remove-AzResourceLock -LockId ($lock).LockId -Force
}

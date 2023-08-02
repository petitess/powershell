foreach ($lock in Get-AzResourceLock) {

    Remove-AzResourceLock -LockId ($lock).LockId -Force
}

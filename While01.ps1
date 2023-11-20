while (!(Test-Path "D:\XXX\*")) {
    try {
        
        Remove-Item "D:\XXX\*"
        Write-Output "Removing"
        Start-Sleep 5
    }
    catch {}
}
#######
$timeout = New-TimeSpan -Seconds 30
$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
while ($stopwatch.elapsed -lt $timeout) {
    try {
        Write-Output "Working  $(Get-Date)"
        Start-Sleep 5
    }
    catch {}
}
#######
while (Test-Connection -ComputerName 8.8.8.8 -Quiet -Count 1) {
    try {
        Write-Host "Online"
    Start-Sleep 5
    }
    catch {}
}

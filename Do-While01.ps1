do 
{
Remove-Item "D:\XXX\*"
}while (Test-Path "D:\XXX\*")
######
$timeout = New-TimeSpan -Seconds 30
$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
do {
    Write-Output "Working $(Get-Date)"
    Start-Sleep 5
} while ($stopwatch.elapsed -lt $timeout)
#######
$i = 0
do 
{
Write-Output "Working $i"
Start-Sleep 3
$i++
}while (!(Test-Path "D:\XXX\*"))
#######
Do {
    Write-Host "Online"
    Start-Sleep 5
}
While (Test-Connection -ComputerName 8.8.8.8 -Quiet -Count 1)
Write-Host "Offline"

$month = Get-Date -Format "MM" -Month 4

if ($month % 2 -eq 0) {
    Write-Output "YES"
} else {
    Write-Output "NO"  
}

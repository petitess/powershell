$JsonNew = Get-Content "C:\tools\my_logs.json"
$JsonOld = Get-Content "C:\tools\my_logs_backup.json"

if ($JsonNew.Length -ne $JsonOld.Length) {
    Write-Output "The JSON files are different."
    Copy-Item -Path "C:\tools\my_logs.json" -Destination "C:\tools\my_logs_backup.json" -Force
}
else {
    Write-Output "The JSON files are the same."
}

$New = (Get-Content "C:\tools\my_logs.json" | ConvertFrom-Json | Where-Object '@mt' -Like "*BatchSuccess:*").Length
$Old = (Get-Content "C:\tools\my_logs_backup.json" | ConvertFrom-Json | Where-Object '@mt' -Like "*BatchSuccess:*").Length

if ($New -ne $Old) {
    Write-Output "The JSON files are different."
    Copy-Item -Path "C:\tools\my_logs.json" -Destination "C:\tools\my_logs_backup.json" -Force
}
else {
    Write-Output "The JSON files are the same."
}

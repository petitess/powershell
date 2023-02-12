Start-Process C:\Users\$env:username\AppData\Roaming\reolink\userSettings

Get-Content -path D:\userSettings

(Get-Content -path C:\Users\$env:username\AppData\Roaming\reolink\userSettings -Raw) `
 -replace '{"key":"hardware-acceleration","type":"boolean","value":true,"_id":"','{"key":"hardware-acceleration","type":"boolean","value":false,"_id":"'`
 | Set-Content -Path C:\Users\$env:username\AppData\Roaming\reolink\userSettings
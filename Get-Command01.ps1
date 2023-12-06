Get-Command get*credential*

Get-Command | Where-Object {$_.Source -match "TUN."}

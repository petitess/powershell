Get-WmiObject –ComputerName $env:COMPUTERNAME –Class Win32_ComputerSystem | Select-Object UserName

(Get-WMIObject -ClassName Win32_ComputerSystem).Username

(Get-CimInstance -ClassName Win32_ComputerSystem).Username

((Get-WMIObject -ClassName Win32_ComputerSystem).Username).Split('\')[1]
#Works with "Run command"
Get-ChildItem Env:\USERNAME

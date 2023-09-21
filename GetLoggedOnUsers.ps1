(Get-WMIObject -ClassName Win32_ComputerSystem).Username

(Get-CimInstance -ClassName Win32_ComputerSystem).Username

((Get-WMIObject -ClassName Win32_ComputerSystem).Username).Split('\')[1]

[System.Environment]::UserName

query user

((query user) -split "\n" -replace '\s\s+', ';' | convertfrom-csv -Delimiter ';').STATE

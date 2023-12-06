New-Item -ItemType SymbolicLink -Path "C:\Temp\stinfrab3careprod01\fileshare01" -Target "\\10.10.3.5\fileshare01"
#######
New-Item -Path "C:\Windows" -Name "0Users" -ItemType Directory -Force
$User = "localhost\stavdprofilesdev02"
$PWord = "xxxxxecYv4L0SHtLoU0QieUhhpbdAvBHtBfZnCnVhLA1Nmr1RuhwGqh277BqG+AStJVnLNw=="
$Credential = New-Object -TypeName System.Management.Automation.PSCredential($User, $PWord)
$Cred = Get-Credential -Credential $Credential
New-Item -ItemType SymbolicLink -Target "C:\Windows\0Users" -Path "\\stavdprofilesdev02.file.core.windows.net\profiles" -Credential $Cred 

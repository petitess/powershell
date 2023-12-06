New-Item -ItemType SymbolicLink -Path "C:\Temp\stinfrab3careprod01\fileshare01" -Target "\\10.10.3.5\fileshare01"
#######DOESNT WORK. YOU HAVE TO PUT PASSWORD MANUALLY.
$secPassword = ConvertTo-SecureString "ssscYv4L0SHtLoU0QieUhhpbdAvBHtBfZnCnVhLA1Nmr1RuhwGqh277BqG+AStJVnLNw==" -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ("localhost\stavdprofilesdev02", $secPassword)
$Credential = Get-Credential -Credential $cred
New-Item -ItemType SymbolicLink -Target "C:\Windows\0Users" -Path "\\stavdprofilesdev02.file.core.windows.net\profiles" -Credential $Credential

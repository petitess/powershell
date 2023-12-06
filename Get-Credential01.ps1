$User = "localhost\stavdprofilesdev02"
$PWord = "xcYv4L0SHtLoU0QieUhhpbdAvBHtBfZnCnVhLA1Nmr1RuhwGqh277BqG+AStJVnLNw=="
$Credential = New-Object -TypeName System.Management.Automation.PSCredential($User, $PWord)
$Cred = Get-Credential -Credential $Credential

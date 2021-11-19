$DomainUser = "b3care.test\sek"
$DomainPWord = ConvertTo-SecureString -String "12345678.abc" -AsPlainText -Force
$DomainCredential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $DomainUser, $DomainPWord

Add-Computer -ComputerName WEB01 -DomainName b3care.test -Credential $DomainCredential

Restart-Computer

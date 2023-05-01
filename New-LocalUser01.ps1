$securePassword = ConvertTo-SecureString "12345.abc" -AsPlainText -Force

New-LocalUser -Name "user01" -Password $securePassword -Confirm:$false

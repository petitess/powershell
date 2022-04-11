$oldusers = Get-ADUser -Filter {Enabled -eq $TRUE} -SearchBase "ou=User,ou=Accounts,dc=ad,dc=almi,dc=se" -Properties Name,SamAccountName,LastLogonDate | Where {($_.LastLogonDate -lt (Get-Date).AddDays(-180)) -and ($_.LastLogonDate -ne $NULL)}

foreach ($user in $oldusers){
    Move-ADObject -Identity $user -TargetPath "ou=Elysium,dc=ad,dc=almi,dc=se"
}

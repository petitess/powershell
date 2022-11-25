$OldCompanyName = "Company Old AB"
$NewCompanyName = "Company New AB"
$OU = "OU=User,OU=Accounts,DC=ad,DC=almi,DC=se"

$Users = Get-ADUser -SearchBase $OU -properties Company -filter {Company -like $OldCompanyName}
$Users | Foreach {
         Set-ADUser -Identity $_ -Company $NewCompanyName
     }

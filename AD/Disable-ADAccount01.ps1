$UsersOrganizationalUnit = 'OU=Vendor,OU=Accounts,OU=COMP,DC=ad,DC=comp,DC=se'

$Users = Get-ADUser -Filter * -SearchBase $UsersOrganizationalUnit -Properties AccountExpirationDate, accountExpires | Where-Object {$_.enabled -eq $true -and $_.AccountExpirationDate -lt  (Get-Date) -and $_.AccountExpirationDate -notlike $null} | Select SamAccountName, AccountExpirationDate, Enabled

#$Users = Get-ADUser "ven.mattias.bilger" -Properties AccountExpirationDate | Select SAMAccountName,@{Name='AccountExpiration'; Expression={if($null -eq $_.AccountExpirationDate){'Never Expires'}else{$_.AccountExpirationDate}}}

foreach ($User in $Users) {
      Disable-ADAccount -Identity $User.SamAccountName
 }

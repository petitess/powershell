$UsersOrganizationalUnit = 'OU=Vendor,OU=Accounts,OU=COMP,DC=ad,DC=comp,DC=se'

Get-ADUser -Filter * -SearchBase $UsersOrganizationalUnit -Properties AccountExpirationDate, accountExpires | Where-Object {$_.enabled -eq $true -and $_.AccountExpirationDate -lt  (Get-Date) -and $_.AccountExpirationDate -notlike $null} | Select SamAccountName, AccountExpirationDate

$UsersOrganizationalUnit = 'OU=Vendor,OU=Accounts,OU=COMP,DC=ad,DC=comp,DC=se'
$GroupssOrganizationalUnit = 'OU=Groups,OU=COMP,DC=ad,DC=comp,DC=se'

$Users = Get-ADUser -Filter * -SearchBase $UsersOrganizationalUnit -Properties AccountExpirationDate, accountExpires | `
Where-Object {$_.AccountExpirationDate -lt (Get-Date) -and $_.enabled -eq $true -and $_.AccountExpirationDate -notlike $null}

$Groups = Get-ADGroup -Filter * -SearchBase $GroupssOrganizationalUnit

if ($null -ne $Users) {
foreach ($Group in $Groups) {
Remove-ADGroupMember -Identity $Group -Members $Users -Confirm:$false
}
}

foreach ($User in $Users) {
Disable-ADAccount -Identity $User.SamAccountName
}

$error >  C:\B3\Automation-Disable_Vendor_Users.ps1_errors.txt

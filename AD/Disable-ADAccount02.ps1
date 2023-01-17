$UsersOrganizationalUnit = 'OU=Vendor,OU=Accounts,OU=COMP,DC=ad,DC=comp,DC=se'

$Users = Get-ADUser -Filter * -SearchBase $UsersOrganizationalUnit -Properties AccountExpirationDate, accountExpires | `
Where-Object {$_.AccountExpirationDate -lt (Get-Date) -and $_.enabled -eq $true -and $_.AccountExpirationDate -notlike $null} | `
Select SamAccountName, AccountExpirationDate, Enabled
   
foreach ($User in $Users) {
$Groups = Get-ADPrincipalGroupMembership -Identity $User | Where-Object {$_.name -notcontains "Domain Users"}
    foreach ($Group in $Groups) {
        Remove-ADGroupMember -Identity $Group.Name -Members $User.SamAccountName -Confirm:$false 
    }
    Disable-ADAccount -Identity $User.SamAccountName
}

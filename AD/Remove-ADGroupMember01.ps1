   $UsersOrganizationalUnit = 'OU=Vendor,OU=Accounts,OU=ALMI,DC=ad,DC=company,DC=se'
   
   $Users = Get-ADUser -Filter * -SearchBase $UsersOrganizationalUnit | Where-Object {$_.enabled -eq $false}

   (Get-ADUser -Filter * -SearchBase $UsersOrganizationalUnit | Where-Object {$_.enabled -eq $false}).SamAccountName

   foreach ($User in $Users) {
   $Groups = Get-ADPrincipalGroupMembership -Identity $User | Where-Object {$_.name -notcontains "Domain Users"}

        foreach ($Group in $Groups) {
       
         Remove-ADGroupMember -Identity $Group.Name -Members $User.SamAccountName -Confirm:$false 
        }
    }

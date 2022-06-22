Import-Module ActiveDirectory

$securePassword = ConvertTo-SecureString "12345.abc" -AsPlainText -Force

$users = Import-Csv -Path c:\2.csv -Encoding UTF7

ForEach ($user in $users) {

$fname = $user.'First Name'
$lname = $user.'Last Name'
$phones = $user.'Office Phone'
$job = $user.'Job Title'
$email = $user.'Email Adress'
$OUpath = $user.'Organizational Unit'
$desc = $user.'Description'

New-ADUser -Name "$fname $lname" -GivenName $fname -Surname $lname -UserPrincipalName ("$fname.$lname" + "@xstile.com") -Path "OU=xstile,DC=XSTILE,DC=COM" -AccountPassword $securePassword -ChangePasswordAtLogon $true -OfficePhone $phones -Description $desc -EmailAddress $email -Enabled $true -SamAccountName ($fname.SubString(0,3) + $lname.SubString(0,3))

#New-ADUser -Name "$fname $lname" -GivenName $fname -Surname $lname -UserPrincipalName "$fname.$lname" -path "OU=mcampus,DC=MOV,DC=SE"

#echo "Account created for $fname $lname in $OU"

}

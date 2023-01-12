$username = "ven.sus.and"

$user = Get-ADUser $username -Properties AccountExpirationDate |Select SAMAccountName,@{Name='AccountExpiration'; Expression={if($null -eq $_.AccountExpirationDate){'Never Expires'}else{$_.AccountExpirationDate}}}

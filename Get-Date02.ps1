([DateTime]("01/01/2000 00:00")).Ticks
([DateTime]("01/01/2000 00:00")).Ticks

[datetime]::FromFileTime("129442497539436142")
[datetime]::FromFileTime("630822816000000000")

$a = ([datetime]::Now).Ticks - ([DateTime]("01/01/2000 00:00")).Ticks
Get-Date $a # get ticks from 01/01/0001 00:00
$a = ([datetime]::Now).Ticks - ([DateTime]("01/01/2000 00:00")).Ticks
[datetime]::FromFileTimeUTC($a) # get ticks from 01/01/1601 00:00

[datetime]::FromFileTime("129442497539436142")
[datetime]::FromFileTime("7226948160613294")

###This function is used to get AD Users Password Expiration Date:
Get-ADUser -filter {Enabled -eq $True -and PasswordNeverExpires -eq $False} -Properties UserPrincipalName, msDS-UserPasswordExpiryTimeComputed, mail, name | `
    Where-Object {$_."msDS-UserPasswordExpiryTimeComputed" -notmatch "92233720"} | `
    Where-Object {[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed") -lt (Get-Date).AddDays(7) -and [datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed") -ge (Get-Date) -and $null -ne $_.mail} | `
    Select-Object -Property "Name", "UserPrincipalName","mail",@{Name="ExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}}

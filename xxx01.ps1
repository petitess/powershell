Set-ADUser jdoe -Replace @{thumbnailPhoto=([byte[]](Get-Content "C:\photos\jdoe_photo.jpg" -Encoding byte))}

$dc = "dc-name.domain.local:389"
$dn = Get-ADUser joe | Select-Object -ExpandProperty distinguishedName
[byte[]]$jpg = Get-Content C:\photos\jdoe_photo.jpg -encoding byte
$user = [adsi]"LDAP://$dcname/$dn"
$user.Properties["jpegPhoto"].Clear()
$null = $user.Properties["jpegPhoto"].Add($jpg)
$user.CommitChanges()

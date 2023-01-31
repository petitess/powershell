Set-ADUser jdoe -Replace @{thumbnailPhoto=([byte[]](Get-Content "C:\photos\jdoe_photo.jpg" -Encoding byte))}

$dc = "dc-name.domain.local:389"
$dn = Get-ADUser joe | Select-Object -ExpandProperty distinguishedName
[byte[]]$jpg = Get-Content C:\photos\jdoe_photo.jpg -encoding byte
$user = [adsi]"LDAP://$dcname/$dn"
$user.Properties["jpegPhoto"].Clear()
$null = $user.Properties["jpegPhoto"].Add($jpg)
$user.CommitChanges()



az vm update --resource-group rg-vmvdaprod01 --name vmvdaprod01 --set osProfile.windowsConfiguration.enableAutomaticUpdates=false osProfile.windowsConfiguration.patchSettings.patchMode=AutomaticByPlatform


az vm get-instance-view --resource-group rg-vmvdaprod01 --name vmvdaprod01

az account show

az account set --subscription=""

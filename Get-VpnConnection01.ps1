Get-VpnConnection
(Get-VpnConnection).routes
(Get-VpnConnection).routes.DestinationPrefix

$conn = get-vpnconnection -ConnectionName "ITVisma-vnet"
$conn.routes

Remove-VpnConnectionRoute -ConnectionName "ITVisma-vnet" -DestinationPrefix 172.20.100.0/23
Add-VpnConnectionRoute -ConnectionName "ITVisma-vnet" -DestinationPrefix 172.20.100.0/23

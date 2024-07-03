$St = @(
    [pscustomobject]@{ Name = "stabcprodwe01"; RgName = "rg-compliancetool-common-prod-we-01"; SubName = "sub-compliancetool-prod-01" }
    [pscustomobject]@{ Name = "stdefprod01"; RgName = "rg-deliverycontract-common-prod-we-01"; SubName = "sub-deliverycontract-prod-01" }
    [pscustomobject]@{ Name = "stghiprodwe01"; RgName = "rg-pdb-common-prod-we-01"; SubName = "sub-pdb-prod-01" }
)

$St | ForEach-Object {

    $X = Set-AzContext -Subscription $_.SubName
    $S = (Get-AzStorageAccount -Name $_.Name -ResourceGroupName $_.RgName)
    $S.StorageAccountName

    $SUBNETID = "/subscriptions/xxx-c2c8df20f085/resourceGroups/rg-name/providers/Microsoft.Network/virtualNetworks/vnet-name/subnets/default"
    $DESTRG = $S.ResourceGroupName
    $DESTSTA = $S.StorageAccountName
    
    $A = Add-AzStorageAccountNetworkRule -ResourceGroupName $DESTRG -Name $DESTSTA -VirtualNetworkResourceId $SUBNETID
    $A.State
}

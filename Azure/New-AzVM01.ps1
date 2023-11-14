$VMLocalAdminUser = "azadmin"
$VMLocalAdminSecurePassword = ConvertTo-SecureString "Tphmz.8653b" -AsPlainText -Force
$LocationName = "swedencentral"
$ResourceGroupName = "rg-restore-prod-01"
$ComputerName = "vmsqllocal01"
$VMName = $ComputerName
$VMSize = "Standard_B4ms"
$NICName = "$VMName-nic"
$Vnet = Get-AzVirtualNetwork -Name "vnet-restore-prod-01"
$Subnet = Get-AzVirtualNetworkSubnetConfig -VirtualNetwork $Vnet -Name "snet-restore-prod-01"
$PIP = New-AzPublicIpAddress -Name "$VMName-nic-pip" -ResourceGroupName $ResourceGroupName -Location $LocationName -AllocationMethod Static -Confirm:$false -Force -Sku Standard
$NIC = New-AzNetworkInterface -Name $NICName -ResourceGroupName $ResourceGroupName -Location $LocationName -SubnetId $Subnet.id -PublicIpAddressId $PIP.Id -PrivateIpAddress "10.10.4.10" -Confirm:$false -Force
$Credential = New-Object System.Management.Automation.PSCredential ($VMLocalAdminUser, $VMLocalAdminSecurePassword);
$VirtualMachine = New-AzVMConfig -VMName $VMName -VMSize $VMSize
$VirtualMachine = Set-AzVMOSDisk -VM $VirtualMachine -DiskSizeInGB 500 -CreateOption FromImage
$VirtualMachine = Set-AzVMOperatingSystem -VM $VirtualMachine -Windows -ComputerName $ComputerName -Credential $Credential -ProvisionVMAgent -EnableAutoUpdate
$VirtualMachine = Add-AzVMNetworkInterface -VM $VirtualMachine -Id $NIC.Id
$VirtualMachine = Set-AzVMSourceImage -VM $VirtualMachine -PublisherName 'microsoftsqlserver' -Offer 'sql2019-ws2022' -Skus 'standard' -Version latest

New-AzVM -ResourceGroupName $ResourceGroupName -Location $LocationName -VM $VirtualMachine -Verbose -Confirm:$false

Get-AzTenant  ##e44a6fe3-543e-47c1-a8e6-0ab2841227c8
Get-AzResourceGroup
Disconnect-AzAccount
Connect-AzAccount
az logout

New-AzResourceGroupDeployment -TemplateFile G:\VM_AD_Command.bicep -resourceGroup KarolRG

New-AzResourceGroupDeployment -TemplateFile G:\bicep\modules\main.bicep -resourceGroup myRG

New-AzResourceGroupDeployment -TemplateFile D:\Skype\main.bicep -resourceGroup TestSQL

New-AzResourceGroupDeployment -TemplateFile G:\biceps\VM_PS_SCRIPT\main.bicep -resourceGroup TestM

New-AzSubscriptionDeployment -TemplateFile D:\2VM_VNET_CTX\main.bicep -Location westeurope

New-AzSubscriptionDeployment -TemplateFile G:\RunCommand\main.bicep -Location westeurope

Remove-AzResourceGroup -Name rg-vm-web-01
Remove-AzResourceGroup -Name rg-vm-ad-01
Remove-AzResourceGroup -Name rg-vm-sql-01
Remove-AzResourceGroup -Name rg-vnet-01

New-AzResourceGroupDeployment -TemplateFile main.bicep -resourceGroup myRG -name SQL2

New-AzResourceGroupDeployment -TemplateFile endpoint.bicep -resourceGroup myRG 


#List Of Available Azure VM Image Skus
Get-AzVMImageSku -Location 'North Europe' -PublisherName MicrosoftWindowsServer -Offer WindowsServer | select skus, offer, publishername
Get-AzVMImageSku -Location 'North Europe' -PublisherName microsoftsqlserver -Offer sql2019-ws2019 | select skus, offer, publishername

#List  VM size
Get-AzVMSize -Location 'North Europe'

az bicep decompile --file .\template.json


Get-AzVirtualNetworkSubnetConfig -ResourceId  B3CARE-SE-AD

Get-AzVirtualNetwork | select id, name, resourcegroupname

Get-AzPrivateLinkServiceConnection

New-Item -Path C:\Users\B3Admin\Desktop -ItemType file -Name test.txt

Invoke-AzVMRunCommand -ResourceGroupName KarolRG -Name Vm_AD01 -CommandId 'RunPowerShellScript' -ScriptPath '<pathToScript>' -Parameter @{"arg1" = "var1";"arg2" = "var2"}

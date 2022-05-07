Connect-AzAccount -Identity

New-AzStorageAccount -ResourceGroupName rg-aa-prod-sc-01 -Name st6564636453633234 -SkuName Standard_LRS -Location swedencentral -Kind StorageV2

#Enable "System assigned identity" in Automation Account

#Run this to use the System assigned identity
Connect-AzAccount -Identity

#Run your script
$RG = Get-AzResourceGroup -Name *
Write-Output $RG | select ResourceGroupName
$RG | Remove-AzResourceGroup -Force

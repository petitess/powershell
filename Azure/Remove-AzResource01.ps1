Set-AzContext "sub-prod-01"

$context = Get-AzContext

$azureUrl = $context.Environment.ResourceManagerUrl

$subscriptionId = "xxxx-be27-46a2-9bb0-xxxxx"
$rgName =  "rg-vmlicprod01"
$vmName = "vmlicprod01"

$linksResourceId = $azureUrl + "subscriptions/" + $subscriptionId  + '/providers/Microsoft.Resources/links'
$vmId = '/subscriptions/' + $subscriptionId + '/resourceGroups/' + $rgName + '/providers/Microsoft.Compute/virtualMachines/' + $vmName + '/'

Write-Host $("Deleting links for $vmId using resourceId: $linksResourceId")
 

$links = @(Get-AzResource -ResourceId $linksResourceId|  Where-Object {$_.Properties.sourceId -match $vmId -and $_.Properties.targetId.ToLower().Contains("microsoft.recoveryservices/vaults")})
Write-Host "Links to be deleted"
$links

#Delete all links which are of type 
Foreach ($link in $links)

{
 Write-Host $("Deleting link " + $link.Name)
 Remove-AzResource -ResourceId $link.ResourceId -Force
}


$links = @(Get-AzResource -ResourceId $linksResourceId|  Where-Object {$_.Properties.sourceId -match $vmId -and $_.Properties.targetId.ToLower().Contains("/protecteditemarmid/")})
Write-Host "Cross subscription Links to be deleted"
$links


#Delete all links which are of type 
Foreach ($link in $links)

{
 Write-Host $("Deleting link " + $link.Name)
 Remove-AzResource -ResourceId $link.ResourceId -Force
}
 
Write-Host $("Deleted all links ")

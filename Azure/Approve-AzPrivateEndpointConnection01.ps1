param (
    [Parameter(Mandatory)]
    [String]$SubId
)

Connect-AzAccount -Identity

Set-AzContext -Subscription $SubId

$StId = (Get-AzStorageAccount).id
$AppId = (Get-AzWebApp).Id

$StId + $AppId | ForEach-Object {
    $PepId = Get-AzPrivateEndpointConnection -PrivateLinkResourceId $_ | Where-Object { $_.PrivateLinkServiceConnectionState.Status -eq "Pending" }
    if ($null -ne $PepId) {
    (Approve-AzPrivateEndpointConnection -ResourceId $PepId[0]).Name
    $Status = (Get-AzPrivateEndpointConnection -ResourceId $PepId[0].Id).PrivateLinkServiceConnectionState.Status
    $Name = (Get-AzPrivateEndpointConnection -ResourceId $PepId[0].Id).Name
    Write-Output $($Status + ": " + $Name)
    } else {
        Write-Output "Nothing to approve"
    }
}

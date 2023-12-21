param (
    [Parameter(Mandatory)]
    [string]$EXTSUBID
)
Connect-AzAccount -Identity

Set-AzContext -Subscription "$EXTSUBID"
Write-Output $("INFO: " + ((Get-AzContext).Name).ToUpper())
Write-Output $("ID: " + $EXTSUBID)

$StId = (Get-AzStorageAccount).id
$AppId = (Get-AzWebApp).Id

$StId + $AppId | ForEach-Object {
    $PepId = Get-AzPrivateEndpointConnection -PrivateLinkResourceId $_ | Where-Object { $_.PrivateLinkServiceConnectionState.Status -eq "Pending" }
    if ($null -ne $PepId) {
        (Approve-AzPrivateEndpointConnection -ResourceId $PepId[0].Id).Name
        $Status = (Get-AzPrivateEndpointConnection -ResourceId $PepId[0].Id).PrivateLinkServiceConnectionState.Status
        $Name = (Get-AzPrivateEndpointConnection -ResourceId $PepId[0].Id).Name
        Write-Output $($Status + ": " + $Name)
    }
    else {
        Write-Output "Nothing to approve $($Name)"
    }
}

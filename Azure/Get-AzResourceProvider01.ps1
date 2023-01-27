$rp = ((Get-AzResourceProvider -ProviderNamespace "Microsoft.Compute" -Location "swedencentral").ResourceTypes).ResourceTypeName

foreach ($r in $rp) {
Write-Output "'Microsoft.Compute/$r'"
}

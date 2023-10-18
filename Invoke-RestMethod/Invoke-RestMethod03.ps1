$rsv = Get-AzRecoveryServicesVault -ResourceGroupName "rg-infra-prod-sc-01" -Name "rsv-infra-prod-01"
$headers = @{
    "Authorization" = "Bearer $((Get-AzAccessToken).Token)"
    "Content-type"  = "application/json"
  }

$Method = 'GET'
$Uri = "https://management.azure.com$($rsv.ID)/usages?api-version=2023-04-01"
$usage = Invoke-RestMethod -Method $Method -Uri $Uri -Headers $headers

$size = $usage.value | Where-Object {$_.Name.value -eq "GRSStorageUsage"}
$containersize = $size.currentValue / 1GB
Write-Output "Recovery vault Size: $containersize (Gbytes)"

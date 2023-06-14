$Method = 'GET'
$Path = "/subscriptions/xxx-1a10-483e-95aa-xxxx/resourceGroups/rg-asr-test-01/providers/Microsoft.RecoveryServices/vaults/rsv-asr-01/replicationFabrics/asr-a2a-default-swedencentral/replicationProtectionContainers/asr-a2a-default-swedencentral-container/replicationProtectedItems/467b7b8e-efcc-43d6-a2d2-51dc8a74f825?api-version=2023-02-01"
(Invoke-AzRestMethod -Method $Method -Path $Path).Content | Out-File policy.json

$Method = 'GET'
$Path = "/subscriptions/d7909d2e-2a55-4c2f-b005-d700d0bc3e66/providers/Microsoft.Authorization/roleManagementPolicies?api-version=2020-10-01-preview&`$filter=roleDefinitionId%20eq%20'/subscriptions/xxxxxxx-2a55-4c2f-b005-xxxxx/providers/Microsoft.Authorization/roleDefinitions/8e3af657-a8ff-443c-a75c-2fe8c4bcb635'"
(Invoke-AzRestMethod -Method $Method -Path $Path).Content | Out-File policy.json

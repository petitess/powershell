Install-Module -Name Az.ResourceGraph

Search-AzGraph -Query "patchassessmentresources
| where type == 'microsoft.compute/virtualmachines/patchassessmentresults'
| where subscriptionId == 'xxx-be27-46a2-9bb0-xxx'
| where properties.availablePatchCountByClassification.security > 0 or properties.availablePatchCountByClassification.critical > 0
| extend 
security = properties.availablePatchCountByClassification.security,
critical = properties.availablePatchCountByClassification.critical
| project resourceGroup, security, critical"
#
Search-AzGraph -Query "resources
|where type == 'microsoft.keyvault/vaults'
|where properties.publicNetworkAccess == 'Enabled'
|mv-expand properties.networkAcls.ipRules
|project kvName = name, kvRule = properties.networkAcls.ipRules"
#
$Query = 'securityresources | where type == "microsoft.security/assessments"'
Search-AzGraph -Query $Query
#
$Query = "
securityresources
| where name == '.net_6.0.24.0'
"
Search-AzGraph -Query $Query | ConvertTo-Json
#
$Query = "
securityresources
| where name == '.net_6.0.24.0'
| summarize Count = count() by name
"
Search-AzGraph -Query $Query

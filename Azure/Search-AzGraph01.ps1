Install-Module -Name Az.ResourceGraph

Search-AzGraph -Query "patchassessmentresources
| where type == 'microsoft.compute/virtualmachines/patchassessmentresults'
| where subscriptionId == 'b2f0f1dc-be27-46a2-9bb0-e80270acfaa0'
| where properties.availablePatchCountByClassification.security > 0 or properties.availablePatchCountByClassification.critical > 0
| extend 
security = properties.availablePatchCountByClassification.security,
critical = properties.availablePatchCountByClassification.critical
| project resourceGroup, security, critical"



Search-AzGraph -Query "resources
|where type == 'microsoft.keyvault/vaults'
|where properties.publicNetworkAccess == 'Enabled'
|mv-expand properties.networkAcls.ipRules
|project kvName = name, kvRule = properties.networkAcls.ipRules"

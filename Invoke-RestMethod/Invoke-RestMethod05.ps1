$token = az account get-access-token --query "accessToken" -o tsv
$devopsOrgName = "Company"
# WIQL query to get all work items
$wiql = @"
{
  "query": "SELECT [System.Id], [System.Title], [System.State] FROM WorkItems WHERE [System.TeamProject] = @project"
}
"@

$uri = "https://dev.azure.com/$devopsOrgName/Almi/_apis/wit/wiql?api-version=7.1"

# Get list of work item IDs
$response = Invoke-RestMethod -Method POST -Uri $uri -Headers @{
    Authorization = "Bearer $token"
    "Content-Type" = "application/json"
} -Body $wiql

# Extract work item IDs
$workItemIds = $response.workItems[0..100].id -join ','

# Get full work item details
$detailsUri = "https://dev.azure.com/$devopsOrgName/_apis/wit/workitems?ids=$($workItemIds)&api-version=7.1"
$allWorkItems = Invoke-RestMethod -Method GET -Uri $detailsUri -Headers @{
    Authorization = "Bearer $token"
}

$allWorkItems.value.fields.'System.State'
$allWorkItems.value.fields.'System.Id'
$allWorkItems.value.fields.'System.AssignedTo'

$allWorkItems.value | Where-Object id -eq "2265"  .fields
($allWorkItems.value | Where-Object id -eq "1116").fields 

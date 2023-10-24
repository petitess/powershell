$devopsOrgName = "ssgse"
$spiname = "sp-infra-fed-01"
$projectName = "Infrastruktur"
$projectId = az devops project show --project $projectName --query "id" --output tsv
$subName = "sub-infra-dev-01"
$newSubId = az account list --query "[?name=='$subName'].id" -o tsv
$tenantID = az account show --query "tenantId" -o tsv
$appRegId = "sp-infra-dev-01"
$spiID = az ad sp list --display-name $appRegId --query [].appId -o tsv
$token = az account get-access-token --query accessToken --output tsv
$body = ConvertTo-Json -Depth 10 @{
    type                             = "azurerm"
    name                             = $spiname
    
    authorization                    = @{
        scheme     = "WorkloadIdentityFederation"
        #scheme = "ServicePrincipal"
        parameters = @{
            tenantid = $tenantID
            serviceprincipalid = $spiID
        }
    }
    data                             = @{
        subscriptionId   = $newSubId
        subscriptionName = $subName
        environment      = "AzureCloud"
        scopeLevel       = "Subscription"
    }
    serviceEndpointProjectReferences = @(
        @{
            description      = ""
            name             = $spiname
            projectReference = @{
                id   = $projectId
                name = $projectName
            }
        }
    )
}

Invoke-RestMethod  -Method POST -Uri "https://dev.azure.com/$devopsOrgName/$devopsProjectName/_apis/serviceendpoint/endpoints?api-version=7.1-preview.4" -Headers @{ Authorization = "Bearer $token"; "Content-Type" = "application/json" } -Body $body

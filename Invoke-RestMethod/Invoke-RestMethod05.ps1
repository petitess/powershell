$devopsOrgName = "xxx"
$spiname = "sp-infra-dev-01"
$serviceEndpointId = az devops service-endpoint list --query "[?name=='$spiname'].id" -o tsv
$projectName = "Infrastruktur"
$projectId = az devops project show --project $projectName --query "id" --output tsv
$token = az account get-access-token --query accessToken --output tsv
$body = ConvertTo-Json -Depth 10 @{
    type = "azurerm"
    authorization = @{
        scheme = "WorkloadIdentityFederation"
        #scheme = "ServicePrincipal"
    }
    serviceEndpointProjectReferences= @(
        @{
            description= ""
            name = $spiname
            projectReference = @{
                id= $projectId
                name = $projectName
            }
        }
    )
}

Invoke-RestMethod  -Method PUT -Uri "https://dev.azure.com/$devopsOrgName/$devopsProjectName/_apis/serviceendpoint/endpoints/${serviceEndpointId}?operation=ConvertAuthenticationScheme&api-version=7.2-preview.4" -Headers @{ Authorization = "Bearer $token"; "Content-Type" = "application/json"} -Body $body

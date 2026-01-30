param (
    [Parameter(Mandatory)]
    [Alias('Subscription Name')]
    [String]$SubName,

    [Parameter(Mandatory)]
    [Alias('DevOps Project Name')]
    [String]$DevopsProjectName,

    [Parameter(Mandatory)]
    [Alias('Management Group Id')]
    [String]$MgName
)

$rbac = "Owner"
$devopsOrg = "https://dev.azure.com/ABCse"
$devopsOrgName = "ABCse"
$projectId = az devops project show --project $DevopsProjectName --org $devopsOrg --query "id" --output tsv
"projectId: $projectId"
$tenantID = az account show --query "tenantId" -o tsv
"tenantID: $tenantID"
$token = az account get-access-token --query accessToken --output tsv
if (!$token) {
    Write-Error "Failed to acquire access token."
    exit 1
}
"token: $($token.Substring(1,20))"

$spiname = ($SubName).Replace('sub', 'sp')
$spiname

# Create Service Principal
$appId = az ad app create --display-name $spiname --query "appId" -o tsv

"appId: $appId"
"ObjectId: $ObjectId"

if (!(az ad sp show --id $appId)) {
    az ad sp create --id $appId -o tsv --query "id"
    "Created Service Principal for appId: $appId"
}
# Assign the Service Principal, "Contributor" RBAC on Subscription Level:-
$newSub = az account subscription list --query "[?state=='Enabled' && displayName=='$SubName'].subscriptionId" -o tsv
if (!$newSub) {
    Write-Error "Failed to retrieve subscription ID for $SubName."
    exit 1
}
"newSub: $newSub"

az role assignment create --assignee "$appId" --role "$rbac" --scope "/subscriptions/$newSub" -o table
"Assigned $rbac role to $appId on subscription $newSub "

# Set Default DevOps Organisation and Project:-
az devops configure --defaults organization=$devopsOrg project=$DevopsProjectName -o table
"Set default DevOps organization to $devopsOrg and project to $DevopsProjectName"

# Update DevOps Service Connection with Federated Credentials:-
$serviceEndpointId = az devops service-endpoint list --org $devopsOrg --project $DevopsProjectName --query "[?name=='$spiname'].id" -o tsv
"serviceEndpointId: $serviceEndpointId"
$authorization = az devops service-endpoint list --org $devopsOrg --project $DevopsProjectName --query "[?name=='$spiname'].authorization.scheme" -o tsv
"authorization: $authorization"
if ($serviceEndpointId) {
    Write-Output "Found service endpoint: $serviceEndpointId"
    if ($authorization -notmatch "WorkloadIdentityFederation") {
        Write-Output "Configuring Workload Identity Federation"
        $uri = "https://dev.azure.com/$devopsOrgName/$DevopsProjectName/_apis/serviceendpoint/endpoints/${serviceEndpointId}?operation=ConvertAuthenticationScheme&api-version=7.2-preview.4"
        $body = ConvertTo-Json -Depth 10 @{
            type                             = "azurerm"
            authorization                    = @{
                scheme = "WorkloadIdentityFederation"
            }
            serviceEndpointProjectReferences = @(
                @{
                    name             = $spiname
                    projectReference = @{
                        id   = $projectId
                        name = $DevopsProjectName
                    }
                }
            )
        }
        Invoke-RestMethod  -Method PUT -Uri $uri  -Headers @{ Authorization = "Bearer $token"; "Content-Type" = "application/json" } -Body $body
        "Updated service endpoint to Workload Identity Federation"
    }
}
else {
    Write-Output "Creating service endpoint"
    $uri = "https://dev.azure.com/$devopsOrgName/$DevopsProjectName/_apis/serviceendpoint/endpoints?api-version=7.2-preview.4"
    $body = ConvertTo-Json -Depth 10 @{
        type                             = "azurerm"
        name                             = $spiname
        authorization                    = @{
            scheme     = "WorkloadIdentityFederation"
            parameters = @{
                tenantid           = $tenantID
                serviceprincipalid = $appId #$spiID
            }
        }
        data                             = @{
            subscriptionId   = $newSub
            subscriptionName = $SubName
            environment      = "AzureCloud"
            scopeLevel       = "Subscription"
        }
        serviceEndpointProjectReferences = @(
            @{
                name             = $spiname
                projectReference = @{
                    id   = $projectId
                    name = $DevopsProjectName
                }
            }
        )
    }
    $NewSe = Invoke-RestMethod  -Method POST -Uri $uri -Headers @{ Authorization = "Bearer $token"; "Content-Type" = "application/json" } -Body $body
    $Issuer = $NewSe.authorization.parameters.workloadIdentityFederationIssuer 
    $Subject = $NewSe.authorization.parameters.workloadIdentityFederationSubject 
    "Created service endpoint with Workload Identity Federation"
}

$app = az ad app federated-credential list --id $appId --query "[?name=='devops'].id" -o tsv

if ($app) {
    Write-Output "Federated credentials exist"
}
else {
    $url = "https://graph.microsoft.com/v1.0/applications?`$filter=appId eq '$appId'"
    $headers = "Content-type=application/json"
    $ObjectId = az rest --method get --uri $url --headers $headers --query "value[0].id" -o tsv
    if (!$ObjectId) {
        Write-Error "Failed to retrieve Object ID for appId: $appId."
        exit 1
    }

    $FedParameters = @{
        name      = "devops"
        issuer    = "$Issuer"
        subject   = "$Subject"
        audiences = @("api://AzureADTokenExchange")
    } | ConvertTo-Json -Depth 10
    # az ad app federated-credential create --id $appId --parameters $FedParameters
    $url = "https://graph.microsoft.com/v1.0/applications/$ObjectId/federatedIdentityCredentials"
    $headers = "Content-type=application/json"
    $FedParameters | az rest --method post --uri $url --headers $headers --body '@-'
}

##GET personal access tokens
$token = az account get-access-token --query accessToken --output tsv
$devopsOrg = "XXXX"

$uri = "https://vssps.dev.azure.com/$($devopsOrg)/_apis/tokens/pats?api-version=7.1-preview.1"
$PATs = Invoke-RestMethod  -Method GET -Uri $uri  -Headers @{ Authorization = "Bearer $token"; "Content-Type" = "application/json" }
$PATs.patTokens

##GET personal access token
$authorizationId = "xxxx-e278-4682-85fe-4bc95f2bb811"

$uri = "https://vssps.dev.azure.com/$($devopsOrg)/_apis/tokens/pats?authorizationId=$($authorizationId)&api-version=7.1-preview.1"
$PAT = Invoke-RestMethod  -Method GET -Uri $uri  -Headers @{ Authorization = "Bearer $token"; "Content-Type" = "application/json" }
$PAT.patToken
$PAT.patToken.scope

##POST new token
$Body = ConvertTo-Json -Depth 100 @{
    displayName = "devops-pat"
    scope       = "vso.pipelineresources_manage"
    validTo     = (Get-Date).AddDays(30)
    allOrgs     = 'false'
}
$uri = "https://vssps.dev.azure.com/$($devopsOrg)/_apis/tokens/pats?api-version=7.1-preview.1"
$NewPAT = Invoke-RestMethod  -Method POST -Uri $uri  -Headers @{ Authorization = "Bearer $token"; "Content-Type" = "application/json" } -Body $Body
$NewPAT.patToken.token
$NewPAT.patToken.authorizationId

##PUT update token
$Body = ConvertTo-Json -Depth 100 @{
    displayName = "devops-pat"
    scope       = "vso.pipelineresources_manage vso.code_full"
    validTo     = (Get-Date).AddDays(30)
    allOrgs     = 'false'
    authorizationId = "xxxx-669b-4d9b-acb2-b0fd2eb80fee"
}

$uri = "https://vssps.dev.azure.com/$($devopsOrg)/_apis/tokens/pats?api-version=7.1-preview.1"
$UpdatedPAT = Invoke-RestMethod  -Method PUT -Uri $uri  -Headers @{ Authorization = "Bearer $token"; "Content-Type" = "application/json" } -Body $Body
$UpdatedPAT.patToken


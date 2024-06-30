#Azure Info
az login --service-principal -u "x-ff06ef66d700" -p "xTaTN" --tenant "x-2112d502f2ff"
$Token = az account get-access-token --scope "2ff814a6-3304-4ab8-85cb-cd0e6f879c1d/.default" --query accessToken --output tsv
$DatabricksUrl = "https://adb-x.4.azuredatabricks.net"
$DatabricksHeaders = @{
    "Authorization" = "Bearer $Token"
    "Content-type"  = "application/json"
}
#Github Info
$GitHubToken = "ghp_LlvjpxR0AMD74"
$GithubUrlRepo = "https://$GitHubToken@github.com/X-APPLICATIONS/x-notebooks.git"

$DatabricksMainFolder = "/NotebooksABC"

$DatabricksUrlCred = "$DatabricksUrl/api/2.0/git-credentials"
$DatabricksBodyCred = ConvertTo-Json @{
    personal_access_token = $GitHubToken
    git_username          = "user"
    git_provider          = "gitHub"
}
$Add = Invoke-RestMethod -Method POST -URI $DatabricksUrlCred -Headers $DatabricksHeaders -Body $DatabricksBodyCred
$Add.credential_id

$DatabricksUrlCredPatch = "$DatabricksUrl/api/2.0/git-credentials/$($Add.credential_id)"
$DatabricksBodyCredPatch = ConvertTo-Json @{
    personal_access_token = $GitHubToken
    git_username          = "user"
    git_provider          = "gitHub"
}
$Patch = Invoke-RestMethod -Method PATCH -URI $DatabricksUrlCredPatch -Headers $DatabricksHeaders -Body $DatabricksBodyCredPatch
$Patch.credential_id

$DatabricksUrlCredDelete = "$DatabricksUrl/api/2.0/git-credentials/$($Add.credential_id)"
$Delete = Invoke-RestMethod -Method Delete -URI $DatabricksUrlCredDelete -Headers $DatabricksHeaders -Body $DatabricksBodyCredDelete
$Delete.credential_id

$DatabricksUrlRepo = "$DatabricksUrl/api/2.0/repos"
$DatabricksBodyRepo = ConvertTo-Json @{
    url      = $GithubUrlRepo
    path     = $DatabricksMainFolder
    provider = "gitHub"
}
$Repo = Invoke-RestMethod -Method POST -URI $DatabricksUrlRepo -Headers $DatabricksHeaders -Body $DatabricksBodyRepo
$Repo.id

$DatabricksUrlRepoUpdate = "$DatabricksUrl/api/2.0/repos/$($Repo.id)"
$DatabricksBodyUpdate = ConvertTo-Json @{
    branch = "main"
}
$Repo = Invoke-RestMethod -Method PATCH -URI $DatabricksUrlRepoUpdate -Headers $DatabricksHeaders -Body $DatabricksBodyUpdate
$Repo.id

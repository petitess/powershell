
#Azure Info
az login --service-principal -u "x-ff06ef66d700" -p "x6TaTN" --tenant "x-2112d502f2ff"
$Token = az account get-access-token --scope "2ff814a6-3304-4ab8-85cb-cd0e6f879c1d/.default" --query accessToken --output tsv
$DatabricksUrl = "https://adb-x.4.azuredatabricks.net"
$DatabricksHeaders = @{
    "Authorization" = "Bearer $Token"
    "Content-type"  = "application/json"
}
#Github Info
$GitHubUrl = "https://api.github.com/repos/X-APPLICATIONS/x-notebooks"
$GitHubToken = "ghp_Llvjp3zQB1GZxZR0AMD74"
$GitHubHeaders = @{
    "Authorization"        = "Bearer $GitHubToken"
    "Accept"               = "application/vnd.github+json"
    "X-GitHub-Api-Version" = "2022-11-28"
}

$DatabricksMainFolder = "/NotebooksABC"
#Delete Folder
$DatabricksUrlDelete = "$DatabricksUrl/api/2.0/workspace/delete"
Write-Output "Deleting: $DatabricksMainFolder"
$DatabricksBodyDelete = ConvertTo-Json @{
    path      = $DatabricksMainFolder
    recursive = "true"
}
$Delete = Invoke-RestMethod -Method POST -URI $DatabricksUrlDelete -Headers $DatabricksHeaders -Body $DatabricksBodyDelete
$Delete
#Add Folder
$DatabricksUrlAdd = "$DatabricksUrl/api/2.0/workspace/mkdirs"
Write-Output "Adding: $DatabricksMainFolder"
$DatabricksBodyDir = ConvertTo-Json @{
    path = $DatabricksMainFolder
    url = $GitHubUrl
    provider = "Github"
}
$Add = Invoke-RestMethod -Method POST -URI $DatabricksUrlAdd -Headers $DatabricksHeaders -Body $DatabricksBodyDir
$Add
#Get Github Tree
$GitHubUrlTree = "$GitHubUrl/git/trees/main?recursive=true"
$T = Invoke-RestMethod -Method GET -URI $GitHubUrlTree -Headers $GitHubHeaders
#Create folders in databricks
$T.tree | Where-Object { $_.type -eq "tree" } |  ForEach-Object {
    Write-Output "Creating folder: $($_.path)"

    $DatabricksUrlDir = "$DatabricksUrl/api/2.0/workspace/mkdirs"
    $DatabricksBodyDir = ConvertTo-Json @{
        path = "$DatabricksMainFolder/$($_.path)"
    }
    $F = Invoke-RestMethod -Method POST -URI $DatabricksUrlDir -Headers $DatabricksHeaders -Body $DatabricksBodyDir
}
#Create files in databricks
$T.tree | Where-Object { $_.type -eq "blob" } |  ForEach-Object {
    $GitHubUrlContent = "$GitHubUrl/contents/$($_.path)"
    $GitHubHeaders = @{
        "Authorization"        = "Bearer $GitHubToken"
        "Accept"               = "application/vnd.github+json"
        "X-GitHub-Api-Version" = "2022-11-28"
    }
    $File = Invoke-RestMethod -Method GET -URI $GitHubUrlContent -Headers $GitHubHeaders

    $DatabricksUrlImport = "$DatabricksUrl/api/2.0/workspace/import"
    Write-Output "Creating file: $DatabricksMainFolder/$($File.path)"
    $DatabricksBodyImport = ConvertTo-Json @{
        path      = "$DatabricksMainFolder/$($File.path)"
        language  = "PYTHON"
        format    = "SOURCE"
        contant   = $File.content
        overwrite = "true"
    }
    $Notebook = Invoke-RestMethod -Method POST -URI $DatabricksUrlImport -Headers $DatabricksHeaders -Body $DatabricksBodyImport
}

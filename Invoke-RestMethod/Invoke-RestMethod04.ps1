#Azure DevOps Personal Access Token
# https://learn.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate?view=azure-devops&tabs=Windows

$personalAccessToken = "<Enter your personal access token here>"
$token = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes(":$($personalAccessToken)"))
$header = @{authorization = "Basic $token"}

$organization = "<Enter your Azure DevOps Organization here>"
$project = "<Enter your Project Name here>"

$pipelineName = "<Enter the Build Pipeline Definition Name to be deleted here>"

#Get all build definitions
# API: GET https://dev.azure.com/{organization}/{project}/_apis/build/definitions/{definitionId}?api-version=6.0
$url = "https://dev.azure.com/$organization/$project/_apis/build/definitions?api-version=6.0"
$allBuildDefinitions = Invoke-RestMethod -Uri $url -Method Get -ContentType "application/json" -Headers $header

$allBuildDefinitions.value | Where-Object {$_.name -eq $pipelineName} | ForEach-Object {
    Write-Host $_.id $_.name $_.queueStatus
 
    # For debugging reasons, just to be sure that we don't delete the wrong build pipeline
    if ( $_.name -ne $pipelineName ) {
        return;
    }

    #Get all Builds for a Definition
    # API: GET https://dev.azure.com/{organization}/{project}/_apis/build/builds?definitions={definitions}&queues={queues}&buildNumber={buildNumber}&minTime={minTime}&maxTime={maxTime}&requestedFor={requestedFor}&reasonFilter={reasonFilter}&statusFilter={statusFilter}&resultFilter={resultFilter}&tagFilters={tagFilters}&properties={properties}&$top={$top}&continuationToken={continuationToken}&maxBuildsPerDefinition={maxBuildsPerDefinition}&deletedFilter={deletedFilter}&queryOrder={queryOrder}&branchName={branchName}&buildIds={buildIds}&repositoryId={repositoryId}&repositoryType={repositoryType}&api-version=6.0
    $url = "https://dev.azure.com/$organization/$project/_apis/build/builds?definitions=" + $_.id + "&api-version=6.0"
    $allBuildsOfDefinition = Invoke-RestMethod -Uri $url -Method Get -ContentType "application/json" -Headers $header
 
    #Process each Build of Definition
    $allBuildsOfDefinition.value | Where-Object {$_.retainedByRelease -eq "True"} | Sort-Object id | ForEach-Object {
        #Report on retain status
        Write-Host "Build Id:" $_.id " retainedByRelease:" $_.retainedByRelease

        #Get all Retention Leases for this Build
        # API: GET https://dev.azure.com/{organization}/{project}/_apis/build/builds/{buildId}/leases?api-version=7.1-preview.1
        $url = "https://dev.azure.com/$organization/$project/_apis/build/builds/" + $_.id + "/leases?api-version=7.1-preview.1"
        $allLeasesOfBuild = Invoke-RestMethod -Uri $url -Method Get -ContentType "application/json" -Headers $header

        #Delete each Lease of Build
        $allLeasesOfBuild.value | ForEach-Object {
            #Delete Lease
            # API: DELETE https://dev.azure.com/{organization}/{project}/_apis/build/retention/leases?ids={ids}&api-version=7.1-preview.2
            $url = "https://dev.azure.com/$organization/$project/_apis/build/retention/leases?ids=" + $_.leaseId + "&api-version=7.1-preview.2"
            Invoke-RestMethod -Uri $url -Method Delete -ContentType "application/json" -Headers $header

            #Report on Lease deleted
            Write-Host "Lease Id:" $_.leaseId " deleted"
        }

        #Delete Build
        # API: DELETE https://dev.azure.com/{organization}/{project}/_apis/build/builds/{buildId}?api-version=7.1-preview.7
        $url = "https://dev.azure.com/$organization/$project/_apis/build/builds/" + $_.id + "?api-version=7.1-preview.7"
        Invoke-RestMethod -Uri $url -Method Delete -ContentType "application/json" -Headers $header

        #Report on Build deleted
        Write-Host "Build Id:" $_.id " deleted"
    }

    #Delete the Build Definition
    # API: DELETE https://dev.azure.com/{organization}/{project}/_apis/build/definitions/{definitionId}?api-version=6.0
    $url = "https://dev.azure.com/$organization/$project/_apis/build/definitions/" + $_.id + "?api-version=6.0"
    Invoke-RestMethod -Uri $url -Method Delete -ContentType "application/json" -Headers $header
    
    Write-Host "Build Definition:" $pipelineName " (" $_.id ") deleted"
}
    
Write-Host "Habe fertig!"

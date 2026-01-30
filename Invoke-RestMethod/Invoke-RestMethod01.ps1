$token = az account get-access-token --query "accessToken" -o tsv
#Columns/HEader must have unique names
Import-Csv "C:\tools\file.csv" `
    -Delimiter ',' -Encoding utf8

#The amount of columns must match the amount of columns in the CSV file
$csvData = Import-Csv "C:\tools\Jfile.csv" `
    -Delimiter ',' -Encoding utf8 `
    -Header 'Summary', 'Issue key', 'Issue Id', 'Issue Type', 'Status', 'Project key', 'Project name', 'Project type', 'Project lead', 'Project lead id', `
    'Project description', 'Project url', 'Priority', 'Resolution', 'Assignee', 'Assignee Id', 'Reporter', 'Reporter Id'
# $csvData | ConvertTo-Json | Out-File "C:\tools\file.json"
$csvData[0] #Match Columns
$csvData[1] #First Ite m
$csvData[1..$csvData.Count] #Skip first item
$csvData.Count
$csvData.'Issue Type'
$csvData.'Status Category'
$csvData.'Reporter'

$devopsOrgName = "Company"
$DevopsProjectName = "Project"

$csvData[1..10] | ForEach-Object {

    switch ($_.'Issue Type') {
        "Task" { $WorkItemType = "Task" }
        "Story" { $WorkItemType = "User Story" }
        "Bug" { $WorkItemType = "Bug" }
        Default { $WorkItemType = "Task" }
    }

    switch ($_.'Status Category') {
        "To Do" { $State = "New" }
        "In Progress" { $State = "Active" }
        "Done" { $State = "Closed" }
        Default { $State = "New" }
    }

    switch ($_.'Reporter') {
        'Anna B' { $AssignedTo = 'anna.b@company.se' }
        Default { $AssignedTo = "" }
    }

    if ($State = "Active") {
        $AssignedTo = 'anna.b@company.se'
    }


    Write-Output $_.Summary
    Write-Output $_."Status Category"
    Write-Output $WorkItemType
    $Title = $_.Summary
    $Description = $_.Description

    $body = @(
        @{
            op    = "add"
            path  = "/fields/System.Title"
            value = $Title
        },
        @{
            op    = "add"
            path  = "/fields/System.Description"
            value = $Description
        },
        @{
            op    = "add"
            path  = "/fields/System.AssignedTo"
            value = $AssignedTo
        }

    ) | ConvertTo-Json -Depth 10 -AsArray

    $uri = "https://dev.azure.com/$devopsOrgName/$DevopsProjectName/_apis/wit/workitems/`$" + $WorkItemType + "?api-version=7.1"
    $NewItem = Invoke-RestMethod -Method POST -Uri $uri -Headers @{
        Authorization  = "Bearer $token"
        "Content-Type" = "application/json-patch+json"
    } -Body $body
    Write-Output $NewItem.id

    if ($State -eq "Closed") {
        $body = @(
            @{
                op    = "add"
                path  = "/fields/System.State"
                value = $State
            }
        ) | ConvertTo-Json -Depth 10 -AsArray

        $uri = "https://dev.azure.com/$devopsOrgName/$DevopsProjectName/_apis/wit/workitems/$($NewItem.id)?api-version=7.1"
        $NewItem = Invoke-RestMethod -Method PATCH -Uri $uri -Headers @{
            Authorization  = "Bearer $token"
            "Content-Type" = "application/json-patch+json"
        } -Body $body
        Write-Output "Closed: $($NewItem.fields.'System.Title')"
    }
}




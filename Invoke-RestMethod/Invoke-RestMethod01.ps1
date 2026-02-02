$token = az account get-access-token --query "accessToken" -o tsv
$devopsOrgName = 'DevOpsabcd'
$DevopsProjectName = 'abcd.se'

$csvData = Import-Csv "C:\tools\Jira - Tieto Tech Consulting.csv" `
    -Delimiter ',' -Encoding utf8 `
    -Header 'Summary', 'Issue key', 'Issue Id', 'Issue Type', 'Status', 'Project key', 'Project name', 'Project type', 'Project lead', 'Project lead id', `
    'Project description', 'Project url', 'Priority', 'Resolution', 'Assignee', 'Assignee Id', 'Reporter', 'Reporter Id', `
    'Creator' , 'Creator Id' , 'Created' , 'Updated' , 'Last Viewed' , 'Resolved' , 'Due date' , 'Labels' , 'Description' , 'Environment' , 'Watchers' , 'Status Category' , 'Status Category Changed'
# $csvData | ConvertTo-Json | Out-File "C:\tools\Jira - Tieto Tech Consulting.json"
$csvData[0] #Match Columns
$csvData[1] #First Ite m
$csvData[1..$csvData.Count].Count #Skip first item
$csvData.Count

$csvData.'Issue Type'
$csvData.'Status Category'
$csvData.'Reporter'

$csvData[3].'Issue Type'
$csvData[9].'Summary'

$Count = 0
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
        'Anna Berglund' { $AssignedTo = 'anna.berglund@abcd.se' }
        Default { $AssignedTo = "" }
    }

    if ($State -eq "Active") {
        $AssignedTo = 'anna.berglund@abcd.se'
    }
  
    Write-Output $State
    Write-Output $AssignedTo
    Write-Output $_.Summary
    Write-Output $_."Status Category"
    Write-Output $WorkItemType
    $IssueKey = $_.'Issue key'
    $Count++
    Write-Output $Count
    $Title = $_.Summary
    $Description = $_.Description
    $body = @(
        @{
            op    = "add"
            path  = "/fields/System.Title"
            value = "[$IssueKey] $Title"
        },
        @{
            op    = "add"
            path  = "/fields/Microsoft.VSTS.TCM.SystemInfo"
            value = $Description
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
        },
        @{
            op    = "add"
            path  = "/multilineFieldsFormat/System.Description"
            value = "Markdown"
        },
        @{
            op    = "add"
            path  = "/multilineFieldsFormat/Microsoft.VSTS.TCM.SystemInfo"
            value = "Markdown"
        },
        @{
            op    = "add"
            path  = "/fields/System.Tags"
            value = "$IssueKey; $Count"
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
        $UpdateItemState = Invoke-RestMethod -Method PATCH -Uri $uri -Headers @{
            Authorization  = "Bearer $token"
            "Content-Type" = "application/json-patch+json"
        } -Body $body
        Write-Output "Closed: $($UpdateItemState.fields.'System.Title')"
    }
}

#Columns/Headers must have unique names
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

$stName = "sttrustprod01" 
$stRgName = "rg-st-prod-01"
$tableName = "weather"

$stKey = (Get-AzStorageAccountKey -ResourceGroupName $stRgName -Name $stName).Value[0]
$ctx = New-AzStorageContext -StorageAccountName $stName  -StorageAccountKey $stKey  

$table = Get-AzStorageTable -Name $tableName -Context $ctx

$content = Get-AzTableRow -Table $table.CloudTable
$content
$content | ConvertTo-Json

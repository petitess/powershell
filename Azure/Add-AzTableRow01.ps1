$stName = "sttrustprod01" 
$stRgName = "rg-st-prod-01"
$tableName = "cars"

$stKey = (Get-AzStorageAccountKey -ResourceGroupName $stRgName -Name $stName).Value[0]
$ctx = New-AzStorageContext -StorageAccountName $stName  -StorageAccountKey $stKey 
$X = Get-AzStorageTable -Context $ctx | Where-Object { $_.Name -eq $tableName }
!$X ? (New-AzStorageTable –Name $tableName –Context $ctx) : ""

$table = Get-AzStorageTable -Name $tableName -Context $ctx

$LinkSchedule = @(
    [pscustomobject]@{make = 'BMW'; model = 'X6'; year = 2020; color = "black" }
    [pscustomobject]@{make = 'Volvo'; model = 'XC90'; year = 2022; color = "white" }
    [pscustomobject]@{make = 'Toyota'; model = 'Rav 4'; year = 2016; color = "red" }
    [pscustomobject]@{make = 'Mercedes'; model = 'S63 AMG'; year = 2018; color = "black" }
    [pscustomobject]@{make = 'BMW'; model = 'X2'; year = 2020; color = "orange" }
    [pscustomobject]@{make = 'Volkswagen'; model = 'Arteon'; year = 2018; color = "green" }
    [pscustomobject]@{make = 'Citroen'; model = 'C4'; year = 2022; color = "white" }
    [pscustomobject]@{make = 'BMW'; model = 'M3'; year = 2023; color = "blue" }
    [pscustomobject]@{make = 'Volvo'; model = 'S60'; year = 2021; color = "black" }
    [pscustomobject]@{make = 'Alfa Romeo'; model = 'Giulia'; year = 2023; color = "blue" }
    [pscustomobject]@{make = 'Audi'; model = 'A8'; year = 2019; color = "grey" }
    [pscustomobject]@{make = 'Audio'; model = 'R8'; year = 2020; color = "black" }
)

$LinkSchedule | ForEach-Object {

    Add-AzTableRow `
        -table $table.CloudTable `
        -partitionKey $tableName `
        -rowKey ($LinkSchedule.IndexOf($_)) -property @{"make" = $_.make; "model" = $_.model; "year" = $_.year; "color" = $_.color } `
        -UpdateExisting    

        $LinkSchedule.IndexOf($_)
}

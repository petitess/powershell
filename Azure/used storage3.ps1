# Static Values for Resource Group and Storage Account Names
$resourceGroup = "NL-BAC"
$storageAccountName = "backupstorage"

# Get a reference to the storage account and the context
$storageAccount = Get-AzStorageAccount `
-ResourceGroupName $resourceGroup `
-Name $storageAccountName
$ctx = $storageAccount.Context

# Get All Blob Containers
$AllContainers = Get-AzStorageContainer -Context $ctx
$AllContainersCount = $AllContainers.Count
Write-Host "We found '$($AllContainersCount)' containers. Processing size for each one"

# Zero counters
$TotalLength = 0
$TotalContainers = 0

# Loop to go over each container and calculate size
Foreach ($Container in $AllContainers){
$TotalContainers = $TotalContainers + 1
Write-Host "Processing Container '$($TotalContainers)'/'$($AllContainersCount)'"
$listOfBLobs = Get-AzStorageBlob -Container $Container.Name -Context $ctx

# zero out our total
$length = 0

# this loops through the list of blobs and retrieves the length for each blob and adds it to the total
$listOfBlobs | ForEach-Object {$length = $length + $_.Length}
$TotalLength = $TotalLength + $length
}
# end container loop

#Convert length to GB
$TotalLengthGB = $TotalLength /1024 /1024 /1024

# Result output
$date = Get-Date
Write-Host "Total size of $storageAccountName = " $TotallengthGB "GB" $date

echo "Total size of $storageAccountName = " $TotallengthGB "GB" $date | out-file "C:\Users\Karol\Desktop\storage_$(get-date -f yyyy-MM-dd-HH-mm).txt"

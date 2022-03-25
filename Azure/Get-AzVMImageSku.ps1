#Publisher ID = Publisher
#Product ID = Offer
#Plan ID = Skus

Get-AzVMImageSku -Location 'swedencentral' -PublisherName microsoftsqlserver -Offer sql2019-ws2022 | select skus, offer, publishername
Get-AzVMImageSku -Location 'North Europe' -PublisherName MicrosoftWindowsServer -Offer WindowsServer | select skus, offer, publishername
Get-AzVMImageSku -Location "swedencentral" -PublisherName "canonical" -Offer 0001-com-ubuntu-server-focal

Get-AzVMImagePublisher -Location "swedencentral"

Get-AzMarketplaceterms -Publisher MicrosoftWindowsServer -Product WindowsServer -name 2019-datacenter


#Finding the SKUs of Azure VMs images
$location = Get-AzLocation | select displayname | Out-GridView -PassThru -Title "Choose a location"
$publisher = Get-AzVMImagePublisher -Location $location.DisplayName | Out-GridView -PassThru -Title "Choose a publisher"
$offer = Get-AzVMImageOffer -Location $location.DisplayName -PublisherName $publisher.PublisherName | Out-GridView -PassThru -Title "Choose an offer"
$title = "VM SKUs for {0} {1} {2}" -f $location.DisplayName, $publisher.PublisherName, $offer.Offer
$sku = Get-AzVMImageSku -Location $location.DisplayName -PublisherName $publisher.PublisherName -Offer $offer.Offer | select SKUS | Out-GridView -Title $title -PassThru
$imageReference = @{ publisher = $publisher.PublisherName; offer = $offer.Offer; sku = $sku.Skus; version = "latest" }
$imageReference | ConvertTo-Json -Depth 4
#########################

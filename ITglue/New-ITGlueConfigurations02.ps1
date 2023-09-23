#Install-Module -Name ITGlueAPI
#Import-Module -Name ITGlueAPI

$apiKey = Get-AzKeyVaultSecret -VaultName "kv-infra-prod-01" -Name "ItGlueApiKey" -AsPlainText
Set-ITGlueAPIKey -Api_Key $apiKey
Set-ITGlueBaseURI "https://api.eu.itglue.com"

$organizationId = Get-AzKeyVaultSecret -VaultName "kv-infra-prod-01" -Name "ItGlueOrgId" -AsPlainText
$CET = (Get-date).AddHours(2)
$synk = "Last_Synk: $(Get-Date $CET -Format "MM/dd/yyyy HH:mm")"
$SubId = (Get-AzSubscription -SubscriptionName 'sub-prod-01').Id
$VMs = Get-AzVM -Status | Where-Object { $_.Name -match 'vmvdaprod04' }

$VMs | ForEach-Object {
    $Nic = Get-AzNetworkInterface -Name "$($_.Name)*" 
    $OsId = if ($_.StorageProfile.ImageReference.Sku -match '2022-datacenter') { '223' } else { if ($_.Name -match 'vmvda') { '205' } else { if ($_.StorageProfile.ImageReference.Publisher -match 'canonical' -or $_.StorageProfile.ImageReference.Publisher -match 'citrix') { '61' } else { '' } } }
    $info = ($_.Tags | ConvertTo-Json).Replace('"', '').Replace(',', '')
    $statusId = if ($_.PowerState -match "VM running") { '2313080436654286' } else { if ($_.PowerState -match "VM deallocated") { '2313091367305427' } else { 'Unknown' } }
    $Configuration = 
    @{
        type       = 'configurations'
        attributes = @{          
            'name'                    = $_.Name                        
            'primary-ip'              = $Nic[0].IpConfigurations.PrivateIpAddress    
            'operating-system-notes'  = "Tags: $info"
            'configuration-type-id'   = if ($_.Name -match 'vmsql') { '1868598523379873' } else { '2313050272104661' }
            'operating-system-id'     = $OsId
            'hostname'                = $_.Name    
            'default-gateway'         = 'vmdcprod01/02'
            'serial-number'           = $_.HardwareProfile.VmSize   
            'asset-tag'               = $synk
            'position'                = 'swedencentral'
            'notes'                   = "Subscription: $($SubId)`nResourcegroup: $($_.ResourceGroupName)"
            'installed-by'            = ''
            'purchased-by'            = ''
            'configuration-status-id' = $statusId
        }
    }

    $configs = (Get-ITGlueConfigurations -filter_name $_.Name -page_size 1000 -organization_id $organizationId).data 

    if ($configs) {
        Set-ITGlueConfigurations -id $configs[0].id -data $Configuration 
        Write-Output "Updated: $( $_.Name) : $($configs[0].id)"
    }
    else {
        $newConfig = New-ITGlueConfigurations -organization_id $organizationId -data $Configuration 
        Write-Output "Created: $( $_.Name) : $($newConfig.data.id)"
    }
}
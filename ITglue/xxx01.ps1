#https://www.powershellgallery.com/packages/ITGlueAPI/2.2.0
#https://learn.microsoft.com/en-us/connectors/itglue/
#https://github.com/itglue/powershellwrapper
Install-Module -Name ITGlueAPI

Add-ITGlueAPIKey -Api_Key 

Set-ITGlueBaseURI "https://api.eu.itglue.com"

$((Get-Date -Format "MM/dd/yyyy HH:mm").AddHours(2) )

$CET = (Get-date).AddHours(2)
Get-Date $CET -Format "MM/dd/yyyy HH:mm"

(Get-AzSubscription -SubscriptionName 'sub-prod-01').Id
Set-ITGlueConfigurations -id "3142842920435888" -data $Data 
$Configs = ((Get-ITGlueConfigurations -page_size 1000 -page_number 1).data).attributes

$data = (Get-ITGlueConfigurations -organization_id "1338100082688000" -page_number 1).data | Out-File config.json

((Get-ITGlueConfigurations -page_size 1000 -organization_id "1992109310000000").data).attributes | Out-File config.json
((Get-ITGlueConfigurations -page_size 1000 -organization_id "1992109310000000").data).attributes | ConvertTo-Json 

((Get-ITGlueExpirations).data).attributes

Get-ITGlueConfigurationStatuses

(((Get-ITGluePasswords).data).attributes).'resource-name'

(Get-ITGlueConfigurations -id "3142842920435000" -organization_id "1992109310000000").data  | ConvertFrom-Json -AsHashtable
(Get-ITGlueConfigurations -id "3142842327285000" -organization_id "1992109310000000").data  | ConvertFrom-Json -AsHashtable
((Get-ITGlueConfigurations -id "3142842920435000" -organization_id "1992109310000000").data).relationships  | ConvertFrom-Json -AsHashtable


#RUNNING: 2313080436654286
#DEALLOCATED: 2313091367305427

$Data | ConvertFrom-Json -AsHashtable

Set-ITGlueConfigurations -id "3365081132089000" -data $Configuration 

New-ITGlueConfigurations -organization_id '1992109310000000' -data $Configuration 

$Configuration = 
@{
    type       = 'configurations'
    attributes = @{ 
        'my-glue'                   = 'False'              
        'name'                      = 'vmvdaprod03'            
        'restricted'                = 'False'               
        'primary-ip'                = '10.10.10.1'       
        'operating-system-notes'    = 'Standard_E4bds_v5'
        'configuration-type-id'     = '2313050272104661'
        'configuration-type-name'   = 'Vm (Synced)'
        'configuration-type-kind'   = 'Vm'
        'operating-system-id'       = '205'
        'operating-system-name'     = 'Windows Server 2019 Datacenter'
        'psa-integration'           = ''   
        'hostname'                  = ''    
        'mac-address'               = ''
        'default-gateway'           = ''
        'serial-number'             = ''    
        'asset-tag'                 = ''
        'position'                  = ''
        'installed-by'              = ''
        'purchased-by'              = ''
        'notes'                     = null          
        'warranty-expires-at'       = ''
        'installed-at'              = ''
        'purchased-at'              = ''
        'created-at'                = ''
        'updated-at'                = ''
        'organization-short-name'   = ''
        'configuration-status-id'   = ''
        'configuration-status-name' = ''
        'manufacturer-id'           = ''
        'manufacturer-name'         = ''
        'model-id'                  = ''
        'location-id'               = ''
        'location-name'             = ''
        'contact-id'                = ''
        'model-name'                = ''
        'contact-name'              = ''
    }
}

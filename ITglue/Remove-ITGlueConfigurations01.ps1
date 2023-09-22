#Install-Module -Name ITGlueAPI

Add-ITGlueAPIKey -Api_Key "ITG.xxxxxxxxxxxx4a693.SlD0QJjZImmbCtHJPver3banmIaxxxxxxxxxx"
Set-ITGlueBaseURI "https://api.eu.itglue.com"

$configs = (Get-ITGlueConfigurations -page_size 1000 -organization_id "00000311360000").data

$configs | ForEach-Object {

    $vmName = (($_).attributes).name 
    if ($vmName -match 'vmvdaprod03') {
        Write-Output  "$( $vmName) : $($_.Id)"
        Remove-ITGlueConfigurations -id $_.Id
    }
}
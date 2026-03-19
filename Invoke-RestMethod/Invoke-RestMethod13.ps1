#Install-Module -Name SqlServer -Scope AllUsers
$response = Invoke-WebRequest -Uri 'http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https%3A%2F%2Fvault.azure.net%2F' -Headers @{Metadata = "true" } -UseBasicParsing
$content = $response.Content | ConvertFrom-Json
$access_token = $content.access_token
$access_token.Length | Out-File "C:\A5\Scripts\ITGlueAssetsLogs.txt" -Force
Write-Host $access_token.Length
$headers = @{
    "Authorization" = "Bearer $access_token"
    "Content-type"  = "application/json"
}

$apiKey = (Invoke-RestMethod `
        -Uri "https://kv-infra-test-01.vault.azure.net/secrets/01ItGlueApiKey?api-version=2025-07-01" `
        -Method GET -Headers $headers).value
$apiKey.Length | Out-File "C:\A5\Scripts\ITGlueAssetsLogs.txt" -Append -Force
Write-Host $access_token.Length
$itGlueHeaders = @{
    "x-api-key"    = $apiKey
    "Content-Type" = "application/vnd.api+json"
}

$Server = Get-ADComputer -Filter { OperatingSystem -like "*Server*" -and Name -like "vmsqlprod06" } `
    -Properties Name, OperatingSystem, OperatingSystemVersion, DistinguishedName
$Server | Out-File "C:\A5\Scripts\ITGlueAssetsLogs.txt" -Append -Force
Write-Host $Server.Name
$ServerName = $Server.Name
$ServerOS = $Server.OperatingSystem

#Get existing configurations
$itGlueConfiguration = (Invoke-RestMethod -Method GET -Uri `
        "https://api.eu.itglue.com/organizations/1234567890/relationships/configurations?filter[name]=$ServerName" `
        -Headers $itGlueHeaders).data
#Get existing instance
$itGlueInstance = (Invoke-RestMethod -Method GET -Uri `
        "https://api.eu.itglue.com/flexible_assets?filter[flexible_asset_type_id]=1797995449467097&filter[organization-id]=1234567890&filter[name]=$ServerName" `
        -Headers $itGlueHeaders).data
#Get existing application, saved as environment variable locally
$itGlueApplicationsNames = $null
switch ($ServerName) {
    'vmsqltest01' { $itGlueApplicationsNames = 'Abcd CRM (Caesar CRM)' }
    'vmsqltest02' { $itGlueApplicationsNames = 'Insikt,IFRS9' }
    # 'vmsqltest03' { $itGlueApplicationsNames = 'cLA' }
    # 'vmsqltest04' { $itGlueApplicationsNames = 'cLO' }
    'vmsqltest05' { $itGlueApplicationsNames = 'Visma Control (Autopay)' }
    'vmsqltest08' { $itGlueApplicationsNames = 'cLO' }
    'vmsqltest09' { $itGlueApplicationsNames = 'cLA,CLVR (ARC (obestånd))' }
    'vmsqltest10' { $itGlueApplicationsNames = 'cLA' }
    'vmsqlprod01' { $itGlueApplicationsNames = 'Abcd CRM (Caesar CRM)' }
    'vmsqlprod02' { $itGlueApplicationsNames = 'Insikt,IFRS9' }
    # 'vmsqlprod03' { $itGlueApplicationsNames = 'cLA' }
    # 'vmsqlprod04' { $itGlueApplicationsNames = 'cLO' }
    'vmsqlprod05' { $itGlueApplicationsNames = 'Visma Control (Autopay)' }
    'vmsqlprod08' { $itGlueApplicationsNames = 'cLO' }
    'vmsqlprod09' { $itGlueApplicationsNames = 'cLA,CLVR (ARC (obestånd))' }
    'vmsqlprod10' { $itGlueApplicationsNames = 'cLA' }
    Default {}
}

if ($null -ne $itGlueApplicationsNames) {
    $itGlueApplications = (Invoke-RestMethod -Method GET -Uri `
            "https://api.eu.itglue.com/flexible_assets?filter[flexible_asset_type_id]=1367449776324812&filter[organization-id]=1234567890&filter[name]=$itGlueApplicationsNames" `
            -Headers $itGlueHeaders).data.id
}

$itGlueInstancesId = "1797995449467097"
$itGlueBody = @{
    data = @{
        type       = "flexible-assets"
        attributes = @{
            "organization-id"        = 1234567890
            "flexible-asset-type-id" = $itGlueInstancesId
            name                     = $ServerName
            archived                 = $false
            traits                   = @{
                instance      = $ServerName
                "port-s"      = "1433"
                collation     = "SQL_Latin1_General_CP1_CI_AS"
                configuration = "<div>Updated using script: $(Get-Date -Format "yyyy-MM-dd-hh:mm")</div> <div>OS: $($ServerOS)</div>"
                version       = "2019"
                server        = $itGlueConfiguration.id
                application   = $itGlueApplications
            }
        }
    }
} | ConvertTo-Json -Depth 100
$itGlueBody | Out-File "C:\A5\Scripts\ITGlueAssetsLogs.txt" -Append -Force
if (0 -ne $itGlueInstance.Count) {
    Write-Output "Updating $($itGlueInstance.attributes.traits.instance)"
    $callInstance = (Invoke-RestMethod -Method Patch -Uri "https://api.eu.itglue.com/flexible_assets/$($itGlueInstance.id)" -Headers $itGlueHeaders -Body $itGlueBody)
}
else {
    Write-Output "Adding $ServerName"
    $callInstance = (Invoke-RestMethod -Method Post -Uri "https://api.eu.itglue.com/flexible_assets" -Headers $itGlueHeaders -Body $itGlueBody)
}


$exclude = @(
    'e'
    'master'
    'model'
    'msdb'
    'tempdb'
    'DBAMaint'
    'DBAMaintMaster'
    'ReportServer'
    'ReportServerTempDB'
    'ReportDatabase2'
    'ReportDatabase_250518'
    'IM'
    'IM_TEST'
    'ARC'
    'ARC_TEST'
)
$serverDatabases = Get-SqlDatabase -ServerInstance $ServerName | Where-Object { $_.Name -notin $exclude -and $_.Name -notmatch 'temp' }
#$serverDatabases = Get-SqlDatabase -ServerInstance $ServerName | Where-Object {$_.Name -notin $exclude -and $_.Name -notmatch 'temp' } | Select-Object Name, Collation, @{Name="FileGroups"; Expression = {$_.LogFiles[0].FileName}} , @{Name="LogFiles"; Expression = {$_.LogFiles[0].FileName}}
#New-Item -Path "\\vmdctest01\SYSVOL\ad.abcd.se\scripts" -Name "tempinfo" -Force -ItemType Directory
#$serverDatabases | ConvertTo-Json | Set-Content -Path "\\vmdctest01\SYSVOL\ad.abcd.se\scripts\tempinfo\$env:COMPUTERNAME.json" -Force
#$serverDatabases = Get-Content "\\vmdctest01\SYSVOL\ad.abcd.se\scripts\tempinfo\$ServerName.json" | ConvertFrom-Json
#$serverDatabases = Get-Content "\\$ServerName\c$\Temp\$ServerName.json" | ConvertFrom-Json

$serverDatabases | ForEach-Object {
    
    if ($ServerName -ne 'vmsqlprod06') {
        $fileDb = ($_.FileGroups | ForEach-Object { $_.Files | Select-Object Name, FileName, Size })[0].FileName
        $fileLog = ($_.LogFiles | Select-Object Name, FileName, Size)[0].FileName
    }

    #Write-Output $_
    #Write-Output $_.Collation
    
    $itGlueDatabasesId = "1888335609036989"
    $dbName = $_.Name
    $itGlueDatabase = (Invoke-RestMethod -Method GET -Uri `
            "https://api.eu.itglue.com/flexible_assets?filter[flexible_asset_type_id]=$itGlueDatabasesId&filter[name]=$dbName" -Headers $itGlueHeaders).data
    $itGlueApplication = $null
    $itGlueDatabase.Count

    switch ($dbName) {
        'Caesar_Conf' { $itGlueApplication = 'Abcd CRM (Caesar CRM)' }
        'Caesar' { $itGlueApplication = 'Abcd CRM (Caesar CRM)' }
        'Caesar_TEST' { $itGlueApplication = 'Abcd CRM (Caesar CRM)' }
        'Caesar_TEST_anonym' { $itGlueApplication = 'Abcd CRM (Caesar CRM)' }
        'IFRS_Audit_Test' { $itGlueApplication = 'Abcd CRM (Caesar CRM)' }
        'IFRS_Audit_Prod' { $itGlueApplication = 'Abcd CRM (Caesar CRM)' }
        'IFRS_Prod' { $itGlueApplication = 'Abcd CRM (Caesar CRM)' }
        'IFRS_Test' { $itGlueApplication = 'IFRS9' }
        'INSIKT_DATALAGER' { $itGlueApplication = 'Insikt' }
        'INSIKT_SA' { $itGlueApplication = 'Insikt' }
        'INSIKT_SYS' { $itGlueApplication = 'Insikt' }
        'cLA' { $itGlueApplication = 'cLA' }
        'cLA_Scramble' { $itGlueApplication = 'cLA' }
        'cLAAudit_Scramble' { $itGlueApplication = 'cLA' }
        'cLAAudit' { $itGlueApplication = 'cLA' }
        'cLAAuthorization' { $itGlueApplication = 'cLA' }
        'cLAConfiguration' { $itGlueApplication = 'cLA' }
        'cLAHealthDW' { $itGlueApplication = 'cLA' }
        'cLAReport' { $itGlueApplication = 'cLA' }
        'cLASession' { $itGlueApplication = 'cLA' }
        'cLAStageArea' { $itGlueApplication = 'cLA' }
        'cLASupport' { $itGlueApplication = 'cLA' }
        'cLAStageArea_250518' { $itGlueApplication = 'cLA' }
        'cLA_before' { $itGlueApplication = 'cLA' }
        'EFS' { $itGlueApplication = 'cLA' }
        'cLALog' { $itGlueApplication = 'cLA' }
        'cLASystem' { $itGlueApplication = 'cLA' }
        'K2' { $itGlueApplication = 'cLO' }
        'ApplyPersistenceDatabase' { $itGlueApplication = 'cLO' }
        'ApplyWorkflowDatabase' { $itGlueApplication = 'cLO' }
        'AuditDatabase' { $itGlueApplication = 'cLO' }
        'CBRLogsABCD' { $itGlueApplication = 'cLO' }
        'CBRLogsSimple' { $itGlueApplication = 'cLO' }
        'ConfigurationDatabase' { $itGlueApplication = 'cLO' }
        'CreditReportDatabase' { $itGlueApplication = 'cLO' }
        'DashboardDatabase' { $itGlueApplication = 'cLO' }
        'DocumentDatabase' { $itGlueApplication = 'cLO' }
        'ScrambledConfigurationDatabase' { $itGlueApplication = 'cLO' }
        'SearchDatabase' { $itGlueApplication = 'cLO' }
        'SecurityObjectInformationDatabase' { $itGlueApplication = 'cLO' }
        'SecurityValuationDatabase' { $itGlueApplication = 'cLO' }
        'AL_XOR' { $itGlueApplication = 'Visma Control (Autopay)' }
        'ABCD_XOR' { $itGlueApplication = 'Visma Control (Autopay)' }
        'AL_XOR_ANONYM_TEST' { $itGlueApplication = 'Visma Control (Autopay)' }
        'AL_XOR_HIST_2014' { $itGlueApplication = 'Visma Control (Autopay)' }
        'ABCD_XOR_HIST_2014' { $itGlueApplication = 'Visma Control (Autopay)' }
        'AL_XOR_TEST' { $itGlueApplication = 'Visma Control (Autopay)' }
        'ABCD_XOR_ANONYM_TEST' { $itGlueApplication = 'Visma Control (Autopay)' }
        'ABCD_XOR_TEST' { $itGlueApplication = 'Visma Control (Autopay)' }
        'VismaControlServer_TEST' { $itGlueApplication = 'Visma Control (Autopay)' }
        'VismaControlServer_TEST15' { $itGlueApplication = 'Visma Control (Autopay)' }
        'VismaControlServer' { $itGlueApplication = 'Visma Control (Autopay)' }
        'CLVR_Test' { $itGlueApplication = 'CLVR (ARC (obestånd))' }
        'CLVR' { $itGlueApplication = 'CLVR (ARC (obestånd))' }
        Default {}
    }
    Write-Output $itGlueApplication
    if ($null -ne $itGlueApplication) {
        $itGlueApplications = (Invoke-RestMethod -Method GET -Uri `
                "https://api.eu.itglue.com/flexible_assets?filter[flexible_asset_type_id]=1367449776324812&filter[organization-id]=1234567890&filter[name]=$itGlueApplication" `
                -Headers $itGlueHeaders).data.id
    }
    else {
        $itGlueApplications = $null
    }
    $itGlueBody = @{
        data = @{
            type       = "flexible-assets"
            attributes = @{
                "organization-id"        = 1234567890
                "flexible-asset-type-id" = $itGlueDatabasesId
                name                     = "$dbName"
                archived                 = $false
                traits                   = @{
                    database              = "$dbName"
                    collation             = $_.Collation
                    owner                 = "sa"
                    description           = "<div>Updated using script: $(Get-Date -Format "yyyy-MM-dd-hh:mm")</div>"
                    instance              = $callInstance.data.id
                    application           = $itGlueApplications
                    "recovery-model"      = "SIMPLE"
                    "compatibility-level" = "150 (SQL Server 2019)"
                    "data-file-path"      = $fileDb
                    "log-file-path"       = $fileLog
                }
            }
        }
    } | ConvertTo-Json -Depth 100

    if (0 -ne $itGlueDatabase.Count) {
        Write-Output "Updating $dbName"
        (Invoke-RestMethod -Method Patch -Uri "https://api.eu.itglue.com/flexible_assets/$($itGlueDatabase.id)" -Headers $itGlueHeaders -Body $itGlueBody)
    }
    else {
        Write-Output "Adding $dbName"
        (Invoke-RestMethod -Method Post -Uri "https://api.eu.itglue.com/flexible_assets" -Headers $itGlueHeaders -Body $itGlueBody)
    }
}

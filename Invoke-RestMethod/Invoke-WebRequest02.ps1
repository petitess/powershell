###Opsgenie info
$ApiOpsgenie = Get-AzKeyVaultSecret -VaultName "kv-xxx-prod-01" -Name "ApiKeyOpsgenie" -AsPlainText
$ScheduleName = 'Beredskap_schedule'
$UrlOpsgenie = "https://api.opsgenie.com/v2/schedules/$ScheduleName/next-on-calls?scheduleIdentifierType=name"

$HeadersOpsgenie = @{
    "Authorization" = "GenieKey $ApiOpsgenie"
    "Content-type"  = "application/json"
}

$NextOnCall = (Invoke-RestMethod -Method GET -URI $UrlOpsgenie -Headers $HeadersOpsgenie).data.exactNextOnCallRecipients.name
Write-Output $($NextOnCall + " har beredskap")

###Info dstny.se
$ApiKey = Get-AzKeyVaultSecret -VaultName "kv-xxx-prod-01" -Name "ApiKeyDstny" -AsPlainText
$ApiKeyUserId = 'x105'#Karol
$Domain = 'xxx.se'
$Group = '82441'
$URL = "https://bc.dstny.se/api/user/acd-attendant-group/v1/$Domain/$ApiKeyUserId"
$headers = @{
    "Authorization" = "Bearer $ApiKey"
    "Content-type"  = "application/json"
    "Accept"        = "application/json"
}

#Get all users for ADC-group
$DstnyUsers = (Invoke-RestMethod -Method GET -URI $URL -Headers $headers).groups.agents.id

#Logout all users
$DstnyUsers | ForEach-Object {
    $URL = "https://bc.dstny.se/api/user/acd-attendant-group/$Domain/$ApiKeyUserId/$Group/$Domain/agents/$($_)?action=logout"
    Invoke-RestMethod -Method POST -URI $URL -Headers $headers
    Write-Output $($_ + " utloggad från dsnty")
}

switch ($NextOnCall) {
    'x.sek@xxx.se' {
        $DstnyUserId = 'x105@xxx.se'
    }
    'x.ljungstrom@xxx.se' {
        $DstnyUserId = 'x106@xxx.se'
    }
    'x.sjoblom@xxx.se' {
        $DstnyUserId = 'x117@xxx.se'
    }
    'x.bilger@xxx.se' {
        $DstnyUserId = 'x115@xxx.se'
    }
    'x.torntorp@xxx.se' {
        $DstnyUserId = 'x121@xxx.se'
    }
    'x.holm@xxx.se' {
        $DstnyUserId = 'x52@xxx.se'
    }
}

$URL = "https://bc.dstny.se/api/user/acd-attendant-group/$Domain/$ApiKeyUserId/$Group/$Domain/agents/$($DstnyUserId)?action=login"
$IR = Invoke-WebRequest -Method POST -Uri $URL -Headers $headers

Write-Output $("Status code: " + $IR.StatusCode)

If($IR.StatusCode -eq "200") {
    Write-Output $($NextOnCall + " inloggad på dsnty")

}else {
    Write-Output $("Status code: " + $($IR.StatusCode) + ". Check the script")
}

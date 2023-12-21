###Opsgenie info
$ApiOpsgenie = 'XXXX'
$ScheduleName = 'Beredskap_schedule'
$UrlOpsgenie = "https://api.opsgenie.com/v2/schedules/$ScheduleName/next-on-calls?scheduleIdentifierType=name"

$HeadersOpsgenie = @{
    "Authorization" = "GenieKey $ApiOpsgenie"
    "Content-type"  = "application/json"
}

$NextOnCall = (Invoke-RestMethod -Method GET -URI $UrlOpsgenie -Headers $HeadersOpsgenie).data.exactNextOnCallRecipients.name
Write-Output $($NextOnCall + " har beredskap")

###Info dstny.se
$ApiKey = 'XXXXX'
$ApiKeyUserId = 'a8105'
$Domain = 'xxx.com'
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
    'user1@xx.com' {
        $DstnyUserId = 'a8105@xxx.com'
        $URL = "https://bc.dstny.se/api/user/acd-attendant-group/$Domain/$ApiKeyUserId/$Group/$Domain/agents/$($DstnyUserId)?action=login"
        Invoke-RestMethod -Method POST -URI $URL -Headers $headers
        Write-Output $($NextOnCall + " inloggad på dsnty")
    }
    'user2@xx.com' {
        $DstnyUserId = 'a8106@xxx.com'
        $URL = "https://bc.dstny.se/api/user/acd-attendant-group/$Domain/$ApiKeyUserId/$Group/$Domain/agents/$($DstnyUserId)?action=login"
        Invoke-RestMethod -Method POST -URI $URL -Headers $headers
        Write-Output $($NextOnCall + " inloggad på dsnty")
    }
    'suser3@xx.com' {
        $DstnyUserId = 'a8117@xxx.com'
        $URL = "https://bc.dstny.se/api/user/acd-attendant-group/$Domain/$ApiKeyUserId/$Group/$Domain/agents/$($DstnyUserId)?action=login"
        Invoke-RestMethod -Method POST -URI $URL -Headers $headers
        Write-Output $($NextOnCall + " inloggad på dsnty")
    }
    'user4@xx.com' {
        $DstnyUserId = 'a8115@xxx.com'
        $URL = "https://bc.dstny.se/api/user/acd-attendant-group/$Domain/$ApiKeyUserId/$Group/$Domain/agents/$($DstnyUserId)?action=login"
        Invoke-RestMethod -Method POST -URI $URL -Headers $headers
        Write-Output $($NextOnCall + " inloggad på dsnty")
    }
    'user5@xx.com' {
        $DstnyUserId = 'a8121@xxx.com'
        $URL = "https://bc.dstny.se/api/user/acd-attendant-group/$Domain/$ApiKeyUserId/$Group/$Domain/agents/$($DstnyUserId)?action=login"
        Invoke-RestMethod -Method POST -URI $URL -Headers $headers
        Write-Output $($NextOnCall + " inloggad på dsnty")
    }
    'user6@xx.com' {
        $DstnyUserId = 'a0752@xxx.com'
        $URL = "https://bc.dstny.se/api/user/acd-attendant-group/$Domain/$ApiKeyUserId/$Group/$Domain/agents/$($DstnyUserId)?action=login"
        Invoke-RestMethod -Method POST -URI $URL -Headers $headers
        Write-Output $($NextOnCall + " inloggad på dsnty")
    }
}

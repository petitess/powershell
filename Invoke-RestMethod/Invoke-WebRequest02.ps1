Connect-AzAccount -Identity

###Opsgenie info
$ApiOpsgenie = $Env:API_KEY_OPSGENIE
$ScheduleName = 'Beredskap_schedule'
$HeadersOpsgenie = @{
    "Authorization" = "GenieKey $ApiOpsgenie"
    "Content-type"  = "application/json"
}

$UrlOpsgenie = "https://api.opsgenie.com/v2/schedules/$ScheduleName/on-calls?scheduleIdentifierType=name&flat=true&flat=true&flat=true&flat=true"
try {
    $OnCallUsers = (Invoke-RestMethod -Method GET -URI $UrlOpsgenie -Headers $HeadersOpsgenie).data.onCallRecipients
}
catch {
    throw "{0} {1}" -f $_.Exception.Response.StatusCode.value__, $_.Exception.Response.ReasonPhrase
}
$OnCallUsers | ForEach-Object {
    Write-Output $($_ + " har beredskap")
}

###Info dstny.se
$ApiKey = $Env:API_KEY_DSTNY
$ApiKeyUserId = 'a1111'
$Domain = 'xxx.se'
$Group = '11111'
$headers = @{
    "Authorization" = "Bearer $ApiKey"
    "Content-type"  = "application/json"
    "Accept"        = "application/json"
}
try {
    $Contacts = Invoke-RestMethod -Method GET -URI "https://bc.dstny.se/api/contacts/list/$Domain/$ApiKeyUserId" -Headers $headers
}
catch {
    throw "{0} {1}" -f $_.Exception.Response.StatusCode.value__, $_.Exception.Response.ReasonPhrase
}

#Get all users for ADC-group
try {
    $DstnyUsers = (Invoke-RestMethod -Method GET -URI "https://bc.dstny.se/api/user/acd-attendant-group/v1/$Domain/$ApiKeyUserId" -Headers $headers).groups.agents.id
}
catch {
    throw "{0} {1}" -f $_.Exception.Response.StatusCode.value__, $_.Exception.Response.ReasonPhrase
}

#Logout all users
$DstnyUsers | ForEach-Object {
    $URL = "https://bc.dstny.se/api/user/acd-attendant-group/$Domain/$ApiKeyUserId/$Group/$Domain/agents/$($_)?action=logout"
    try {
        Invoke-RestMethod -Method POST -URI $URL -Headers $headers
    }
    catch {
        throw "{0} {1}" -f $_.Exception.Response.StatusCode.value__, $_.Exception.Response.ReasonPhrase
    }
    Write-Output $($_ + " utloggad från dsnty")
}

if ($OnCallUsers.Length -eq 0) {
    Write-Output "Ingen har beredskap. Skippar API anrop."
}
else {

    $OnCallUsers | ForEach-Object {
        $DstnyUserId = ($Contacts.contact | Where-Object email -eq $_ ).id
        $URL = "https://bc.dstny.se/api/user/acd-attendant-group/$Domain/$ApiKeyUserId/$Group/$Domain/agents/$($DstnyUserId)?action=login"
        try {
            Invoke-RestMethod -Method POST -Uri $URL -Headers $headers
        }
        catch {
            throw "{0} {1}" -f $_.Exception.Response.StatusCode.value__, $_.Exception.Response.ReasonPhrase
        }
        Write-Output $($_ + " inloggad på dsnty")
    }
}

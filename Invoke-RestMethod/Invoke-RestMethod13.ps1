###GET Who is On Call Operations
$API = 'xxx-3118-4ceb-90b2-xxx'
$ScheduleName = 'Operations_schedule'
$URL = "https://api.opsgenie.com/v2/schedules/$ScheduleName/on-calls?scheduleIdentifierType=name&flat=true"

$headers = @{
    "Authorization" = "GenieKey $API"
    "Content-type"  = "application/json"
  }

Invoke-RestMethod -Method GET -URI $URL -Headers $headers
(Invoke-RestMethod -Method GET -URI $URL -Headers $headers).data.onCallRecipients
###GET Who is On Call Beredskap
$ApiOpsgenie = 'xxx8b48-463e-a020-xxxx'
$ScheduleName = 'Beredskap_schedule'
$HeadersOpsgenie = @{
    "Authorization" = "GenieKey $ApiOpsgenie"
    "Content-type"  = "application/json"
}

$UrlOpsgenie = "https://api.opsgenie.com/v2/schedules/$ScheduleName/on-calls?scheduleIdentifierType=name&flat=true&date=2024-01-25T17:00:00%2B01:00"
(Invoke-RestMethod -Method GET -URI $UrlOpsgenie -Headers $HeadersOpsgenie).data.onCallRecipients

###GET Who is Next On Call Beredskap
$API = 'xxx-3118-4ceb-90b2-xxx'
$ScheduleName = 'Beredskap_schedule'
$URL = "https://api.opsgenie.com/v2/schedules/$ScheduleName/next-on-calls?scheduleIdentifierType=name"

$headers = @{
    "Authorization" = "GenieKey $API"
    "Content-type"  = "application/json"
  }

Invoke-RestMethod -Method GET -URI $URL -Headers $headers
(Invoke-RestMethod -Method GET -URI $URL -Headers $headers).data.exactNextOnCallRecipients.name
###
###GET user
$ApiOpsgenie = 'xxxx'
$user = "karol.sek@xx.se"
$HeadersOpsgenie = @{
    "Authorization" = "GenieKey $ApiOpsgenie"
    "Content-type"  = "application/json"
}

$UrlOpsgenie = "https://api.opsgenie.com/v2/users/$user"
$I = (Invoke-RestMethod -Method GET -URI $UrlOpsgenie -Headers $HeadersOpsgenie)
$I.data.id

###PATCH change permissions
$ApiOpsgenie = 'xxxxx'
$userId = "xxxx-67c4-4ac4-9a2f-xxxx"
$HeadersOpsgenie = @{
    "Authorization" = "GenieKey $ApiOpsgenie"
    "Content-type"  = "application/json"
}
$body = @{
    "role" = @{
        "name" = "admin"
    }
}
$UrlOpsgenie = "https://api.opsgenie.com/v2/users/$userId"
$I = (Invoke-RestMethod -Method PATCH -URI $UrlOpsgenie -Headers $HeadersOpsgenie -Body $($body | ConvertTo-Json))

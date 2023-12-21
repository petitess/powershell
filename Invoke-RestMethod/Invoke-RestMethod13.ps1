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
$API = 'xxx-3118-4ceb-90b2-xxx'
$ScheduleName = 'Beredskap_schedule'
$URL = "https://api.opsgenie.com/v2/schedules/$ScheduleName/next-on-calls?scheduleIdentifierType=name"

$headers = @{
    "Authorization" = "GenieKey $API"
    "Content-type"  = "application/json"
  }

Invoke-RestMethod -Method GET -URI $URL -Headers $headers
(Invoke-RestMethod -Method GET -URI $URL -Headers $headers).data.exactNextOnCallRecipients.name

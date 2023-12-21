###List groups
$APID = 'XXXXX'
$Domain = 'b3it.se'
$UserId = 'a8105'
$Group = 'Beredskap'
$URL = "https://bc.dstny.se/api/user/acd-attendant-group/v1/$Domain/$UserId"
$headers = @{
    "Authorization" = "Bearer $APID"
    "Content-type"  = "application/json"
    "Accept"  = "application/json"
  }
Invoke-RestMethod -Method GET -URI $URL -Headers $headers
(Invoke-RestMethod -Method GET -URI $URL -Headers $headers).groups
(Invoke-RestMethod -Method GET -URI $URL -Headers $headers).groups.agents

###Get group
$APID = 'XXXXX'
$Domain = 'b3it.se'
$UserId = 'a8105'
$Group = '82441'
$URL = "https://bc.dstny.se/api/user/acd-attendant-group/v1/$Domain/$UserId/$Group/$Domain"
$headers = @{
    "Authorization" = "Bearer $APID"
    "Content-type"  = "application/json"
    "Accept"  = "application/json"
  }
Invoke-RestMethod -Method GET -URI $URL -Headers $headers

###Log in/Log out
$APID = 'XXXXX'
$Domain = 'b3it.se'
$UserId = 'a8105'
$Group = '82441'
$GroupDomain = 'b3it.se'
$Agent = 'a8105@b3it.se'
$URL = "https://bc.dstny.se/api/user/acd-attendant-group/$Domain/$UserId/$Group/$GroupDomain/agents/$($Agent)?action=login"
$headers = @{
    "Authorization" = "Bearer $APID"
    "Content-type"  = "application/json"
  }
Invoke-RestMethod -Method POST -URI $URL -Headers $headers

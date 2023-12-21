###List groups
$ApiKey = 'XXX'
$ApiKeyUserId = 'a8105'
$Domain = 'xxx.se'
$URL = "https://bc.dstny.se/api/user/acd-attendant-group/v1/$Domain/$ApiKeyUserId"
$headers = @{
    "Authorization" = "Bearer $ApiKey"
    "Content-type"  = "application/json"
    "Accept"  = "application/json"
  }
Invoke-RestMethod -Method GET -URI $URL -Headers $headers
(Invoke-RestMethod -Method GET -URI $URL -Headers $headers).groups
(Invoke-RestMethod -Method GET -URI $URL -Headers $headers).groups.agents

###Get group
$ApiKey = 'XXX'
$ApiKeyUserId = 'a8105'
$Domain = 'xxx.se'
$Group = '82441'
$URL = "https://bc.dstny.se/api/user/acd-attendant-group/v1/$Domain/$ApiKeyUserId/$Group/$Domain"
$headers = @{
    "Authorization" = "Bearer $ApiKey"
    "Content-type"  = "application/json"
    "Accept"  = "application/json"
  }
Invoke-RestMethod -Method GET -URI $URL -Headers $headers

###Log in/Log out
$ApiKey = 'XXX'
$ApiKeyUserId = 'a8105'
$Domain = 'xxx.se'
$Group = '82441'
$GroupDomain = 'xxx.se'
$Agent = 'a8105@xx.se'
$URL = "https://bc.dstny.se/api/user/acd-attendant-group/$Domain/$ApiKeyUserId/$Group/$GroupDomain/agents/$($Agent)?action=logout"
$headers = @{
    "Authorization" = "Bearer $ApiKey"
    "Content-type"  = "application/json"
    "Accept"  = "application/json"
  }
Invoke-RestMethod -Method POST -URI $URL -Headers $headers

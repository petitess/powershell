$Token = az account get-access-token --resource "https://graph.microsoft.com" --query "accessToken" -o tsv
$URL = "https://graph.microsoft.com/v1.0/groups/1c354157-c1cd-4d1e-8a73-d0b70a566ea9/members"
$headers = @{
    "Authorization" = "Bearer $Token"
    "Content-type"  = "application/json"
}
(Invoke-RestMethod -Method GET -URI $URL -Headers $headers).value

#!/usr/bin/env pwsh
#GET jwt token
$client_id = "Iv23licXTSHNzdyxxxxx"
$private_key_path = "C:\Users\K1611553\Downloads\karol-app.2025-03-21.private-key.pem"

$header = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes((ConvertTo-Json -InputObject @{
  alg = "RS256"
  typ = "JWT"
}))).TrimEnd('=').Replace('+', '-').Replace('/', '_');

$payload = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes((ConvertTo-Json -InputObject @{
  iat = [System.DateTimeOffset]::UtcNow.AddSeconds(-10).ToUnixTimeSeconds()
  exp = [System.DateTimeOffset]::UtcNow.AddMinutes(10).ToUnixTimeSeconds()
   iss = $client_id 
}))).TrimEnd('=').Replace('+', '-').Replace('/', '_');

$rsa = [System.Security.Cryptography.RSA]::Create()
$rsa.ImportFromPem((Get-Content $private_key_path -Raw))

$signature = [Convert]::ToBase64String($rsa.SignData([System.Text.Encoding]::UTF8.GetBytes("$header.$payload"), [System.Security.Cryptography.HashAlgorithmName]::SHA256, [System.Security.Cryptography.RSASignaturePadding]::Pkcs1)).TrimEnd('=').Replace('+', '-').Replace('/', '_')
$jwt = "$header.$payload.$signature"
Write-Host $jwt
#GET installation id
$JwtToken = $jwt
$URL = "https://api.github.com/app/installations"
$headers = @{
    "Authorization"        = "Bearer $JwtToken"
    "Accept"               = "application/vnd.github+json"
    "X-GitHub-Api-Version" = "2022-11-28"
}
$Ins = Invoke-RestMethod -Method GET -URI $URL -Headers $headers
# GET github token
# $JwtToken = ""
$Id = $Ins.id
$URL = "https://api.github.com/app/installations/$Id/access_tokens"
$headers = @{
    "Authorization"        = "Bearer $JwtToken"
    "Accept"               = "application/vnd.github+json"
    "X-GitHub-Api-Version" = "2022-11-28"
}

$GhToken = Invoke-RestMethod -Method POST -URI $URL -Headers $headers
$GhToken.token
#GET repos
$Token = $GhToken.token
$URL = "https://api.github.com/orgs/045-SGEC-APPLICATIONS/repos"
$headers = @{
    "Authorization"        = "Bearer $Token"
    "Accept"               = "application/vnd.github+json"
    "X-GitHub-Api-Version" = "2022-11-28"
    "User-Agent"           = "user"
}
$Repos = Invoke-RestMethod -Method GET -URI $URL -Headers $headers
$Repos.name
#GET workflow runs
$Repos.name | ForEach-Object {
    $Repo = $_
    $Token = $GhToken.token
    $URL = "https://api.github.com/repos/045-SGEC-APPLICATIONS/$_/actions/runs"
    $headers = @{
        "Authorization"        = "Bearer $Token"
        "Accept"               = "application/vnd.github+json"
        "X-GitHub-Api-Version" = "2022-11-28"
        "User-Agent"           = "user"
    }
    $Runs = Invoke-RestMethod -Method GET -URI $URL -Headers $headers
    $Runs.workflow_runs | Where-Object { $_.event -eq "schedule" -and $_.conclusion -ne "success" } | Select-Object name, conclusion, created_at, @{Name = "repo"; Expression = {$Repo}} | Sort-Object name -Unique
}




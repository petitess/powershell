$Hostname = hostname
$Domain = ".ad.xxx.se"
$FQDN = $Hostname + $Domain
$Date = Get-Date -format "dd/MMM/yyyy HH:mm:ss"

$Cert = Get-ChildItem Cert:\LocalMachine\My -recurse | where-object { $_.Subject -match "CN=$FQDN" }
$ExpiredCert = Get-ChildItem Cert:\LocalMachine\My -recurse | where-object { $_.Subject -match "CN=$FQDN" } | Where-Object { $_.NotAfter -lt $Date }
$WinRMListener = winrm enumerate winrm/config/listener | Select-String  'CertificateThumbprint = (.*)'
$WinRMThumbprint = $WinRMListener.Matches.Groups[1].Value

function ConfigWinRM {
    $SelfSignedCert = New-SelfSignedCertificate -Subject "CN=$FQDN" -TextExtension '2.5.29.37={text}1.3.6.1.5.5.7.3.1' -CertStoreLocation "cert:\LocalMachine\My" 
    winrm delete winrm/config/Listener?Address=*+Transport=HTTPS
    winrm create winrm/config/Listener?Address=*+Transport=HTTPS '@{Hostname="'"$FQDN"'";CertificateThumbprint="'"$($SelfSignedCert.Thumbprint)"'"}'
}

if ($null -eq $Cert) {
    ConfigWinRM
}elseif ($WinRMThumbprint -contains $ExpiredCert.Thumbprint) {
    ConfigWinRM
}

New-SelfSignedCertificate –DnsName DESKTOP-GHENXXX.my.domain.com -CertStoreLocation “cert:\LocalMachine\My”

$name = (Get-ComputerInfo).csname

$thumprint = (Get-ChildItem -Path Cert:LocalMachine\MY | where {$_.Subject -eq "CN=$name.my.domain.com"}).Thumbprint

#Variables

$CertLocation = 'C:\temp\VPN'
$Cert = ${CertPrefix}+"Client.pfx"
$CertName = "$CertLocation$Cert"
$CertPrefix = "b3VPN"

##Create a self-signed root certificate

if((Test-Path -Path $CertLocation -ErrorAction SilentlyContinue) -eq $false){
    mkdir $CertLocation
    cd $CertLocation
}
else {
    cd $CertLocation
}
$cert = New-SelfSignedCertificate -Type Custom -KeySpec Signature `
    -Subject "CN=${CertPrefix}Root" `
    -KeyExportPolicy Exportable `
    -HashAlgorithm sha256 `
    -KeyLength 2048 `
    -CertStoreLocation "Cert:\CurrentUser\My" `
    -KeyUsageProperty Sign -KeyUsage CertSign -NotAfter (Get-Date).AddMonths(24)

##Generate a client certificate

New-SelfSignedCertificate `
    -Type Custom `
    -DnsName P2SChildCert `
    -KeySpec Signature `
    -Subject "CN=${CertPrefix}Client" `
    -KeyExportPolicy Exportable `
    -HashAlgorithm sha256 `
    -KeyLength 2048 `
    -CertStoreLocation "Cert:\CurrentUser\My" `
    -Signer $cert `
    -TextExtension @("2.5.29.37={text}1.3.6.1.5.5.7.3.2") -NotAfter (Get-Date).AddMonths(24)

##Export Certificates

$RootCert = (Get-ChildItem `
    -Path "Cert:\CurrentUser\My\"`
    | Where-Object `
    -Property subject `
    -Match ${CertPrefix}Root)
$ClientCert = (Get-ChildItem `
    -Path "Cert:\CurrentUser\My\"`
    | Where-Object `
    -Property subject `
    -Match ${CertPrefix}Client)
Export-Certificate `
    -Type CERT `
    -Cert $RootCert `
    -FilePath "$CertLocation\${CertPrefix}RootTemp.cer"
Export-Certificate `
    -Type CERT `
    -Cert $ClientCert `
    -FilePath "$CertLocation\${CertPrefix}Client.cer"
C:\windows\system32\certutil.exe -encode "$CertLocation\${CertPrefix}RootTemp.cer" "${CertPrefix}Root.cer"
Get-Content $CertLocation\${CertPrefix}Root.cer
$SecurePassword = Read-Host `
    -Prompt "Enter Password to Export Cert with Private Key" `
    -AsSecureString
$ThumbPrint = $ClientCert.Thumbprint
$ExportPrivateCertPath = "Cert:\CurrentUser\My\$ThumbPrint"
Export-PfxCertificate `
    -FilePath "C:\temp\VPN\${CertPrefix}Client.pfx" `
    -Password $SecurePassword `
    -Cert $ExportPrivateCertPath

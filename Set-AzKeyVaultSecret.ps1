$GetSecretPass = Get-AzKeyVaultSecret -VaultName keyVault-20220308 -Name WinLogin
if ($null -eq $GetSecretPass) {
$Bytes = New-Object Byte[] 24
        ([System.Security.Cryptography.RandomNumberGenerator]::Create()).GetBytes($Bytes)
$Secret = [System.Convert]::ToBase64String($Bytes)
$Secret = ConvertTo-SecureString $Secret -AsPlainText -Force

Set-AzKeyVaultSecret -VaultName keyVault-20220308 -Name WinLogin -SecretValue $Secret
}

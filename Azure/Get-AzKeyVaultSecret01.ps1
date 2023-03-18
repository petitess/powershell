$secrets = Get-AzKeyVaultSecret -VaultName "kv-comp-infra-prod-01"

$secrets | ForEach-Object  {
$name = (Get-AzKeyVaultSecret -VaultName $_.VaultName -Name $_.Name).name
$value = Get-AzKeyVaultSecret -VaultName $_.VaultName -Name $_.Name -AsPlainText
Write-Host $name : $value
}

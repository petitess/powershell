Get-WindowsCapability -Name RSAT* -Online | Select-Object -Property DisplayName, Name, State

Get-WindowsCapability -Name "Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0" -Online | Select-Object DisplayName , State  
Get-WindowsCapability -Name "Rsat.CertificateServices.Tools~~~~0.0.1.0" -Online | Select-Object DisplayName , State
Get-WindowsCapability -Name "Rsat.DHCP.Tools~~~~0.0.1.0" -Online | Select-Object DisplayName , State
Get-WindowsCapability -Name "Rsat.Dns.Tools~~~~0.0.1.0" -Online | Select-Object DisplayName , State

Add-WindowsCapability -Online -Name "Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0"
Add-WindowsCapability -Online -Name "Rsat.CertificateServices.Tools~~~~0.0.1.0"
Add-WindowsCapability -Online -Name "Rsat.DHCP.Tools~~~~0.0.1.0"
Add-WindowsCapability -Online -Name "Rsat.Dns.Tools~~~~0.0.1.0"

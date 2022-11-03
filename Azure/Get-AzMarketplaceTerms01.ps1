#Todo
<# CIS Microsoft Windows Server 2019 Benchmark L1 - (center-for-internet-security-inc.cis-windows-server-2019-v1-0-0-l1.cis-ws2019-l1)
Enable
Disable
2021-11-30
CIS Microsoft Windows Server 2019 Benchmark L2 - (center-for-internet-security-inc.cis-windows-server-2019-v1-0-0-l2.cis-ws2019-l2)
Enable
Disable
2021-11-30
CIS Ubuntu Linux 18.04 LTS Benchmark L1 - (center-for-internet-security-inc.cis-ubuntu-linux-1804-l1.cis-ubuntu1804-l1)
Enable
Disable
2021-12-20
CIS Ubuntu Linux 20.04 LTS Benchmark L1 - (center-for-internet-security-inc.cis-ubuntu-linux-2004-l1.cis-ubuntu2004-l1)
Enable
Disable
2021-12-20
Fortinet FortiGate-VM (BYOL) - (fortinet.fortinet_fortigate-vm_v5.fortinet_fg-vm)
Enable
Disable
2022-01-10
Ubuntu Pro 18.04 LTS - (canonical.0001-com-ubuntu-pro-bionic.pro-18_04-lts)
Enable
Disable
2022-01-05
Windows 10 Enterprise multi-session, version 21H1 - (microsoftwindowsdesktop.windows-10.21h1-evd)
Enable
Disable
2022-01-14 #>

$Terms = Get-AzMarketplaceTerms -Publisher MicrosoftWindowsDesktop -Product Windows-10 -Name 21h1-evd
Set-AzMarketplaceTerms -Publisher MicrosoftWindowsDesktop -Product Windows-10 -Name 21h1-evd -Terms $Terms -Accept

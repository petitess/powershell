$hostName="vmdcprod01.ad.comp.se" 
$winrmPort = "5986"
$cred = Get-Credential
$soptions = New-PSSessionOption -SkipCACheck
Invoke-Command -ComputerName $hostName -Port $winrmPort -Credential $cred -SessionOption $soptions -UseSSL -ScriptBlock {Start-ADSyncSyncCycle -PolicyType delta}

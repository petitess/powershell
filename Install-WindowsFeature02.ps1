Install-WindowsFeature -IncludeAllSubFeature RSAT'

Get-WindowsFeature | Where-Object {$_.Name -like 'RSAT*'} | select Name,DisplayName                               
     
Get-WindowsFeature -Name RSAT-AD-Tools  | Select-Object Name , InstallState  
Get-WindowsFeature -Name RSAT-DHCP | Select-Object Name , InstallState        
Get-WindowsFeature -Name RSAT-DNS-Server | Select-Object Name , InstallState 
Get-WindowsFeature -Name RSAT-ADCS | Select-Object Name , InstallState           

Install-WindowsFeature -Name RSAT-AD-Tools      
Install-WindowsFeature -Name RSAT-DHCP 
Install-WindowsFeature -Name RSAT-DNS-Server     
Install-WindowsFeature -Name RSAT-ADCS 

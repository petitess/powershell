#Generic Konfiguration
$vSwitch = "LAN"
$VHDXCurrentPath = "G:\Hyper-V-VMs\Q\Q\Virtual Hard Disks"
$VHDXDestinationPath = "G:\Hyper-V-VMs\VMauto"
$SubMaskBit = "24"

#####################################
#####################################
#####################################
############Skapa ADD01##############

#Skapa variabel för ADD01



#AD Server konfiguration variabel
$ADName = "ADK001"
$ADIP = "192.168.0.220"
#Domän information
$DomainMode = "WinThreshold"
$ForestMode = "WinThreshold"
$DomainName = "xstile.se"
$DSRMPWord = ConvertTo-SecureString -String "Sommar2020" -AsPlainText -Force

#Lokal admin konto används för att kunna logga på ADD01 för att konfigurera samt för invoke-command
$DCLocalUser = "$ADName\Administrator"
$DCLocalPWord = ConvertTo-SecureString -String "Sommar2020" -AsPlainText -Force
$DCLocalCredential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $DCLocalUser, $DCLocalPWord

#Domän admin konto används efter att du har promota server till AD
$DomainUser = "$DomainName\administrator"
$DomainPWord = ConvertTo-SecureString -String "Sommar2020" -AsPlainText -Force
$DomainCredential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $DomainUser, $DomainPWord


#Kopiera VM template som vi har skapat.
Write-Verbose "Check if folder for VM exist"

$cpath = Test-Path "G:\Hyper-V-VMs\VMauto\$($ADName)"

if($cpath -eq  $false){
    Write-Verbose "Folder doest not exist, creating folder" -Verbose

    New-item -Name $ADName -Path "G:\Hyper-V-VMs\VMauto\" -ItemType Directory | Out-Null

    Write-Verbose "Folder is created, copy template VM" -Verbose

    Copy-Item "$VHDXCurrentPath\MASTER.vhdx" "$VHDXDestinationPath\$ADNAME\$ADNAME.vhdx"
    
}else{


    Write-Verbose "Folder already exist" -Verbose
    Write-Verbose "copy template VM" -Verbose

    Copy-Item "$VHDXCurrentPath\MASTER.vhdx" "$VHDXDestinationPath\$DCNAME\$ADNAME.vhdx"

}



#Skapa VM ADD01
New-VM -Name $ADName -MemoryStartupBytes 3GB -VHDPath "$VHDXDestinationPath\$ADNAME\$ADNAME.vhdx" -Generation 2 -SwitchName $vSwitch 
Set-VM -Name $ADName -AutomaticCheckpointsEnabled $false
Write-Verbose "VM Creation Completed. Starting VM [$ADName]" -Verbose
Start-VM -Name $ADName

#Vänta att VM ska komma igång
Write-Verbose “Waiting for PowerShell Direct to start on VM [$ADName]” -Verbose
   while ((icm -VMName $ADName -Credential $DCLocalCredential {“Test”} -ea SilentlyContinue) -ne “Test”) {Sleep -Seconds 1}


Write-Verbose “[$ADName] is alive moving to IP config and change computername” -Verbose


#Konfigurera IP Adress till ADD01 och byter namn
Invoke-Command -vmname $ADName -Credential $DCLocalCredential -ScriptBlock { 
    param ($ADIP, $ADName)
    
    new-NetIPAddress -InterfaceIndex (Get-NetAdapter).ifIndex -IPAddress $ADIP -PrefixLength 24 -DefaultGateway 192.168.0.1
    Set-DnsClientServerAddress -InterfaceIndex (Get-NetAdapter).ifIndex -ServerAddresses ("8.8.8.8")

    Rename-Computer -NewName $ADName -Force

    
} -ArgumentList $ADIP, $ADName

#Start om VM efter namnbytet
Write-Verbose "Rebooting VM [$ADName] for hostname change to take effect" -Verbose
Stop-VM -Name $ADName -Force
Start-VM -Name $ADName

Write-Verbose “Waiting for PowerShell Direct to start on VM [$ADName]” -Verbose
   while ((icm -VMName $ADName -Credential $DCLocalCredential {“Test”} -ea SilentlyContinue) -ne “Test”) {Sleep -Seconds 1}



Write-Verbose "PowerShell Direct responding on VM [$ADName]. Moving On...." -Verbose


#Installera ADDS rollen
Invoke-Command -VMName $ADName -Credential $DCLocalCredential -ScriptBlock {
    param ($ADName, $DomainMode, $ForestMode, $DomainName, $DSRMPWord) 
    Write-Verbose "Installing Active Directory Services on VM [$ADName]" -Verbose
    Install-WindowsFeature -Name "AD-Domain-Services" -IncludeManagementTools
    Write-Verbose "Configuring New Domain with Name [$DomainName] on VM [$ADName]" -Verbose
    Install-ADDSForest -ForestMode $ForestMode -DomainMode $DomainMode -DomainName $DomainName `
    -InstallDns -NoDNSonNetwork -SafeModeAdministratorPassword $DSRMPWord -Force -NoRebootOnCompletion
    
    #Restart-Computer
    } -ArgumentList $ADName, $DomainMode, $ForestMode, $DomainName, $DSRMPWord

Write-Verbose "Rebooting VM [$ADName] to complete installation of new AD Forest" -Verbose
Stop-VM -Name $ADName -Force
Start-VM -Name $ADName

Write-Verbose “Waiting for PowerShell Direct to start on VM [$ADName]” -Verbose
   while ((icm -VMName $ADName -Credential $DomainCredential {“Test”} -ea SilentlyContinue) -ne “Test”) {Sleep -Seconds 1}

Write-Verbose "PowerShell Direct responding on VM [$ADName]. Moving On...." -Verbose

Write-Verbose "DC Provisioning Complete!!!!" -Verbose




######################################################
######################################################
###################Skapa Fil server###################
$FileServer = "FileS01"
$FileServerIP = "192.168.10.111"
#Lokal admin lösen används innan du server blir en AD Server
$FileLocalUser = "$FileServer\Administrator"
$FileLocalPWord = ConvertTo-SecureString -String "Sommar2020" -AsPlainText -Force
$FileLocalCredential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $FileLocalUser, $FileLocalPWord

#Kopiera VM template till lagringplats
Write-Verbose "Check if folder for VM exist"

$cpath = Test-Path "C:\VM\$($FileServer)"

if($cpath -eq  $false){
    Write-Verbose "Folder doest not exist, creating folder" -Verbose

    New-item -Name $FileServer -Path "C:\VM\" -ItemType Directory | Out-Null

    Write-Verbose "Folder is created, copy template VM" -Verbose

    Copy-Item "$VHDXCurrentPath\MASTER.vhdx" "$VHDXDestinationPath\$FileServer\$FileServer.vhdx"
    
}else{


    Write-Verbose "Folder already exist" -Verbose
    Write-Verbose "copy template VM" -Verbose

    Copy-Item "$VHDXCurrentPath\MASTER.vhdx" "$VHDXDestinationPath\$FileServer\$FileServer.vhdx"

}


#Skapa VM File01
New-VM -Name $FileServer -MemoryStartupBytes 1GB -VHDPath "$VHDXDestinationPath\$FileServer\$FileServer.vhdx" -Generation 2 -SwitchName $vSwitch 
Set-VM -Name $FileServer -AutomaticCheckpointsEnabled $false
Write-Verbose "VM Creation Completed. Starting VM [$FileServer]" -Verbose
Start-VM -Name $FileServer

#Vänta att VM ska komma igång
Write-Verbose “Waiting for PowerShell Direct to start on VM [$FileServer]” -Verbose
   while ((icm -VMName $FileServer -Credential $FileLocalCredential {“Test”} -ea SilentlyContinue) -ne “Test”) {Sleep -Seconds 1}


Write-Verbose “[$FileServer] is alive moving to IP config and change computername” -Verbose


#Konfigurera IP Adress till Filserver och byter namn
Invoke-Command -vmname $FileServer -Credential $FileLocalCredential -ScriptBlock { 

    $FileServer = "FileS01"
    new-NetIPAddress -InterfaceIndex (Get-NetAdapter).ifIndex -IPAddress 192.168.10.111 -PrefixLength 24 -DefaultGateway 192.168.10.1
    Set-DnsClientServerAddress -InterfaceIndex (Get-NetAdapter).ifIndex -ServerAddresses ("192.168.10.100")

    #Rename-Computer -NewName $FileServer
   
}



Write-Verbose "Rebooting VM [$FileServer] to complete name change" -Verbose
Stop-VM -Name $FileServer -Force
Start-VM -Name $FileServer


Write-Verbose “Waiting for PowerShell Direct to start on VM [$FileServer]” -Verbose
   while ((icm -VMName $FileServer -Credential $FileLocalCredential {“Test”} -ea SilentlyContinue) -ne “Test”) {Sleep -Seconds 1}

   
#Joina File01 till Domän
Invoke-Command -vmname $FileServer -Credential $FileLocalCredential -ScriptBlock { 

    param ($FileServer, $DomainName, $DomainCredential )
  Add-Computer -ComputerName $FileServer -DomainName $Domainname -Credential $DomainCredential

     
} -ArgumentList $FileServer, $DomainName, $DomainCredential


Write-Verbose "Rebooting VM [$FileServer] after domain join" -Verbose
Stop-VM -Name $FileServer -Force
Start-VM -Name $FileServer

Write-Verbose “Waiting for PowerShell Direct to start on VM [$FileServer]” -Verbose
   while ((icm -VMName $FileServer -Credential $FileLocalCredential {“Test”} -ea SilentlyContinue) -ne “Test”) {Sleep -Seconds 1}









#######################File01 server konfiguration slut#######################

Write-Verbose "Nästa steg är konfiguration av ADD01" -Verbose 

##############Fortsättning av konfiguration av ADD01#########################


#Skapa OU och importera användarna
Write-Verbose "Påbörja konfiguration av användare" -Verbose
$ADuserCSV = Import-Csv -Delimiter "," -LiteralPath "C:\Temp\xstile users.csv"
$OUpath = 'ou=xstile,dc=xstile,dc=se'
$Password = "Sommar2020"

Invoke-Command -VMName $ADName -Credential $DomainCredential -ScriptBlock {
    param ($ADuserCSV,$OUpath,$Password) 
    New-ADOrganizationalUnit -Name "xstile" -Path "dc=xstile,dc=se"
    
    foreach ($user in $ADuserCSV){
           
        
        New-ADUser -Name ($user.givenname + " " + $user.surname) `
        -SamAccountName $user.SamAccountName `
        -UserPrincipalName ($user.SamAccountName + "@mcampus.se") `
        -GivenName $user.givenname `
        -Surname $user.surname `
        -DisplayName ($user.givenname + " " + $user.surname) `
        -AccountPassword (ConvertTo-SecureString $Password -AsPlainText -Force) `
        -Enabled $true `
        -Path $OUpath

                  

    }
} -ArgumentList $ADuserCSV, $OUpath, $Password


Write-Verbose "Användarna är konfigurerade" -Verbose





#Crete group
Write-Verbose "Påbörja konfiguration av grupper" -Verbose
Invoke-Command -VMName $ADName -Credential $DomainCredential -ScriptBlock {

    $group = "SEC_Sales","SEC_IT","SEC_Scode","SEC_Ekonomi","SEC_IT","SEC_Ägare","SEC_App","SEC_Gemensam"

        foreach ($i in $group){
       
       New-ADGroup -name $i -path "ou=xstile,dc=xstile,dc=se" -groupscope Global -groupcategory Security

 } 



}
Write-Verbose "Grupperna är färdig konfigurerad" -Verbose








#Add user to group
Write-Verbose "Lägger till användarna i rätt grupp" -Verbose
Invoke-Command -VMName $ADName -Credential $DomainCredential -ScriptBlock{
    $OUpath = "ou=xstile,dc=xstile,dc=se"

    $SEC_Sales = "Victor.carave","David.laurin"
    $SEC_IT = "Victor.carave","mats.nygren","tord.berner"
    $SEC_Scode = "Victor.carave","mats.nygren"
    $SEC_Ekonomi = "Victor.carave","mats.nygren"
    $SEC_IT = "malin.helander","karol.sek"
    $SEC_Ägare = "Victor.carave","tord.berner"
    $SEC_App = "Victor.carave","mats.nygren"
    $SEC_Gemensam = "Victor.carave","anders.andersson"

    #lägger till Sales användare
    foreach($user in $SEC_Sales){
        
       add-ADgroupmember -identity "SEC_Sales" -members $user 
    }

    #lägger till IT användare
    foreach($user in $SEC_IT){
    
            add-ADgroupmember -identity "SEC_IT" -members $user 

    }

    #lägger till Scode användare
    foreach($user in $SEC_Scode){
        
        add-ADgroupmember -identity "SEC_Scode" -members $user 

    }

 }
Write-Verbose "Användarna är har lagt till i grupperna" -Verbose


##############Konfiguration av ADD01 är klar#########################


##############Konfiguration av File01#########################



#Create folder
Write-Verbose "Skapa mappar" -Verbose

Invoke-Command -VMName $FileServer -Credential $DomainCredential -ScriptBlock{
    
    $mapp = "Gemensam","Scode","Ekonomi","IT","Ägare","App"
    
    foreach ($i in $mapp){
       
       New-Item -Name $i -Path "C:\" -ItemType Directory
    

 } 

}
Write-Verbose "Mapparna är skapad" -Verbose




#Dela utmapparna och sätter behörigheter
Write-Verbose "Skapa nätverksmappar och sätter rättigheter" -Verbose
Invoke-Command -VMName $FileServer -Credential $DomainCredential -ScriptBlock{
    

    
    New-SmbShare -Name "App" -Path "C:\App" -FullAccess "SEC_Sales"
    New-SmbShare -Name "Ekonomi" -Path "C:\Ekonomi" -FullAccess "SEC_Ekonomi"
    New-SmbShare -Name "Gemensam" -Path "C:\Gemensam" -FullAccess "SEC_Gemensam"
    New-SmbShare -Name "IT" -Path "C:\IT" -FullAccess "SEC_IT"
    New-SmbShare -Name "Scode" -Path "C:\Scode" -FullAccess "SEC_Scode"
    New-SmbShare -Name "Ägare" -Path "C:\Ägare" -FullAccess "SEC_Ägare"

}
Write-Verbose "Mapparna utdelad och konfigurarad" -Verbose


##############Konfiguration av File01 är klar#########################








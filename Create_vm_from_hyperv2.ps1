#Generic Konfiguration
$vSwitch = "LAN"
$VHDXCurrentPath = "G:\Hyper-V-VMs\sysprep\sysprep\Virtual Hard Disks"
$VHDXDestinationPath = "G:\Hyper-V-VMs\VMauto"
$SubMaskBit = "24"

#####################################
############Skapa Server01##############
$ADName = "Server01"


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



#Skapa VM Server01
New-VM -Name $ADName -MemoryStartupBytes 3GB -VHDPath "$VHDXDestinationPath\$ADNAME\$ADNAME.vhdx" -Generation 2 -SwitchName $vSwitch 
Set-VM -Name $ADName -AutomaticCheckpointsEnabled $false
Write-Verbose "VM Creation Completed. Starting VM [$ADName]" -Verbose
Start-VM -Name $ADName



######################################################
######################################################
###################Skapa RDS server###################
$FileServer = "RDS01"


#Kopiera VM template till lagringplats
Write-Verbose "Check if folder for VM exist"

$cpath = Test-Path "G:\Hyper-V-VMs\VMauto\$($FileServer)"

if($cpath -eq  $false){
    Write-Verbose "Folder doest not exist, creating folder" -Verbose

    New-item -Name $FileServer -Path "G:\Hyper-V-VMs\VMauto\" -ItemType Directory | Out-Null

    Write-Verbose "Folder is created, copy template VM" -Verbose

    Copy-Item "$VHDXCurrentPath\MASTER.vhdx" "$VHDXDestinationPath\$FileServer\$FileServer.vhdx"
    
}else{


    Write-Verbose "Folder already exist" -Verbose
    Write-Verbose "copy template VM" -Verbose

    Copy-Item "$VHDXCurrentPath\MASTER.vhdx" "$VHDXDestinationPath\$FileServer\$FileServer.vhdx"

}


#Skapa VM File01
New-VM -Name $FileServer -MemoryStartupBytes 3GB -VHDPath "$VHDXDestinationPath\$FileServer\$FileServer.vhdx" -Generation 2 -SwitchName $vSwitch 
Set-VM -Name $FileServer -AutomaticCheckpointsEnabled $false
Write-Verbose "VM Creation Completed. Starting VM [$FileServer]" -Verbose
Start-VM -Name $FileServer
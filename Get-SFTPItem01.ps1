#Install module
#install-module posh-ssh -Confirm:$false
#Get-Command *sftp*

#This script connects to a SFTP server
#Downloads files from SFTP to a folder with today's date
#Compares file size with files in the main folder
#If there is a difference copies new files to main folder
#Removes folders older than 3 days

$ErrorActionPreference = "Stop"
$password = ConvertTo-SecureString "xxxx" -AsPlainText -Force
$creds = New-Object System.Management.Automation.PSCredential ("username", $password)
$session = New-SFTPSession -Computername sftp.site.net -Port 2222 -Credential $creds -Verbose
$source = "/"
$items = Get-SFTPChildItem -Recursive $session -Path $source
$localDestination = "D:\AVD"
$date = Get-Date -Format 'yyyy-MM-dd-HH-mm'

if (Test-Path -Path "$localDestination\Filer_$date") {
Write-Output "Folder Filer_$date exists"
}else{
New-Item -Path "$localDestination\Filer_$date" -ItemType Directory -Force
}

foreach ($item in $items) {
Get-SFTPItem -SessionId $session.SessionID -Path $item.FullName -Destination "$localDestination\Filer_$date" -Force
}

$latestFolder = Get-ChildItem -Path $localDestination -Directory | Sort-Object -Descending -Property LastWriteTime | select -First 1
$lastestFiles = Get-ChildItem -Path $localDestination\$latestFolder

foreach ($file in $lastestFiles) {

if($file.Length -eq (Get-ChildItem -Path $localDestination | where {$_.Name -eq $file.Name}).Length) {
Write-Output "The same size: $file"}

else{

Copy-Item -Path $localDestination\$latestFolder\$file -Destination $localDestination -Force
}
}

$oldFolders = Get-ChildItem $localDestination | where {$_.Name -match "Filer" -and $_.CreationTime -lt (Get-Date).AddDays(-3)}
$oldFolders | Remove-Item -Force -Confirm:$false

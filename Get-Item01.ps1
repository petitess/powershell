#Checking if a Registry Key Exists
$Key = "HKEY_LOCAL_MACHINE\SOFTWARE\FSLogix\Profiles"
If(Test-Path -Path "Registry::$Key") {
    Write-host -f Green "Key Exists!"
}
Else {
    Write-host -f Yellow "Key doesn't Exists!"
}

#Checking if a Registry Value Exists
$RegPath = "HKLM:\SOFTWARE\FSLogix\Profiles"
$RegValue = "Version"
 
$RegistryKey = Get-Item -Path $RegPath -ErrorAction SilentlyContinue
if ($RegistryKey.GetValueNames() -contains $RegValue) {
    # Value exists
    Write-host -f Green "Value Exists!"
}
else {
    # Value does not exist
    Write-host -f Yellow "Value Doesn't Exists!"
}

#Classic menu context
$TestPath = Test-Path -Path 'HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}' 
if(!$TestPath) {
New-Item –Path $RegPathMenu –Name "{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}"
New-Item –Path "$RegPathMenu\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" –Name "InprocServer32"
}
##

$TestPath = Test-Path -Path 'HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}' 
if(!$TestPath) {
New-Item –Path 'HKCU:\Software\Classes\CLSID' –Name '{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}'
New-Item –Path 'HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}' –Name "InprocServer32"
}

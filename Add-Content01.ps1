if(!((Select-String -Path $env:windir\System32\drivers\etc\hosts -Pattern "vmprofiledev01") -ne $null)){
    Add-Content -Path $env:windir\System32\drivers\etc\hosts -Value "`n10.100.55.6`tvmprofiledev01" -Force
}

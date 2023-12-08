New-Item -ItemType "directory" -Path D:\Windows\FXCustomRedir
$content = Get-Content .\iac\scripts\redirections.xml
New-Item -ItemType File -Name redirections.xml -Path D:\Windows\FXCustomRedir -Force
Set-Content -Path D:\Windows\FXCustomRedir\redirections.xml -Value $content

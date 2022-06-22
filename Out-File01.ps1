Get-ChildItem 'C:\Users\karol\Music\disco polo 1' | select name | Out-File C:\Users\karol\Music\DISCOPOLO.TXT

Get-ChildItem 'C:\Users\karol\Music\POLSKIE' | select name | Out-File C:\Users\karol\Music\POLSKIE.TXT

####NAME WITHOUT .MP3
$name = Get-ChildItem 'C:\Users\karol\Music\disco polo 1' | select name
$name.name.replace(".mp3","") | Out-File C:\Users\karol\Music\DISCOPOLO.TXT

$name | Select-Object -First 100



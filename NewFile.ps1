#Create a new file
New-Item -Path C:\Users\sek\Desktop -ItemType File -Name myfile.txt
#Create a new file with content
Set-Content -Path "C:\inetpub\wwwroot\Default.html" -Value "This is the server $($env:computername) !"

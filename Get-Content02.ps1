(Get-Content D:\list.txt).ForEach({ '"{0}"' -f $_ })  | Set-Content -Path D:\newlist.txt

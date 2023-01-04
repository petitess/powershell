Get-EventLog -LogName Security - | Where-Object {$_.EventID -eq 4625} 

Get-EventLog security -source microsoft-windows-security-auditing -After | where {($_.instanceID -eq 4624) -and ($_.replacementstrings[5] -eq 'nmu842')} | select * | ogv

Get-EventLog security -source microsoft-windows-security-auditing  | where {($_.instanceID -eq 4624) -and ($_.replacementstrings[5] -eq 'nmu842')} | select * | ogv
